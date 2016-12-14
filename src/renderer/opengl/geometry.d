module renderer.opengl.geometry;

import renderer.opengl.util : checkgl;

import derelict.opengl3.gl3;

struct Geometry
{
	~this()
	{
		destroy();
	}

	void	create()
	{
		checkgl!glGenVertexArrays(1, &mVAO);
		checkgl!glBindVertexArray(mVAO);
		checkgl!glGenBuffers(1, &mBufferId);
	}

	void	set()
	{
		static const GLfloat[]	data = [
			-1.0f, -1.0f, 0.0f,
			1.0f, -1.0f, 0.0f,
			0.0f,  1.0f, 0.0f,
		];

		checkgl!glBindBuffer(GL_ARRAY_BUFFER, mBufferId);
		checkgl!glBufferData(GL_ARRAY_BUFFER, data.length * GLfloat.sizeof, data.ptr, GL_STATIC_DRAW);
	}

	void	draw()
	{
		checkgl!glEnableVertexAttribArray(0);
		checkgl!glBindBuffer(GL_ARRAY_BUFFER, mBufferId);
		checkgl!glVertexAttribPointer(
							  0,                  // attribute 0. No particular reason for 0, but must match the layout in the shader.
							  3,                  // size
							  GL_FLOAT,           // type
							  GL_FALSE,           // normalized?
							  0,                  // stride
							  cast(void*)0        // array buffer offset
							  );
		// Draw the triangle !
		checkgl!glDrawArrays(GL_TRIANGLES, 0, 3); // Starting from vertex 0; 3 vertices total -> 1 triangle
		checkgl!glDisableVertexAttribArray(0);
	}

	void	destroy()
	{
		checkgl!glDeleteBuffers(1, &mBufferId);
		checkgl!glDeleteVertexArrays(1, &mVAO);
		mVAO = 0;
	}

private:
	GLuint mVAO = 0;
	GLuint mBufferId = 0;
}
