module ecs.render.viewport;

import ecs.render.frame_graph_node;

import math.aabb;

import gl3n.linalg;

class Viewport : FrameGraphNode
{
	@property
	AABB2f	normalizedRect = AABB2f(vec2(0.0f, 0.0f), vec2(1.0f, 1.0f));
}
