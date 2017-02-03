module core.nogc_memory;

T	nogcNew(T, Args...)(Args args) @nogc
{
	import core.stdc.stdlib : malloc;
	import std.traits;

	T	instance;

	instance = cast(T)malloc(__traits(classInstanceSize, T));
// 	instance = T.init;
	foreach (string member; __traits(allMembers, T))
	{
//		static if (isType!(__traits(getMember, instance, member)))
//			__traits(getMember, instance, member) = typeof(__traits(getMember, instance, member)).init;
/*		static if (isType!(mixin("instance." ~ member)))
		{
			mixin("instance." ~ member)
				= typeof(mixin("instance." ~ member)).init;
		}*/

	}

	instance.__ctor(args);
	return instance;
}

void	nogcDelete(T)(T instance) @nogc
{
	import core.stdc.stdlib : free;

	instance.__dtor();
	free(instance);
}

unittest
{
	struct Dummy {
		int field1 = 10;
		int field2 = 11;
	}

	class MyClass {
		int a = 0;
		int[] b = [1, 2, 3];
		Dummy c = Dummy(4, 5);

		int d = 6;

		this() @nogc {
		}

		this(int val) @nogc {
			d = val;
		}
	}

	MyClass first = nogcNew!MyClass();
	MyClass second = nogcNew!MyClass(7);

	assert(first.a == 0);
	assert(first.b == [1, 2, 3]);
	assert(first.c.field1 == 4);
	assert(first.d == 6);

	assert(second.c.field1 == 4);
	assert(second.d == 7);
}
