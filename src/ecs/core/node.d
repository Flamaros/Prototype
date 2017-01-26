module ecs.core.node;

import utils.array;

class Node
{
public:
	static uint	chunkSize = 32;

public:
	this(Node parent = null) @nogc nothrow
	{
		mParent = parent;
	}

	~this() @nogc nothrow
	{
		parent(null);
	}

	final @property void	parent(Node parent) @nogc nothrow
	{
		if (mParent !is null)
			mParent.removeChild(this);
		mParent = parent;
		if (mParent !is null)
			mParent.addChild(this);
	}

	final @property Node	parent() pure @nogc nothrow
	{
		return mParent;
	}

	final @property ulong id() @nogc
	{
		return mId;
	}

private:
	void	addChild(Node node) @nogc nothrow
	{
		if (mChildren.findFirst(node) == mChildren.npos)
			mChildren.pushBack(node, chunkSize);
	}

	void	removeChild(Node node) @nogc nothrow
	{
		mChildren.removeOne(node);
	}

private:
	Node			mParent;
	Array!(Node)	mChildren;
	ulong			mId;
}
