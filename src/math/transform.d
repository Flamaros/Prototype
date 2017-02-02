module math.transform;

import gl3n.linalg;

struct Transform(type, int dimensions)
{
	static assert(dimensions == 2 || dimensions == 3);

public:
	VectorType			position;
	VectorType			scale;
	Quaternion!(type)	orientation;

	private alias VectorType = Vector!(type, dimensions);
}

alias Transform2f = Transform!(float, 2);
alias Transform3f = Transform!(float, 3);
