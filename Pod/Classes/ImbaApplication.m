#import "ImbaApplication.h"
#import "ImbaNode.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface ImbaApplication ()

@property (atomic, strong) JSContext *js;

@end

@implementation ImbaApplication

- (instancetype)init {
    _js = [JSContext new];
    
    __weak ImbaApplication *weakSelf = self;
    
    _js[@"Imba$log"] = ^ (NSString *str) {
        NSLog(@"%@", str);
    };
    
    _js[@"Imba$findClass"] = ^(NSString *name) {
        return [JSValue valueWithObject:NSClassFromString(name) inContext:weakSelf.js];
    };
    
    _js.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        NSLog(@"JS Error: %@ %@", exception, exception[@"stack"]);
    };
    
    return self;
}

- (void)loadSource:(NSURL *)url {
    NSString *src = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    [_js evaluateScript:src withSourceURL:url];
}

- (void)mount:(UIView *)view {
    JSValue *bootResult = [_js[@"Imba$boot"] callWithArguments:@[]];
    ImbaNode *rootNode = [bootResult toObjectOfClass:[ImbaNode class]];
    assert(rootNode);
    [rootNode mount:view];
}

@end
