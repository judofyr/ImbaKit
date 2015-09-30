#import <Foundation/Foundation.h>

@interface ImbaApplication : NSObject

- (void)loadSource:(NSURL *)url;
- (void)mount:(UIView *)view;

@end
