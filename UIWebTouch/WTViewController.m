//
//  WTViewController.m
//  UIWebTouch
//
//  Created by Felix Chern on 12/6/18.
//  Copyright (c) 2012 Felix Chern idryman@gmail.com. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright
//      notice, this list of conditions and the following disclaimer.
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//    * Neither the name of highlight.js nor the names of its contributors 
//      may be used to endorse or promote products derived from this software 
//      without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND ANY
//  EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE REGENTS AND CONTRIBUTORS BE LIABLE FOR ANY
//  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
//  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
//  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
//  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "WTViewController.h"

@interface WTViewController ()
@property (nonatomic,strong) NSURL *baseURL;
@property (nonatomic,strong) NSURL *fileURL;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) UIGestureRecognizerState gestureState;
@end

@implementation WTViewController
@synthesize webView;
@synthesize baseURL;
@synthesize fileURL;
@synthesize timer;
@synthesize gestureState;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Load a webpage
    baseURL = [[NSBundle mainBundle] URLForResource:@"highlight" withExtension:nil];
    fileURL = [[NSBundle mainBundle] URLForResource:@"macho.js" withExtension:nil];
    
    NSString *content = [[NSString alloc] initWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    NSString *escapeContent = [[[content stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
                                stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
                               stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
    
    NSMutableString *result = [[NSMutableString alloc] init ];
    
    [result appendString:@"<!doctype html><head><title>Test</title>"];
    [result appendString:@"<link rel='stylesheet' href='styles/default.css'>"];
    [result appendString:@"<script type='text/javascript' src='highlight.pack.js'></script>"];
    [result appendString:@"<script type='text/javascript'>hljs.initHighlightingOnLoad();</script>"];
    [result appendString:@"</head><body><pre><code>"];
    [result appendString:escapeContent];
    [result appendString:@"</code></pre></body></html>"];
    [webView loadHTMLString:result baseURL:baseURL];
    
    
    // Touch event handler
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:nil];
    singleTap.numberOfTapsRequired = 1;
    singleTap.delegate = self;
    [self.view addGestureRecognizer:singleTap];
        
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Gesture Recognizer delegate

// This method receive touch event first
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    NSLog(@"gestureRecognizer shouldReceiveTouch: tapCount = %d",(int)touch.tapCount);
    if (touch.tapCount ==1) {
        self.timer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(handleSingleTap:) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.gestureState = UIGestureRecognizerStateBegan;
        return YES;
    }
    else if (touch.tapCount ==2 && self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    return NO;
}

// This is the second method to recognize touch event
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    NSLog(@"shouldRecognizeSimultaneouslyWithGestureRecognizer, state is %@",[self debugUIGestureState:gestureRecognizer.state]);
    self.gestureState = gestureRecognizer.state;
    return YES;
}

// Handler will be called from timer
- (void)handleSingleTap:(UITapGestureRecognizer*)sender {
    NSLog(@"handleSingleTap, state: %@", [self debugUIGestureState:self.gestureState]);
    if (self.gestureState==UIGestureRecognizerStateRecognized) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"SingleTap" message:@"Oh yes!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (NSString*) debugUIGestureState: (UIGestureRecognizerState) state {
    NSString *str;
    switch (state) {
        case UIGestureRecognizerStateBegan:str=@"UIGestureRecognizerStateBegan";break;
        case UIGestureRecognizerStateEnded:str=@"UIGestureRecognizerStateEnded";break;
        case UIGestureRecognizerStateFailed:str=@"UIGestureRecognizerStateFailed";break;
        case UIGestureRecognizerStateChanged:str=@"UIGestureRecognizerStateChanged";break;
        case UIGestureRecognizerStatePossible:str=@"UIGestureRecognizerStatePossible";break;
        case UIGestureRecognizerStateCancelled:str=@"UIGestureRecognizerStateCancelled";break;
        default:
            break;
    }
    return str;
}


@end
