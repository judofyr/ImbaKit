#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@class ImbaNode;

@protocol NodeJSExport <JSExport>
+ (instancetype)create;
- (void)markDirty;
- (void)setChildren:(NSArray *)children;
- (void)setParent:(ImbaNode *)node;

#define IMBA_DEFINE_FLOAT(name) - (void)set##name:(CGFloat)amount;
#define IMBA_DEFINE_INT(name) - (void)set##name:(int)value;


#define IMBA_DEFINE_EDGES(name) \
  IMBA_DEFINE_FLOAT(name##Left) \
  IMBA_DEFINE_FLOAT(name##Right) \
  IMBA_DEFINE_FLOAT(name##Top) \
  IMBA_DEFINE_FLOAT(name##Bottom)

IMBA_DEFINE_EDGES(Padding)
IMBA_DEFINE_EDGES(Margin)
IMBA_DEFINE_EDGES()


#define IMBA_DEFINE_DIM(name) \
  IMBA_DEFINE_FLOAT(name##Width) \
  IMBA_DEFINE_FLOAT(name##Height)

IMBA_DEFINE_DIM()
IMBA_DEFINE_DIM(Min)
IMBA_DEFINE_DIM(Max)

IMBA_DEFINE_FLOAT(Flex)
IMBA_DEFINE_INT(Wrap)
IMBA_DEFINE_INT(Direction)
IMBA_DEFINE_INT(JustifyContent)
IMBA_DEFINE_INT(AlignItems)
IMBA_DEFINE_INT(AlignSelf)
IMBA_DEFINE_INT(AlignContent)
IMBA_DEFINE_INT(Position)

@end

@interface ImbaNode : NSObject <NodeJSExport>

@property (atomic, strong) UIView *view;

- (id)initWithView:(UIView *)view;
- (void)mount:(UIView *)view;
- (void)layoutAndCollectFrames:(NSMutableSet *)viewsWithNewFrame;
- (void)renderInFrame:(CGRect)frame;
- (void)setDimensions:(CGSize)size;

@end
