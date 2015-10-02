#import "ImbaTextNode.h"

@implementation ImbaTextNode {

    NSString *_text;
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    NSTextContainer *_textContainer;
    
}


- (instancetype)init {
    _layoutManager = [NSLayoutManager new];
    
    _textContainer = [NSTextContainer new];
    [_layoutManager addTextContainer:_textContainer];
    _textContainer.lineFragmentPadding = 0.0;
    _textContainer.lineBreakMode = NSLineBreakByWordWrapping;
    _textContainer.maximumNumberOfLines = 0;
    
    _textStorage = [[NSTextStorage alloc] init];
    [_textStorage addLayoutManager:_layoutManager];
    
    UITextView *view = [[UITextView alloc] initWithFrame:CGRectZero textContainer:_textContainer];
    view.editable = NO;
    view.textContainerInset = UIEdgeInsetsZero;
    return [self initWithView:view];
}

- (void)setText:(NSString *)text {
    [_textStorage replaceCharactersInRange:NSMakeRange(0, _textStorage.length) withString:text];
}

- (CGSize)measure:(float)width {
    _textContainer.size = (CGSize) { isnan(width) ? CGFLOAT_MAX : width, CGFLOAT_MAX };
    [_layoutManager ensureLayoutForTextContainer:_textContainer];
    CGRect rect = [_layoutManager usedRectForTextContainer:_textContainer];
    return rect.size;
}

@end
