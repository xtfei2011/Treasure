//
//  TFWebViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/9.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFWebViewController.h"
#import <WebKit/WKWebView.h>
#import <WebKit/WebKit.h>
#import "TFAlertView.h"
#import "TFLoginViewController.h"
#import "TFNavigationController.h"
#import "TFTiedCardController.h"

@interface TFWebViewController ()<WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler, UINavigationControllerDelegate, UINavigationBarDelegate>
@property (nonatomic ,strong) TFAlertView *alertView;
/*** 网页View ***/
@property (nonatomic ,strong) WKWebView *webView;
/*** 加载进度条 ***/
@property (nonatomic ,strong) UIProgressView *progressView;
/*** 网址链接 ***/
@property (nonatomic ,strong) NSString *urlStr;
/*** 返回按钮 ***/
@property (nonatomic ,strong) UIBarButtonItem *backBarItem;
/*** 关闭按钮 ***/
@property (nonatomic ,strong) UIBarButtonItem *closeBarItem;
/*** 请求链接保存 ***/
@property (nonatomic ,strong) NSMutableArray *urlArray;
@end

static void *TFBrowserContext = &TFBrowserContext;
@implementation TFWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"正在加载内容";
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    /*** 将WebView添加到主控制器 ***/
    [self.view addSubview:self.webView];
    self.webView.hidden = YES;
    /*** 加载网页 ***/
    [self loadWebView];
    /*** 加载进度条 ***/
    [self.view addSubview:self.progressView];
    /*** 刷新按钮 ***/
    [self rightBarButtonItem];
}

- (void)rightBarButtonItem
{
    UIButton *roadButton = [[UIButton alloc] init];
    roadButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    [roadButton setTitle:@"刷新" forState:UIControlStateNormal];
    [roadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [roadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [roadButton sizeToFit];
    // 这句代码放在sizeToFit后面
    roadButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -15);
    [roadButton addTarget:self action:@selector(roadLoadClicked) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:roadButton];
}

- (WKWebView *)webView
{
    if (!_webView) {
        /*** 网页配置 ***/
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        /*** 允许 OC ，JS 交互，选择视图 ***/
        configuration.selectionGranularity = YES;
        /*** 网页内容处理池 ***/
        configuration.processPool = [[WKProcessPool alloc] init];
        /*** 是否把内容全部加载到内存中后再去处理 ***/
        configuration.suppressesIncrementalRendering = YES;
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height - 64) configuration:configuration];
        _webView.backgroundColor = TFGlobalBg;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
        /*** KVO 添加进度条 ***/
        [_webView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:TFBrowserContext];
        /*** 开启手势 ***/
        _webView.allowsBackForwardNavigationGestures = YES;
        
        /*** 自适应尺寸 ***/
        [_webView sizeToFit];
    }
    return _webView;
}

/*** 加载网页 ***/
- (void)loadWebView
{
    TFAccount *account = [TFAccountTool account];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];

    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *value = [NSString stringWithFormat:@"Bearer %@",account.access_token];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [mutableRequest setValue:value forHTTPHeaderField:@"Authorization"];
    
    request = [mutableRequest copy];
    /*** 加载网页 ***/
    [self.webView loadRequest:request];
}

- (void)loadWebURLString:(NSString *)string
{
    self.urlStr = string;
}

/*** 网页加载完成，导航的变化 ***/
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSMutableString *js1 = [NSMutableString string];
    //删除顶部的导航条
    [js1 appendString:@"var header = document.getElementsByTagName('h1')[0];"];
    [js1 appendString:@"header.parentNode.removeChild(header);"];
    
    [webView evaluateJavaScript:js1 completionHandler:^(id evaluate, NSError * error) {
        self.webView.hidden = NO;
    }];
    
    self.navigationItem.title = self.webView.title;
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self setupNavigationLeftItems];
}

/*** 开始加载 ***/
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    /*** 开始加载的时候 ，显示进度条 ***/
    self.progressView.hidden = NO;
}

/*** 内容返回时调用 ***/
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    TFLog(@"内容返回");
}

/*** 跳转的时候调用 ***/
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    TFLog(@"正在跳转");
}

/*** 开始请求的时候调用 ***/
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    [webView evaluateJavaScript:@"var a = document.getElementsByTagName('a');for(var i=0;i<a.length;i++){a[i].setAttribute('target','');}" completionHandler:nil];
    
    if (navigationAction.targetFrame.isMainFrame) {
        [self pushCurrentViewWithRequest:navigationAction.request];
    }
    [self setupNavigationLeftItems];
    decisionHandler(WKNavigationActionPolicyAllow);
}

/*** 加载失败时候调用 ***/
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [TFProgressHUD showFailure:@"页面加载超时"];
}

/*** 跳转失败的时候调用 ***/
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    TFLog(@"跳转失败啦");
}

/*** 进度条 ***/
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{}

