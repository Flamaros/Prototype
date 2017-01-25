module ecs.core.node;

import utils.array;

class Node
{
	@nogc
	this(Node parent = null)
	{
		mParent = parent;
	}

	~this()
	{
		parent(null);
		for (int i = 0; i < mChildren.count; i++)
			delete mChildren[i];
	}

	@nogc @property Node	parent() {return mParent;}
	@nogc @property void	parent(Node parent)
	{
		if (mParent !is null)
			mParent.removeChild(this);
		mParent = parent;
		if (mParent !is null)
			mParent.addChild(this);
	}

	@nogc
	@property final ulong id() {return mId;}

private:
	@nogc
	void	addChild(Node node)
	{
		if (mChildren.findFirst(node) == mChildren.npos)
			mChildren.pushBack(node);
	}

	@nogc
	void	removeChild(Node node)
	{
		mChildren.removeOne(node);
	}

private:
	Node			mParent;
	Array!(Node)	mChildren;
	ulong			mId;
}
