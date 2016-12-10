import std.stdio;

import derelict.glfw3.glfw3;
//import core.sys.windows.windows : HWND, HGLRC;
//mixin DerelictGLFW3_WindowsBind;

import derelict.opengl3.gl3;

version (Windows)
{
	string glfw3LibPath = "lib/glfw3.dll";
}
else
{
	static assert(false); 
}

void main()
{
//	DerelictGLFW3.load(SharedLibVersion(3, 2, 1));
	DerelictGLFW3.load(glfw3LibPath);
//	DerelictGLFW3_loadWindows();

	DerelictGL3.load();

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

	DerelictGL3.reload();

    /* Loop until the user closes the window */
    while (!glfwWindowShouldClose(window))
    {
        /* Render here */
        glClear(GL_COLOR_BUFFER_BIT);

        /* Swap front and back buffers */
        glfwSwapBuffers(window);

        /* Poll for and process events */
        glfwPollEvents();
    }

    glfwTerminate();
}
