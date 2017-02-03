module core.nogc_memory;

T	nogcNew(T, Args...)(Args args) @nogc
{
	import core.stdc.stdlib : malloc;

	T	instance;

	instance = cast(T)malloc(__traits(classInstanceSize, T));
	instance.__ctor(args);
	return instance;
}

void	nogcDelete(T)(T instance) @nogc
{
	import core.stdc.stdlib : free;

	instance.__dtor();
	free(instance);
}
