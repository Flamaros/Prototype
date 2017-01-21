module renderer.opengl.util;

private {
    import derelict.opengl3.gl3 : GLenum,
		glGetError,
		GL_NO_ERROR, GL_INVALID_ENUM, GL_INVALID_VALUE, GL_INVALID_OPERATION, GL_INVALID_FRAMEBUFFER_OPERATION,	GL_OUT_OF_MEMORY;

    import std.traits : ReturnType;
}

static const uint						errorMessageMaximumLength = 4096;
static char[errorMessageMaximumLength]	errorMessage = "\0";
static uint								offset = 0;

template checkgl(alias func)
{
    debug
	@nogc
	ReturnType!func checkgl(Args...)(Args args)
	{
		uint	offset = 0;

        if (glGetError is null)
		{
			concatErrorMessage("OpenGL don't seems loaded (glGetError is not reachable).");
			assert(false);
        }

		if (func is null)
		{
			concatErrorMessage("OpenGL don't seems loaded or function \"");
			concatErrorMessage(func.stringof);
			concatErrorMessage("\" isn't supported by your driver");
			assert(false);
        }

		// Clear error state
        glGetError();

        scope (success)	// will be called after the return
		{
            GLenum	error = glGetError();

            if (error != GL_NO_ERROR)
			{
				concatErrorMessage("OpenGL error: ");
				concatErrorMessage(openglErrorToString(error));
				concatErrorMessage(" passed to function \"");
				concatErrorMessage(func.stringof);
				concatErrorMessage("\"");
				assert(false);
            }
        }

        return func(args);
    }
	else
	{
        alias checkgl = func;
    }
}

/// Converts an OpenGL errorenum to a string
@nogc
string openglErrorToString(GLenum error)
{
    final switch(error)
	{
        case GL_NO_ERROR: return "no error";
        case GL_INVALID_ENUM: return "invalid enum";
        case GL_INVALID_VALUE: return "invalid value";
        case GL_INVALID_OPERATION: return "invalid operation";
			//case GL_STACK_OVERFLOW: return "stack overflow";
			//case GL_STACK_UNDERFLOW: return "stack underflow";
        case GL_INVALID_FRAMEBUFFER_OPERATION: return "invalid framebuffer operation";
        case GL_OUT_OF_MEMORY: return "out of memory";
    }
    assert(false, "invalid enum");
}

@nogc
void	concatErrorMessage(in char[] s1)
{
	if (offset + s1.length < errorMessageMaximumLength)
	{
		errorMessage[offset..offset + s1.length] = s1;
		offset += s1.length;
		errorMessage[offset] = '\0';
	}
}