/*** 获取 js 里面的提示信息 ***/
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    __weak typeof(self) homeSelf = self;
    [_alertView setPromptTitle:message font:14];
    
    if ([message isEqualToString:@"invest"]) {
       
        self.tabBarController.selectedIndex = 1;
        [self closeItemClicked];
        completionHandler();
        
    } else if ([message isEqualToString:@"login"] || [message isEqualToString:@"register"]) {
        
        TFAccount *account = [TFAccountTool account];
        
        if (account.access_token) {
            self.tabBarController.selectedIndex = 3;
        } else{
            
            [self noneLogin];
        }
        [self closeItemClicked];
        completionHandler();
        
    } else if ([message isEqualToString:@"众邦开户成功"]) {
        
        [_alertView setHintType:TFHintTypeSelect];
        [TFkeyWindowView addSubview:_alertView];
        
        _alertView.block = ^(NSInteger index) {

            completionHandler();
            [homeSelf.alertView removeFromSuperview];
            if (index == 2000) {
                [homeSelf.navigationController popViewControllerAnimated:YES];
            } else if (index == 2001) {
                [homeSelf jumpTopup];
            }
        };
    } else {
        [_alertView setHintType:TFHintTypeDefault];
        [TFkeyWindowView addSubview:_alertView];
        
        _alertView.block = ^(NSInteger index){
            completionHandler();
            [homeSelf.alertView removeFromSuperview];
        };
    }
}

- (void)jumpTopup
{
    TFTiedCardController *tiedCard = [[TFTiedCardController alloc] init];
    [self.navigationController pushViewController:tiedCard animated:YES];
}

/*** 拦截执行网页中的JS方法 ***/
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    TFLog(@"---->%@",message);
}

/*** js 信息的交流 ***/
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler
{
    [_alertView setPromptTitle:message font:14];
    [_alertView setHintType:TFHintTypeSelect];
    [TFkeyWindowView addSubview:_alertView];
    
    __weak typeof(self) homeSelf = self;
    _alertView.block = ^(NSInteger index) {
        
        [homeSelf.alertView removeFromSuperview];
        if (index == 2000) {
            completionHandler(NO);
        } else {
            completionHandler(YES);
        }
    };
}

/*** KVO监听进度条 ***/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.webView) {
        
        [self.progressView setAlpha:1.0f];
        BOOL animated = self.webView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.webView.estimatedProgress animated:animated];
        
        if (self.webView.estimatedProgress >= 1.0f) {
            
            [UIView animateWithDuration:0.3f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                
                [self.progressView setProgress:0.0f animated:NO];
            }];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

/*** 请求链接处理 ***/
- (void)pushCurrentViewWithRequest:(NSURLRequest *)request
{
    NSURLRequest *lastRequest = (NSURLRequest *)[[self.urlArray lastObject] objectForKey:@"request"];
    
    if ([request.URL.absoluteString isEqualToString:@"about:blank"] || [lastRequest.URL.absoluteString isEqualToString:request.URL.absoluteString])   return;
    
    UIView *currentView = [self.webView snapshotViewAfterScreenUpdates:YES];
    [self.urlArray addObject:@{@"request":request,@"snapShotView":currentView}];
}

#pragma mark === 自定义返回/关闭按钮
- (void)setupNavigationLeftItems
{
    if (self.webView.canGoBack) {
        
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = 0;
        
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.backBarItem,self.closeBarItem] animated:NO];
    } else {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:@[self.backBarItem]];
    }
}

/*** 返回按钮 ***/
- (UIBarButtonItem *)backBarItem
{
    if (!_backBarItem) {
        
        UIButton *backButton = [[UIButton alloc] init];
        backButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        [backButton setTitle:@" 返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [backButton setImage:[UIImage imageNamed:@"navigationbar_back"] forState:UIControlStateNormal];
        [backButton sizeToFit];
        
        backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        [backButton addTarget:self action:@selector(backItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _backBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _backBarItem;
}

/*** 返回按钮 ***/
- (void)backItemClicked
{
    if (self.webView.goBack && ![self.webView.title isEqualToString:@""]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

/*** 关闭按钮 ***/
- (UIBarButtonItem *)closeBarItem
{
    if (!_closeBarItem) {
        _closeBarItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClicked)];
        [_closeBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIFont fontWithName:@"Helvetica-Bold" size:16], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//        _closeBarItem.tintColor = [UIColor whiteColor];
    }
    return _closeBarItem;
}

- (void)closeItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)roadLoadClicked
{
    [self.webView reload];
}

/*** 进度条 ***/
- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.frame = CGRectMake(0, 0, self.view.xtf_width, 2);
        /*** 进度条颜色 ***/
        [_progressView setTrackTintColor:TFColor(252, 99, 102)];
        _progressView.progressTintColor = TFColor(38, 123, 239);
    }
    return _progressView;
}

- (NSMutableArray *)urlArray
{
    if (!_urlArray) {
        _urlArray = [NSMutableArray array];
    }
    return _urlArray;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.webView setNavigationDelegate:nil];
    [self.webView setUIDelegate:nil];
}

/*** 移除 KVO 观察 ***/
- (void)dealloc
{
    [self.webView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
}

/*** 未登录状态 ***/
- (void)noneLogin
{
    TFLoginViewController *vc = [[TFLoginViewController alloc]init];
    TFNavigationController *nav = [[TFNavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
@end
