RPScrollingNode
===============

Basic Use
------------
```Obj-C
// Create a scrolling node with the array of nodes.  Make the visible view into the scroller the height specified.
RPScrollingNode *scroller =[RPScrollingNode scrollingNodeWithNodes:nodes height:300];
scroller.position = ccp(x, y);

// update list
scroller.nodes = myOtherNodeArray;
```

Assumptions
------------
* The array of nodes have equal width.  That becomes the width of the scroller


TODO
------------
* Disallow touches on controls outside of bounding box.  For example if a node in the scroller has menu items on them they can be touched when outside of the bounding box.
* Make compatible with Cocos2d v2
