module core.nogc_memory;

T	nogcNew(T, Args...)(Args args) @nogc
{
	import core.stdc.stdlib : malloc;

	T	instance;

	instance = cast(T)malloc(__traits(classInstanceSize, T));
// 	instance = T.init;
	foreach (string member; __traits(allMembers, T))
	{
//		static if (__traits(compiles, EnumMembers!(__traits(getMember, type, member))) && is(OriginalType!(__traits(getMember, type, member)) == int)) // If its an int enum
		{
//			mixin instance
//			.eval(member) = typeof(member).init;
		}

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
