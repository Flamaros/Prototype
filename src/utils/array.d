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
	@nogc
	this(int count, const ValueType value)
	{
		resize(count, value);
	}

	@nogc @property bool	isEmpty() const {return mCount == 0;}
	@nogc @property int		count() const {return mCount;}

	@nogc
	void    reserve(int count)   /// This have no effect if the requested count is inferior to the number of allocated elements
	{
		if (mAllocated < count)
		{
			mData = cast(ValueType*)realloc(mData, count * ValueType.sizeof);
			mAllocated = count;
		}
	}

	@nogc
	void    resize(int count) /// Memory isn't initialized, no memory will be released (use shrink if needed)
	{
		reserve(count);
		mCount = count;
	}

	@nogc
	void    resize(int count, const ValueType value) /// it initalize new elements with value
	{
		reserve(count);
		for (int i = mCount; i < mAllocated; i++)
			memcpy(&mData[i], &value, ValueType.sizeof);
		mCount = count;
	}

	@nogc
	void    shrink()    /// Reduce the internal buffer size to fit to the number of elements used
	{
		mData = cast(ValueType*)realloc(mData, mCount * ValueType.sizeof);
		mAllocated = mCount;
	}

	@nogc
	void    clear() /// Erase the entire array
	{
		free(mData);
		mData = null;
		mAllocated = 0;
		mCount = 0;
	}

	@nogc
	void    pushBack(const ValueType value, int reserveChunk = 1)    /// reserveChunk is the reserve size to use if there no enough space for the pushBack
	{
		import std.algorithm.comparison : min;

		if (mAllocated < mCount + 1)
			reserve(mCount + min(1, reserveChunk));
		memcpy(&mData[mCount], &value, ValueType.sizeof);
		mCount++;
	}

	@nogc
	void    pushBack(const Array!(ValueType) values)
	{
		reserve(mCount + values.mCount);
		memcpy(&mData[mCount], values.mData, values.mCount * ValueType.sizeof);
		mCount += values.mCount;
	}

	@nogc
	void    removeAt(int index)
	{
		if (index >= mCount)
		{
			debug
				assert(false);
			else
				return;
		}

		// Swap the last value to the erased one
		memcpy(&mData[index], &mData[mCount - 1], ValueType.sizeof);
		mCount--;
	}

	@nogc
	void    removeOne(ValueType value)
	{
		int  position = findFirst(value);

		if (position != npos)
			removeAt(position);
	}

	@nogc
	void    removeAll(ValueType value)
	{
		int  position = findFirst(value);

		while (position != npos)
		{
			removeAt(position);
			position = findFirst(value, position + 1);
		}
	}

	@nogc
	int  findFirst(ValueType Value, int position = 0) /// return npos if not found, else the index
	{
		for (int i = position; i < mCount; i++)
			if (memcmp(&mData[i], &Value, ValueType.sizeof) == 0)
				return i;
		return npos;
	}

	/// Return the raw ptr, you can modify data, but take care of calling resize or reserve if needed
	@nogc @property ValueType*  data() {return mData;}

	@nogc ref ValueType	opIndex(int position) {return mData[position];}

private:
	ValueType*	mData = null;
	int			mAllocated = 0;
	int			mCount = 0;
}

unittest
{
}
