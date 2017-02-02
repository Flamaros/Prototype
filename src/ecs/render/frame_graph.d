module ecs.render.frame_graph;

import ecs.render.frame_graph_node;

class FrameGraph
{
public:
	void	setRoot(FrameGraphNode rootNode)
	{
		mRootNode = rootNode;
	}

	void	execute()
	{
		if (mRootNode is null)
			return;
	}

private:
	FrameGraphNode	mRootNode;
}
