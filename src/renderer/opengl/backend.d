module renderer.opengl.backend;

import renderer.opengl.util : checkgl;
import renderer.opengl.geometry;

import derelict.opengl3.gl3;

import std.experimental.logger;
import std.string;

static Backend	backend;

struct Backend
{
	void	initialize()
	{
		DerelictGL3.load();
		DerelictGL3.reload();

		infof("OpenGL Vendor: \"%s\"", fromStringz(glGetString(GL_VENDOR)));
		infof("OpenGL Renderer: \"%s\"", fromStringz(glGetString(GL_RENDERER)));
		infof("OpenGL Version: \"%s\"", fromStringz(glGetString(GL_VERSION)));
//		infof("OpenGL Extensions: \"%s\"", fromStringz(glGetString(GL_EXTENSIONS)));
		infof("OpenGL GLSL Version: \"%s\"", fromStringz(glGetString(GL_SHADING_LANGUAGE_VERSION)));

		triangle.create();
		triangle.set();
	}

	void	draw()
	{
        checkgl!glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		triangle.draw();
	}

private:
	Geometry	triangle;
}

version (Windows)
{
	string glfw3LibPath = "lib/glfw3.dll";
}
else
{
	static assert(false); 
}
