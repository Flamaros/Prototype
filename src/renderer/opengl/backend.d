module renderer.opengl.backend;

import renderer.opengl.util : checkgl;
import renderer.opengl.geometry;
import renderer.opengl.shader;

import derelict.opengl3.gl3;

import std.experimental.logger;
import std.string;
import std.conv;

static Backend	backend;

struct Backend
{
	void	initialize()
	{
		DerelictGL3.load();
		DerelictGL3.reload();

		OpenGLVersion = to!string(glGetString(GL_VERSION));
		GLSLVersion = to!string(glGetString(GL_SHADING_LANGUAGE_VERSION));
		infof("OpenGL Vendor: \"%s\"", fromStringz(glGetString(GL_VENDOR)));
		infof("OpenGL Renderer: \"%s\"", fromStringz(glGetString(GL_RENDERER)));
		infof("OpenGL Version: \"%s\"", OpenGLVersion);
//		infof("OpenGL Extensions: \"%s\"", fromStringz(glGetString(GL_EXTENSIONS)));
		infof("OpenGL GLSL Version: \"%s\"", GLSLVersion);

		triangle.create();
		triangle.set();

		Shader	vertexShader;
		Shader	fragmentShader;

		vertexShader.create();
		vertexShader.load("data/shaders/DiffuseColor.vsh", GL_VERTEX_SHADER);
		vertexShader.compile();

		fragmentShader.create();
		fragmentShader.load("data/shaders/DiffuseColor.fsh", GL_FRAGMENT_SHADER);
		fragmentShader.compile();

		program.create();
		program.attachShader(vertexShader);
		program.attachShader(fragmentShader);
		program.link();
	}

	void	draw()
	{
        checkgl!glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
		triangle.draw();
	}

package:
	// TODO clean version string to be usable in shaders,...
	string	OpenGLVersion;
	string	GLSLVersion;

private:
	Geometry		triangle;
	ShaderProgram	program;
}

version (Windows)
{
	string glfw3LibPath = "lib/glfw3.dll";
}
else
{
	static assert(false); 
}
