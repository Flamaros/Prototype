module math.transform;

import gl3n.linalg;

struct Transform(type, int dimensions)
{
	static assert(dimensions == 2 || dimensions == 3);

	Vector!(type, dimensions)	position;
	Vector!(type, dimensions)	scale;
	Quaternion!(type)			orientation;
}

alias Transform!(float, 2) Transform2f;
alias Transform!(float, 3) Transform3f;
