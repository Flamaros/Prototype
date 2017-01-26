module ecs.render.viewport;

import ecs.render.frame_graph_node;

import math.aabb;

import gl3n.linalg;

class Viewport : FrameGraphNode
{
public:
	@property void	normalizedRect(in AABB2f rect) pure @nogc nothrow
	{
		mNormalizedRect = rect;
	}

	@property AABB2f	normalizedRect() const pure @nogc nothrow
	{
		return mNormalizedRect;
	}
		
private:
	AABB2f	mNormalizedRect = AABB2f(vec2(0.0f, 0.0f), vec2(1.0f, 1.0f));
}
