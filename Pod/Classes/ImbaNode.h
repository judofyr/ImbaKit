#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import <JavaScriptCore/JavaScriptCore.h>

@class ImbaNode;

@protocol NodeJSExport <JSExport>
+ (instancetype)create;
- (void)markDirty;
- (void)setChildren:(NSArray *)children;
- (void)setParent:(ImbaNode *)node;

- (void)setBackgroundColor:(UIColor *)color;
- (void)setPadding:(NSUInteger)amount;
- (void)setHeight:(NSUInteger)amount;
- (void)setFlex:(CGFloat)amount;
@end

@interface ImbaNode : NSObject <NodeJSExport>

@property (atomic, strong) UIView *view;
@property (atomic, assign) CGRect frame;

- (void)mount:(UIView *)view;
- (void)layoutAndCollectFrames:(NSMutableSet *)viewsWithNewFrame;
- (void)setDimensions:(CGSize)size;

@end
