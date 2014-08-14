//
//  SBHotStuffViewController.m
//  SexyBack
//
//  Created by Bryan Dunbar on 8/11/14.
//  Copyright (c) 2014 Knight, Norvell and Pater, LLC. All rights reserved.
//

#import "SBHotStuffViewController.h"

@interface SBHotStuffViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic,strong) UIBarButtonItem *webViewBackButton;
@property (nonatomic,strong) UIBarButtonItem *webViewForwardButton;
-(void)updateBarButtons;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation SBHotStuffViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.webView.delegate = self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.pureromance.com"]]];
    
    self.webViewBackButton = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(webViewBackTapped:)];
    self.webViewForwardButton = [[UIBarButtonItem alloc] initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(webViewForwardTapped:)];
    
    self.navigationItem.rightBarButtonItems = @[self.webViewForwardButton, self.webViewBackButton];
    
    [self updateBarButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateBarButtons {
    self.webViewBackButton.enabled = self.webView.canGoBack;
    self.webViewForwardButton.enabled = self.webView.canGoForward;
}

-(void)webViewForwardTapped:(id)sender {
    [self.webView goForward];
}
-(void)webViewBackTapped:(id)sender {
    [self.webView goBack];
}

#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (!webView.canGoBack) {
        [self.activityIndicator startAnimating];
    }
    [self updateBarButtons];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityIndicator stopAnimating];
    [self updateBarButtons];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityIndicator stopAnimating];
    [self updateBarButtons];
}
@end
