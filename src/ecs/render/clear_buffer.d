module ecs.render.clear_buffer;

import ecs.render.frame_graph_node;

public import core.color;

class ClearBuffer : FrameGraphNode
{
public:
	enum	BufferType : char
	{
		None					= 0x00,
		ColorBuffer				= 0x01,
		DepthBuffer				= 0x02,
		StencilBuffer			= 0x04,
		DepthStencilBuffer		= DepthBuffer | StencilBuffer,
		ColorDepthBuffer		= ColorBuffer | DepthBuffer,
		ColorDepthStencilBuffer	= ColorBuffer | DepthBuffer | StencilBuffer,
		AllBuffers				= 0xff
	}

public:
	this(FrameGraphNode parent = null) @nogc
	{
		super(parent);
	}

	BufferType	buffers = BufferType.None;
	float		depthValue = 1.0f;
	int			stencilValue = 0;
	Color		color = Color(1.0f, 1.0f, 1.0f, 1.0f);
}
