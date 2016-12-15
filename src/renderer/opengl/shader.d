module renderer.opengl.shader;

import renderer.opengl.util : checkgl;
import renderer.opengl.backend;

import derelict.opengl3.gl3;

import std.experimental.logger;
import std.file;

struct Shader
{
	void	create()
	{
		mGLSLVersion = backend.GLSLVersion;
	}

	void	load(string filePath, GLenum type)
	{
		mFilePath = filePath;
		mSource = cast(string)read(filePath);
		mType = type;

		mId = checkgl!glCreateShader(mType);
	}

	void	compile()
	{
		GLint	length;

		length = cast(GLint)mSource.length;

		auto	ssp = mSource.ptr;
		checkgl!glShaderSource(mId, 1, &ssp, &length);

		checkgl!glCompileShader(mId);

		GLint status;
		checkgl!glGetShaderiv(mId, GL_COMPILE_STATUS, &status);

		if (status == GL_FALSE)
		{
			GLint logLength;
			checkgl!glGetShaderiv(mId, GL_INFO_LOG_LENGTH, &logLength);

			if (logLength > 0)
			{
				ubyte[]	log;

				log.length = logLength;
				checkgl!glGetShaderInfoLog(mId, logLength, &logLength, cast(GLchar*)log.ptr);

				critical(cast(string)log);
			}
			criticalf("Failed to compile shader: %s", mFilePath);
		}
	}

private:
	GLuint	mId;
	GLenum	mType;

	string	mGLSLVersion;
	string	mPreprocessors;
	string	mFilePath;
	string	mSource;
}

struct ShaderProgram
{
	void	create()
	{
		mProgram = checkgl!glCreateProgram();
	}

	void	attachShader(ref const Shader shader)
	{
		checkgl!glAttachShader(mProgram, shader.mId);
	}

	void	link()
	{
		checkgl!glLinkProgram(mProgram);

		GLint status;
		checkgl!glGetProgramiv(mProgram, GL_LINK_STATUS, &status);
		if (status == GL_FALSE)
		{
			debug	// Retrieve the log
			{
				//checkgl!glValidateProgram(mShaderProgram);
				GLint	logLength;
				checkgl!glGetProgramiv(mProgram, GL_INFO_LOG_LENGTH, &logLength);
				if (logLength > 0)
				{
					GLchar[]	log = new char[](logLength);

					glGetProgramInfoLog(mProgram, logLength, &logLength, log.ptr);
					if (logLength > 0)	// It seems GL_INFO_LOG_LENGTH can return 1 instead of 0
						critical("Shader log :\n" ~ log);
				}
			}
			critical("Failed to link program");
		}
	}

	void	use()
	{
		checkgl!glUseProgram(mProgram);
	}

private:
	GLuint	mProgram = 0;
}
