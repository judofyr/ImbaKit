#import "ImbaNode.h"

#include "Layout.h"

@interface ImbaNode ()

@property (atomic, assign) BOOL isDirty;
@property (atomic, assign) css_node_t* cssNode;
- (CGSize)measure:(float)width;

@end

@implementation ImbaNode {

    NSArray *_children;
    CGRect _frame;
    
}

static bool NodeIsDirty(void *ctx) {
    ImbaNode* node = (__bridge ImbaNode *)(ctx);
    return node.isDirty;
}

static css_node_t *NodeGetChild(void *ctx, int idx) {
    ImbaNode* node = (__bridge ImbaNode *)(ctx);
    ImbaNode* childNode = (ImbaNode *)[node.children objectAtIndex:idx];
    return childNode.cssNode;
}

static css_dim_t NodeMeasure(void *ctx, float width) {
    ImbaNode* node = (__bridge ImbaNode *)(ctx);
    css_dim_t res;

    if ([node respondsToSelector:@selector(measure:)]) {
        CGSize size = [node measure:width];
        res.dimensions[CSS_WIDTH] = size.width;
        res.dimensions[CSS_HEIGHT] = size.height;
    } else {
        res.dimensions[CSS_WIDTH] = CSS_UNDEFINED;
        res.dimensions[CSS_HEIGHT] = CSS_UNDEFINED;
    }
    
    return res;
}

+ (instancetype)create {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    UIView *view = [[UIView alloc] init];
    return [self initWithView:view];
}

-(id)initWithView:(UIView *)view {
    _cssNode = new_css_node();
    init_css_node(_cssNode);
    _cssNode->context = (__bridge void *)(self);
    _cssNode->children_count = 0;
    _cssNode->get_child = NodeGetChild;
    _cssNode->is_dirty = NodeIsDirty;
    _cssNode->measure = NodeMeasure;
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
        [self renderInFrame:newFrame];
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

- (void)renderInFrame:(CGRect)frame {
    self.view.frame = frame;
}

- (void)setBackgroundColor:(UIColor *)color {
    self.view.backgroundColor = color;
}

#define DEFINE_FLOAT(name, path) - (void)set##name:(CGFloat)amount { \
    _cssNode->style.path = amount; \
}

#define DEFINE_EDGES(name, path) \
  DEFINE_FLOAT(name##Left, path[CSS_LEFT]) \
  DEFINE_FLOAT(name##Right, path[CSS_RIGHT]) \
  DEFINE_FLOAT(name##Top, path[CSS_TOP]) \
  DEFINE_FLOAT(name##Bottom, path[CSS_BOTTOM])

DEFINE_EDGES(, position)
DEFINE_EDGES(Padding, padding)
DEFINE_EDGES(Margin, margin)

#define DEFINE_DIM(name, path) \
  DEFINE_FLOAT(name##Width, path[CSS_WIDTH]) \
  DEFINE_FLOAT(name##Height, path[CSS_HEIGHT])

DEFINE_DIM(, dimensions)
DEFINE_DIM(Min, minDimensions)
DEFINE_DIM(Max, maxDimensions)

#define DEFINE_INT(name, path) - (void)set##name:(int)value { \
    _cssNode->style.path = value; \
}

DEFINE_FLOAT(Flex, flex)
DEFINE_INT(Wrap, flex_wrap)
DEFINE_INT(Direction, flex_direction)
DEFINE_INT(JustifyContent, justify_content)
DEFINE_INT(AlignItems, align_items)
DEFINE_INT(AlignSelf, align_self)
DEFINE_INT(AlignContent, align_content)
DEFINE_INT(Position, position_type)

@end
