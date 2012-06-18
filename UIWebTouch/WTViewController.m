//
//  WTViewController.m
//  UIWebTouch
//
//  Created by Felix Chern on 12/6/18.
//  Copyright (c) 2012年 idryman@gmail.com. All rights reserved.
//

#import "WTViewController.h"

@interface WTViewController ()
@property (nonatomic,strong) NSURL *baseURL;
@property (nonatomic,strong) NSURL *fileURL;
@end

@implementation WTViewController
@synthesize webView;
@synthesize baseURL;
@synthesize fileURL;

- (void)viewDidLoad
{
    [super viewDidLoad];
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
	// Do any additional setup after loading the view, typically from a nib.
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

@end
