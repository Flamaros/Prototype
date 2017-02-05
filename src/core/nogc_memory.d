module core.nogc_memory;

mixin template NogcAllocator(T)
{
	static T	nogcNew(T, Args...)(Args args) @nogc
	{
		import core.stdc.stdlib : malloc;
		import std.traits;

		T    instance;
		enum s = __traits(classInstanceSize, T);

		instance = cast(T) malloc(s);
		(cast(void*) instance)[0..s] = typeid(T).initializer[];

		instance.__ctor(args); 
/*
		T	instance;

		instance = cast(T)malloc(__traits(classInstanceSize, T));
		foreach (string member; __traits(allMembers, T))
		{
			static if (isType!(__traits(getMember, T, member)))
				__traits(getMember, instance, member) = typeof(__traits(getMember, T, member)).init;
		}

		instance.__ctor(args);*/
		return instance;
	}

	static void	nogcDelete(T)(T instance) @nogc
	{
		import core.stdc.stdlib : free;

		instance.__dtor();
		free(instance);
	}


	/*
		Your nogcDelete() is bug-prone & leaky

		- use _xdtor, which also calls the __dtor injected by mixin.
		- even if you do so, __xdtors are not inherited !! instead dtor in parent classes are called by destroy() directly.

		Currently what I do to simulate inherited destructor is to mix this for each new generation.

		mixin template inheritedDtor()
		{
			private:

			import std.traits: BaseClassesTuple;

			alias B = BaseClassesTuple!(typeof(this));
			enum hasDtor = __traits(hasMember, typeof(this), "__dtor");
			static if (hasDtor && !__traits(isSame, __traits(parent, typeof(this).__dtor), typeof(this)))
			enum inDtor = true;
			else
			enum inDtor = false;

			public void callInheritedDtor(classT = typeof(this))()
			{
				import std.meta: aliasSeqOf;
				import std.range: iota;

				foreach(i; aliasSeqOf!(iota(0, B.length)))
				static if (__traits(hasMember, B[i], "__xdtor"))
				{
					mixin("this." ~ B[i].stringof ~ ".__xdtor;");
					break;
				}
			}

			static if (!hasDtor || inDtor)
			public ~this() {callInheritedDtor();}
		}

		When a dtor is implemented it has to call "callInheritedDtor()" at end of the dtor implementation. 
	*/
}

unittest
{
	struct Dummy {
		int field1 = 10;
		int field2 = 11;
	}

	class MyClass {
		mixin NogcAllocator!MyClass;

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

	MyClass first = MyClass.nogcNew!MyClass();
	MyClass second = MyClass.nogcNew!MyClass(7);

	assert(first.a == 0);
	assert(first.b == [1, 2, 3]);
	assert(first.c.field1 == 4);
	assert(first.d == 6);

	assert(second.c.field1 == 4);
	assert(second.d == 7);
}
