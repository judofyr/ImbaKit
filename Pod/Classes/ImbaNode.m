#import "ImbaNode.h"

#include "Layout.h"

@interface ImbaNode ()

@property (atomic, assign) BOOL isDirty;
@property (atomic, assign) css_node_t* cssNode;


@end

@implementation ImbaNode

NSArray *_children;

bool NodeIsDirty(void *ctx) {
    ImbaNode* node = (__bridge ImbaNode *)(ctx);
    return node.isDirty;
}

css_node_t *NodeGetChild(void *ctx, int idx) {
    ImbaNode* node = (__bridge ImbaNode *)(ctx);
    ImbaNode* childNode = (ImbaNode *)[node.children objectAtIndex:idx];
    return childNode.cssNode;
}

+(instancetype)create {
    UIView *view = [[UIView alloc] init];
    return [[self alloc] initWithView:view];
}

-(id)initWithView:(UIView *)view {
    _cssNode = new_css_node();
    init_css_node(_cssNode);
    _cssNode->context = (__bridge void *)(self);
    _cssNode->children_count = 0;
    _cssNode->get_child = NodeGetChild;
    _cssNode->is_dirty = NodeIsDirty;
    _isDirty = YES;
    _children = nil;
    
    self.view = view;
    return self;
    
}

-(void)dealloc {
    free_css_node(_cssNode);
}

- (NSArray *)children {
    return _children;
}

- (void)setChildren:(NSArray *)children {
    _children = children;
    _cssNode->children_count = (int)children.count;
}

- (void)mount:(UIView *)view {
    [self setDimensions:view.frame.size];
    [self layoutAndCollectFrames:nil];
    [view addSubview:self.view];
}

- (void)setParent:(ImbaNode *)node {
    if (node) {
        [node.view addSubview:self.view];
    } else {
        [self.view removeFromSuperview];
    }
}

- (void)markDirty {
    _isDirty = YES;
}

-(void)setDimensions:(CGSize)size {
    _cssNode->style.dimensions[CSS_WIDTH] = size.width;
    _cssNode->style.dimensions[CSS_HEIGHT] = size.height;
}

-(void)applyLayoutNode:(css_node_t *)node viewsWithNewFrame:(NSMutableSet *)viewsWithNewFrame {
    if (!node->layout.should_update) {
        return;
    }
    
    node->layout.should_update = false;
    
    CGRect newFrame = {
        {node->layout.position[CSS_LEFT], node->layout.position[CSS_TOP]},
        {node->layout.dimensions[CSS_WIDTH], node->layout.dimensions[CSS_HEIGHT]}
    };
    
    if (!CGRectEqualToRect(_frame, newFrame)) {
        _frame = newFrame;
        [viewsWithNewFrame addObject:self];
        _view.frame = newFrame;
    }
    
    node->layout.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
    node->layout.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    node->layout.position[CSS_LEFT] = 0;
    node->layout.position[CSS_TOP] = 0;
    
    for (ImbaNode *child in _children) {
        [child applyLayoutNode:child.cssNode viewsWithNewFrame:viewsWithNewFrame];
    }
}

- (void)layoutAndCollectFrames:(NSMutableSet *)viewsWithNewFrame {
    layoutNode(_cssNode, CSS_UNDEFINED, CSS_DIRECTION_INHERIT);
    [self applyLayoutNode:_cssNode viewsWithNewFrame:viewsWithNewFrame];
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

- (void)setPadding:(NSUInteger)amount {
    _cssNode->style.padding[CSS_TOP] = amount;
    _cssNode->style.padding[CSS_LEFT] = amount;
    _cssNode->style.padding[CSS_RIGHT] = amount;
    _cssNode->style.padding[CSS_BOTTOM] = amount;
}

- (void)setHeight:(NSUInteger)amount {
    _cssNode->style.dimensions[CSS_HEIGHT] = amount;
}

- (void)setFlex:(CGFloat)amount {
    _cssNode->style.flex = amount;
}

@end
