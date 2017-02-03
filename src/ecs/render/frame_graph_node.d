module ecs.render.frame_graph_node;

import ecs.core.node;

class FrameGraphNode : Node
{
public:
	this(FrameGraphNode parent = null) @nogc
	{
		super(parent);
	}
}
