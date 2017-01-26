module utils.array;

import core.stdc.stdlib : realloc, free;
import core.stdc.string : memcpy, memcmp;

/**
 * Basic Array container that is made to be fast, so it does not rely on copy constructor of the specified type
 * instead it use memcpy, memcmp,...
 * All methods are @nogc
 */

final struct Array(ValueType)
{
public:
	@property static immutable int	npos = -1;

public:
	this(int count, in ref ValueType value) @nogc nothrow
	{
		resize(count, value);
	}

	~this() @nogc nothrow
	{
		clear();
	}

	@property bool	empty() const pure @nogc nothrow
	{
		return mCount == 0;
	}

	@property int	count() const pure @nogc nothrow
	{
		return mCount;
	}

	/// This have no effect if the requested count is inferior to the number of allocated elements
	void	reserve(int count) @nogc nothrow
	{
		if (mAllocated < count)
		{
			mData = cast(ValueType*)realloc(mData, count * ValueType.sizeof);
			mAllocated = count;
		}
	}

	/// Memory isn't initialized, no memory will be released (use shrink if needed)
	void	resize(int count) @nogc nothrow
	{
		reserve(count);
		mCount = count;
	}

	/// it initalize new elements with value
	void	resize(int count, in ref ValueType value) @nogc nothrow
	{
		reserve(count);
		for (int i = mCount; i < mAllocated; i++)
			memcpy(&mData[i], &value, ValueType.sizeof);
		mCount = count;
	}

	/// Reduce the internal buffer size to fit to the number of elements used
	void	shrink() @nogc nothrow
	{
		mData = cast(ValueType*)realloc(mData, mCount * ValueType.sizeof);
		mAllocated = mCount;
	}

	/// Erase the entire array
	void	clear() @nogc nothrow
	{
		for (int i = 0; i < mCount; i++)
			mData[i].__dtor();

		free(mData);
		mData = null;
		mAllocated = 0;
		mCount = 0;
	}

    /// reserveChunk is the reserve size to use if there no enough space for the pushBack	
	void    pushBack(in ref ValueType value, int reserveChunk = 1) @nogc nothrow
	{
		import std.algorithm.comparison : min;

		if (mAllocated < mCount + 1)
			reserve(mCount + min(1, reserveChunk));
		memcpy(&mData[mCount], &value, ValueType.sizeof);
		mCount++;
	}

	void    pushBack(in ref Array!(ValueType) values) @nogc nothrow
	{
		reserve(mCount + values.mCount);
		memcpy(&mData[mCount], values.mData, values.mCount * ValueType.sizeof);
		mCount += values.mCount;
	}

	void    removeAt(int index) @nogc nothrow
	{
		if (index >= mCount)
		{
			debug
				assert(false);
			else
				return;
		}

		mData[index].__dtor();
		// Swap the last value to the erased one
		memcpy(&mData[index], &mData[mCount - 1], ValueType.sizeof);
		mCount--;
	}

	void    removeOne(ValueType value) @nogc nothrow
	{
		int  position = findFirst(value);

		if (position != npos)
			removeAt(position);
	}

	void    removeAll(ValueType value) @nogc nothrow
	{
		int  position = findFirst(value);

		while (position != npos)
		{
			removeAt(position);
			position = findFirst(value, position + 1);
		}
	}

	/// return npos if not found, else the index
	int  findFirst(ValueType Value, int position = 0) pure const @nogc nothrow
	{
		for (int i = position; i < mCount; i++)
			if (memcmp(&mData[i], &Value, ValueType.sizeof) == 0)
				return i;
		return npos;
	}

	/// Return the raw ptr
	@property const(ValueType*)	data() const @nogc nothrow
	{
		return mData;
	}

	ref ValueType	opIndex(int position) @nogc nothrow
	{
		return mData[position];
	}

private:
	ValueType*	mData = null;
	int			mAllocated = 0;
	int			mCount = 0;
}

unittest
{
	// TODO test with int, int*, struct, struct*, class, class*,... (mainly for destructors)
}
