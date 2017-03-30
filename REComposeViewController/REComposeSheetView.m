//
// REComposeSheetView.m
// REComposeViewController
//
// Copyright (c) 2013 Roman Efimov (https://github.com/romaonthego)
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

#import "REComposeSheetView.h"
#import "REComposeViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface REComposeSheetView ()

// Properties
@property (nonatomic, strong) UILabel *navTitle;

@end




@implementation REComposeSheetView

- (instancetype)initWithFrame:(CGRect)frame simple:(BOOL)simple postTitle:(NSString *)postTitle {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.simple = simple;
        
        self.backgroundColor = [UIColor whiteColor];
        
        _navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 44)];
        _navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        
        _navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
        _navigationBar.items = @[_navigationItem];
        
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"cancel") style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed)];
        _navigationItem.leftBarButtonItem = cancelButtonItem;
        
        self.postButtonItem = [APP_STYLE themedBarButtonItemWithTitle:postTitle usingAppearanceIdentifier:REWButtonAppearancePrimary target:self action:@selector(postButtonPressed)];
        _navigationItem.rightBarButtonItem = self.postButtonItem;
        
        //_navigationBar.layer.borderColor = [UIColor redColor].CGColor;
        //_navigationBar.layer.borderWidth = 2.0;
        
        // Custom title
        CGFloat margin = 65;
        CGFloat titleHeight = 25;
        CGRect titleFrame = CGRectMake(margin, ((44 / 2) - (titleHeight / 2)), _navigationBar.frame.size.width - (margin * 2), titleHeight);
        
        
        self.navTitle = [[UILabel alloc] initWithFrame:titleFrame];
        
        self.navTitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:19];
        self.navTitle.backgroundColor = [UIColor clearColor];
        
        self.navTitle.adjustsFontSizeToFitWidth = YES;
        self.navTitle.minimumScaleFactor = 0.5;
        
        self.navTitle.textColor = [UIColor whiteColor];
        self.navTitle.textAlignment = NSTextAlignmentCenter;
        self.navTitle.text = _delegate.title;
        
        self.navTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        
        // self.navTitle.layer.borderWidth = 1.0;
        // self.navTitle.layer.borderColor = [UIColor greenColor].cgColor;
        
        // navigationItem.titleView = self.navTitle;
        
        
        _textViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 44, frame.size.width, frame.size.height - 44)];
        _textViewContainer.clipsToBounds = YES;
        _textViewContainer.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        _textView = [[DEComposeTextView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 47)];
        _textView.backgroundColor = [UIColor whiteColor];
        _textView.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        
        CGFloat bottomMargin = self.simple ? 0 : 20;
        
        _textView.contentInset = UIEdgeInsetsMake(0, 0, bottomMargin, 0);
        _textView.bounces = YES;
        _textView.keyboardAppearance = UIKeyboardAppearanceDark;
        _textView.enablesReturnKeyAutomatically = YES;
        
        if (self.simple) {
            
            _textView.hidden = YES;
            
            CGFloat sideMargin = 20.0;
            CGFloat topMargin = 15.0;
            
            _textField = [[UITextField alloc] initWithFrame:CGRectMake((sideMargin / 2.0), topMargin, (frame.size.width - sideMargin), 25)];
            _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
            _textField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
            
            _textField.returnKeyType = UIReturnKeyDone;
            _textField.enablesReturnKeyAutomatically = YES;
            _textField.delegate = self;
            _textField.keyboardAppearance = UIKeyboardAppearanceDark;
            
            [_textField addTarget:self action:@selector(textFieldDidChange) forControlEvents:UIControlEventEditingChanged];
            
            // _textField.layer.borderWidth = 1.0;
            // _textField.layer.borderColor = [UIColor greenColor].CGColor;
            
            [_textViewContainer addSubview:_textField];
            
        } else {
            
            _textView.delegate = self;
            
        }
        
        // _textField.layer.borderWidth = 1.0;
        // _textField.layer.borderColor = [UIColor greenColor].CGColor;
        
        [_textViewContainer addSubview:_textView];
        [self addSubview:_textViewContainer];
        
        if (!self.simple) {
            
            _attachmentImageView = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width = 84, 54, 84, 79)];
            _attachmentImageView.layer.cornerRadius = 3.0f;
            _attachmentImageView.layer.masksToBounds = YES;
            [_attachmentView addSubview:_attachmentImageView];
            
            _attachmentContainerView = [[UIImageView alloc] initWithFrame:_attachmentView.bounds];
            _attachmentContainerView.image = [UIImage imageNamed:@"REComposeViewController.bundle/AttachmentFrame"];
            
            [_attachmentView addSubview:_attachmentContainerView];
            _attachmentView.hidden = YES;
            
        }
        
        [self addSubview:_navigationBar];
        
    }
    
    return self;
}



- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [self initWithFrame:frame simple:NO postTitle:@"Post"];
    
    if (self) {
        
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_delegate) {
        UIViewController *delegate = _delegate;
        _navigationItem.title = delegate.title;
    }
}

- (void)cancelButtonPressed
{
    id<REComposeSheetViewDelegate> localDelegate = _delegate;
    if ([localDelegate respondsToSelector:@selector(cancelButtonPressed)])
        [localDelegate cancelButtonPressed];
}

- (void)postButtonPressed
{
    id<REComposeSheetViewDelegate> localDelegate = _delegate;
    if ([localDelegate respondsToSelector:@selector(postButtonPressed)])
        [localDelegate postButtonPressed];
}

@end
