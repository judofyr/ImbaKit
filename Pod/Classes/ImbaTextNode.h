#import "ImbaNode.h"

@protocol ImbaTextNodeJSExport <JSExport>
+ (instancetype)create;
- (void)setText:(NSString *)text;
@end


@interface ImbaTextNode : ImbaNode <ImbaTextNodeJSExport>

@end
