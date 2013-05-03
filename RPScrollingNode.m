//
//  RPScrollingNode.m
//
// Copyright (c) 2013 Robots and Pencils ( http://robotsandpencils.com/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "RPScrollingNode.h"

#define kRPScrollingNodeRowTag 29876


@implementation RPScrollingNode
@synthesize nodes = nodes_;


+(id) scrollingNodeWithNodes:(NSArray *)nodes height:(NSInteger)height
{
	return [[[self alloc] initWithNodes:nodes height:height] autorelease];
}


- (id)initWithNodes:(NSArray *)nodes height:(NSInteger)height{
    
    self = [super init];
    if (self) {

        self.isTouchEnabled = YES;
        self.isRelativeAnchorPoint = YES;
        
        viewableHeight_ = height;
        
        slidingNode_ = [CCNode node];
        [self addChild:slidingNode_];
        
        self.nodes = nodes;
        

    }
    
    return self;

}

- (void)loadNodes{
    CGSize size = CGSizeZero;
    for (CCNode *node in nodes_) {
        size.width = (MAX([node contentSize].width, size.width));
        size.height += [node contentSize].height;
    }
    
    
    [slidingNode_ setContentSize:size];
    slidingNode_.anchorPoint = ccp(0.5f, 0.5f);
    
    [self setContentSize:CGSizeMake(size.width, viewableHeight_)];
    
    NSInteger nodeIndex = 0;
    for (CCNode *node in nodes_) {

        
        CGSize nodeSize = [node contentSize];
        NSInteger nodeHeight = ([nodes_ count] - 1 - nodeIndex ) * nodeSize.height;
        node.position = ccp(size.width * .5, nodeHeight + nodeSize.height * .5);
        node.tag = kRPScrollingNodeRowTag;
        [slidingNode_ addChild:node];
        nodeIndex++;
    }
    
    slidingNode_.position = ccp(size.width * .5, viewableHeight_ - ([slidingNode_ contentSize].height * .5));

}

- (id)init
{
    self = [self initWithNodes:nil height:0.0f];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
    [nodes_ release];
    [super dealloc];
}

- (void)setNodes:(NSArray *)nodes{
    
    [slidingNode_ removeAllChildrenWithCleanup:YES];
    [nodes_ release];
    nodes_ = [nodes retain];
    [self loadNodes];
    
    // visual indicator of refresh
    [self runSlideUpAnimation];
    
}

- (void)runSlideUpAnimation{
    CGPoint newPosition = ccpAdd(slidingNode_.position, ccp(0.0f, -viewableHeight_));
    slidingNode_.position = newPosition;
    [self bounceBackIfNeeded];
}


#pragma mark Touch Handling

-(void) registerWithTouchDispatcher
{
    CCTouchDispatcher *dispatcher = [CCTouchDispatcher sharedDispatcher];

    
	[dispatcher addTargetedDelegate: self priority:0 swallowsTouches: YES ];
}


// returns YES if touch is inside our boundingBox
-(BOOL) isTouchForMe:(UITouch *) touch
{
	CGPoint point = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch locationInView: [touch view]]]];
	CGPoint prevPoint = [self convertToNodeSpace:[[CCDirector sharedDirector] convertToGL:[touch previousLocationInView: [touch view]]]];
	
	CGRect rect = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
	
    if ( CGRectContainsPoint(rect, point) || CGRectContainsPoint(rect, prevPoint) )
		return YES;
	
	return NO;
}


-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [touch view]];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
	
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){

		if ( [item visible] ) {
			
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item boundingBox];
			r.origin = CGPointZero;
			
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    
	if( !visible_  )
		return NO;
	
	curTouchLength_ = 0; //< every new touch should reset previous touch length
	
    CGPoint touchPoint = [touch locationInView:[touch view]];
	touchPoint = [[CCDirector sharedDirector] convertToGL:touchPoint];
    
    // convert parent's node space
    touchPoint = [self.parent convertToNodeSpace:touchPoint];
    
    if (!CGRectContainsPoint([self boundingBox], touchPoint)) {
        return NO;
    }
	
	// start slide even if touch began outside of menuitems, but inside menu rect
	if ([self isTouchForMe: touch] ){
		return YES;
	}
	
	return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

    
    // get touch move delta
    CGPoint point = [touch locationInView: [touch view]];
    CGPoint prevPoint = [ touch previousLocationInView: [touch view] ];
    point =  [ [CCDirector sharedDirector] convertToGL: point ];
    prevPoint =  [ [CCDirector sharedDirector] convertToGL: prevPoint ];
    CGPoint delta = ccpSub(point, prevPoint);
    
    curTouchLength_ += ccpLength( delta );

    // cancel out sideways movement
    delta.x = 0;

    // can never let the top item go below the top of the content
    CGPoint newPosition = ccpAdd(slidingNode_.position, delta );
    slidingNode_.position = newPosition;
    
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
	
    [self bounceBackIfNeeded];
	
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
    [self bounceBackIfNeeded];
	
}

- (void) visit
{
    if (!self.visible) {
        return;
    }
    
    // clip outside bounding box
    glEnable(GL_SCISSOR_TEST);
    CGRect box = [self boundingBox];
    
    // convert bounding box to world space
    CGPoint worldSpaceOrigin = [self.parent convertToWorldSpace:box.origin];
    glScissor(worldSpaceOrigin.x, worldSpaceOrigin.y, box.size.width, box.size.height);
    
    [super visit];
    glDisable(GL_SCISSOR_TEST);
}

- (void)bounceBackIfNeeded{
    CGRect box = [self boundingBox];
    CGFloat topOfSlidingNode = slidingNode_.position.y + ([slidingNode_ boundingBox].size.height * .5);
    
    CGPoint adjustPoint = CGPointMake(slidingNode_.position.x, 0.0f);
    
    if (topOfSlidingNode < box.size.height ) {
        adjustPoint.y = box.size.height - ([slidingNode_ boundingBox].size.height * .5);
    }
    
    CGFloat bottomOfSlidingNode = slidingNode_.position.y - ([slidingNode_ boundingBox].size.height * .5);
    
    // this is for when the sliding node height is greater than content size
    if (bottomOfSlidingNode > 0 && [slidingNode_ contentSize].height >= box.size.height) {
        adjustPoint.y = ([slidingNode_ boundingBox].size.height * .5);
    }else if (bottomOfSlidingNode > 0 && [slidingNode_ contentSize].height < box.size.height) {
        adjustPoint.y = box.size.height - ([slidingNode_ boundingBox].size.height * .5);
    }
    
    if (adjustPoint.y != 0.0f) {
        CCMoveTo *moveTo = [CCMoveTo actionWithDuration:0.3f position:adjustPoint];
        CCEaseElastic *ease = [CCEaseElastic actionWithAction:moveTo];
        [slidingNode_ runAction:ease];
    }
}






@end
