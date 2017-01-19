import platform.windows;

import renderer.scene;

import derelict.glfw3.glfw3;
//import core.sys.windows.windows : HWND, HGLRC;
//mixin DerelictGLFW3_WindowsBind;

import std.stdio;
import std.experimental.logger;

void main()
{
	version(release) globalLogLevel = LogLevel.trace;

//	DerelictGLFW3.load(SharedLibVersion(3, 2, 1));
	DerelictGLFW3.load(glfw3LibPath);
//	DerelictGLFW3_loadWindows();

	GLFWwindow*	window;

    /* Initialize the library */
    if (!glfwInit())
        return;

    /* Create a windowed mode window and its OpenGL context */
    window = glfwCreateWindow(800, 600, "Hello World", null, null);
    if (!window)
    {
        glfwTerminate();
        return;
    }

    /* Make the window's context current */
    glfwMakeContextCurrent(window);
	glfwSwapInterval(0);	// Disable the vsync

	backend.initialize();

	Scene	scene;

	initScene(scene);

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
		scene.draw();

        /* Swap front and back buffers */
        glfwSwapBuffers(window);

        /* Poll for and process events */
        glfwPollEvents();
    }

    glfwTerminate();
}

void	initScene(ref Scene scene)
{
}

version (Windows)
{
	string glfw3LibPath = "lib/glfw3.dll";
}
else
{
	static assert(false); 
}
