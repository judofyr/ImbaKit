#import "ImbaNode.h"

@protocol ImbaTextNodeJSExport <JSExport>
+ (instancetype)create;
- (void)setText:(NSString *)text;
IMBA_DEFINE_INT(TextAlign)
@end


@interface ImbaTextNode : ImbaNode <ImbaTextNodeJSExport>

@end
