import platform.windows;

import renderer.opengl.backend;
import core.nogc_memory;

import ecs.core.aspect_engine;

import ecs.render.frame_graph;

import derelict.glfw3.glfw3;
//import core.sys.windows.windows : HWND, HGLRC;
//mixin DerelictGLFW3_WindowsBind;

import std.stdio;
import std.experimental.logger;

FrameGraph	rootFrameGraph;

void main()
{
	version(release) globalLogLevel = LogLevel.trace;

	debug infof("Running in debug");

//	DerelictGLFW3.load(SharedLibVersion(3, 2, 1));
	DerelictGLFW3.load(glfw3LibPath);
//	DerelictGLFW3_loadWindows();

	GLFWwindow*	window;

    /* Initialize the library */
    if (!glfwInit())
        return;

    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(640, 480, "Hello World", null, null);
    if (!window)
    {
        glfwTerminate();
        return;
    }

    /* Make the window's context current */
    glfwMakeContextCurrent(window);

	glfwSwapInterval(0);	// Disable the vsync

	backend.initialize();

//	initializeFrameGraph();

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
//		rootFrameGraph.execute();

		backend.draw();

        /* Swap front and back buffers */
        glfwSwapBuffers(window);

        /* Poll for and process events */
        glfwPollEvents();
    }

    glfwTerminate();
}

void	initializeSceneGraph()
{
}

void	initializeFrameGraph()
{
	import ecs.render.frame_graph_node;
	import ecs.render.viewport;
	import ecs.render.clear_buffer;

	Viewport	viewport = nogcNew!Viewport();
	ClearBuffer	clearBuffers = nogcNew!ClearBuffer(viewport);

	clearBuffers.buffers = ClearBuffer.BufferType.ColorDepthBuffer;
	clearBuffers.color = Color(1.0, 0.0, 1.0, 1.0);

	rootFrameGraph = nogcNew!FrameGraph();
	rootFrameGraph.setRoot(viewport);
}
