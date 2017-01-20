module math.aabb;

import gl3n.linalg;

struct AABB(type, int dimensions)
{
	static assert(dimensions == 2 || dimensions == 3);

	VectorType	min = Vector!(type, 3)(type.max, type.max, type.max);
	VectorType	max = Vector!(type, 3)(-type.max, -type.max, -type.max);

	/// return max >= min
	bool	isValid() const
	{
		return max >= min;
	}

	/// return -type.max if not valid
	@nogc
	type	xLength(bool checkValidity = true)() const
	{
        static if (checkValidity == true)
			if (isValid == false)
			{
				debug
					assert(false);
				else
					return -type.max;
			}
		return max.x - min.x;
	}

	/// return -type.max if not valid
	@nogc
	type	yLength(bool checkValidity = true)() const
	{
        static if (checkValidity == true)
			if (isValid == false)
			{
				debug
					assert(false);
				else
					return -type.max;
			}
		return max.y - min.y;
	}

	static if (dimensions == 3)
	{
		/// return -type.max if not valid
		@nogc
		type	zLength(bool checkValidity = true)() const
		{
			static if (checkValidity == true)
				if (isValid == false)
				{
					debug
						assert(false);
					else
						return -type.max;
				}
			return max.z - min.z;
		}
	}

	/// return Vector of -type.max if not valid
    VectorType center(bool checkValidity = true)() const
	{
        static if (checkValidity == true)
            if (isValid() == false)
            {
				debug
	                assert(false);
				else
				{
					static if (dimensions == 2)
		                return VectorType(-type.max, -type.max);
					else
		                return VectorType(-type.max, -type.max, -type.max);
				}
            }

        VectorType	center;

		center.x = cast(type)0.5 * (max.x + min.x);
		center.y = cast(type)0.5 * (max.y + min.y);
		static if (dimensions == 3)
			center.z = cast(type)0.5 * (max.z + min.z);
		return center;
	}

	private alias VectorType = Vector!(type, dimensions);

	unittest
	{
		AABB2i	aabbInt;
		AABB2f	aabbFloat;

		assert(aabbInt.isValid == false);
		assert(aabbFloat.isValid == false);
//		assert(aabbFloat.xLength == -float.max);
	}
}

alias AABB2i = AABB!(int, 2);
alias AABB2f = AABB!(float, 2);
alias AABB3f = AABB!(float, 3);
