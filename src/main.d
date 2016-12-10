import std.stdio;

import derelict.glfw3.glfw3;

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
	DerelictGLFW3.load(glfw3LibPath);
}
