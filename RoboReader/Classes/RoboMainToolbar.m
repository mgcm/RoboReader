//
// Copyright (c) 2013 RoboReader ( http://brainfaq.ru/roboreader )
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


#import "RoboMainToolbar.h"
#import "RoboConstants.h"


///////////////////////////////////////////////////////////////////////////////
#pragma mark - Constant Macros
///////////////////////////////////////////////////////////////////////////////


#define TITLE_Y 8.0f
#define TITLE_X 12.0f
#define TITLE_HEIGHT 28.0f

#define BUTTON_X 0.0f
#define BUTTON_Y 0.0f
#define DONE_BUTTON_WIDTH 44.0f


///////////////////////////////////////////////////////////////////////////////
#pragma mark - Toolbar implementation
///////////////////////////////////////////////////////////////////////////////


@implementation RoboMainToolbar

@synthesize delegate;
@synthesize effectView;


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

        UIBlurEffect *blurrEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        effectView = [[UIVisualEffectView alloc] initWithEffect:blurrEffect];
        effectView.frame = self.bounds;
        [self addSubview:effectView];

        // shift buttons a little to avoid overlapping with ios7 status bar
        float ios7padding = 0.0f;

        UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        doneButton.frame = CGRectMake(BUTTON_X, BUTTON_Y, DONE_BUTTON_WIDTH, READER_TOOLBAR_HEIGHT);
        [doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchDown];

        UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake((READER_TOOLBAR_HEIGHT - 18) / 2, (READER_TOOLBAR_HEIGHT - 18) / 2 + ios7padding, 13, 18)];
        [backImage setImage:[UIImage imageNamed:@"back_button.png"]];
        [doneButton addSubview:backImage];

        doneButton.autoresizingMask = UIViewAutoresizingNone;

        [self addSubview:doneButton];

        theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectInset(self.bounds, 40, 0)];
        theSearchBar.searchBarStyle = UISearchBarStyleMinimal;
        theSearchBar.placeholder = @"Pesquisa";
        theSearchBar.delegate = self;
        [self addSubview:theSearchBar];

        for (UIView *subView in theSearchBar.subviews)
        {
            for (UIView *secondLevelSubview in subView.subviews){
                if ([secondLevelSubview isKindOfClass:[UITextField class]])
                {
                    UITextField *searchBarTextField = (UITextField *)secondLevelSubview;
                    searchBarTextField.textColor = [UIColor whiteColor];
                    break;
                }
            }
        }

        CGRect newFrame = self.frame;
        newFrame.origin.y -= newFrame.size.height;
        [self setFrame:newFrame];
        self.alpha = 0.0f;
        self.hidden = YES;
    }

    return self;
}



- (void)dealloc {
    theSearchBar = nil;
}


- (void)hideToolbar
{
    if (self.hidden == NO) {
        [theSearchBar resignFirstResponder];
        [UIView animateWithDuration:0.1 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             CGRect newFrame = self.frame;
                             newFrame.origin.y -= newFrame.size.height;
                             [self setFrame:newFrame];
                             self.alpha = 0.0f;
                         }
                         completion:^(BOOL finished) {
                             self.hidden = YES;
                         }
        ];
    }
}


- (void)showToolbar
{
    if (self.hidden == YES) {
        [UIView animateWithDuration:0.1 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void) {
                             self.hidden = NO;
                             self.alpha = 1.0f;
                             CGRect newFrame = self.frame;
                             newFrame.origin.y += newFrame.size.height;
                             [self setFrame:newFrame];
                         }
                         completion:NULL
        ];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [effectView setFrame:self.bounds];
    [theSearchBar setFrame:CGRectInset(self.bounds, 40, 0)];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark - Tool Bar Delegate
///////////////////////////////////////////////////////////////////////////////


- (void)doneButtonTapped:(UIBarButtonItem *)button
{
    [delegate dismissButtonTapped];
}


///////////////////////////////////////////////////////////////////////////////
#pragma mark - Search Bar Delegate
///////////////////////////////////////////////////////////////////////////////

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [delegate highlightText:searchBar.text];
}

@end
