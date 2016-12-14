module renderer.opengl.shader;

import renderer.opengl.util : checkgl;

import derelict.opengl3.gl3;

struct Shader
{
	void	load(ref const string vertexFilePath, ref const string fragmentFilePath)
	{
	}

	void	use()
	{
	}

private:
	GLuint	mProgram = 0;
}
