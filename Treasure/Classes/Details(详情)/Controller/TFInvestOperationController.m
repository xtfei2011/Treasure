//
//  TFInvestOperationController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/17.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFInvestOperationController.h"
#import "TFInvestOperationView.h"
#import "TFChooseView.h"
#import "TFButtonModel.h"
#import "TFRechargeViewController.h"
#import "TFAlertView.h"
#import "TFMineInvestController.h"

@interface TFInvestOperationController ()<TFInvestOperationViewDelegate, TFChooseViewDelegate>
@property (nonatomic ,strong) TFInvestOperationView *operationView;
/*** 筛选框 ***/
@property (nonatomic ,strong) TFChooseView *chooseView;
/*** 遮盖 ***/
@property (nonatomic ,strong) UIView *maskView;
@property (nonatomic ,strong) TFButtonModel *buttonModel;
/*** 优惠类型 ***/
@property (nonatomic ,strong) NSString *favorableType;
/*** 优惠id ***/
@property (nonatomic ,strong) NSString *favorableID;
/*** 优惠金额 ***/
@property (nonatomic ,strong) NSString *money;
@property (nonatomic ,assign, getter = isOpen) BOOL open;
@property (nonatomic ,strong) TFAlertView *alertView;
@end

@implementation TFInvestOperationController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"我要投资";
    
    _alertView = [[TFAlertView alloc] initWithFrame:TFScreeFrame];
    
    [self setupTopView];              /*** 加载顶部标信息View ***/
    [self loadBalance];
    [self loadBottomButtonView];      /*** 加载底部投标按钮 ***/
}

/*** 加载标信息 ***/
- (void)setupTopView
{
    _operationView = [TFInvestOperationView viewFromXib];
    _operationView.delegate = self;
    _operationView.investDetail = self.investDetail;
    [self.view addSubview:_operationView];
}

- (void)loadBalance
{
    [TFNetworkTools getResultWithUrl:@"api/user/queryBalance" params:nil success:^(id responseObject) {
        _operationView.balanceLabel.text = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"][@"balance"] doubleValue]];
    } failure:^(NSError *error) { }];
}

/*** 充值代理点击事件 ***/
- (void)investmentOperationChooseBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    switch (sender.tag) {
        case 1888:
        {
            TFRechargeViewController *recharge = [[TFRechargeViewController alloc] init];
            [self.navigationController pushViewController:recharge animated:YES];
        }
            break;
        case 1889:
        {
            [self loadChooseViewButtonModel];
        }
            break;
        default:
            break;
    }
}

/*** 获取筛选View数据 ***/
- (void)loadChooseViewButtonModel
{
    __weak typeof(self) homeSelf = self;
    
    NSString *urlStr = [NSString stringWithFormat:@"api/invest/basicCouponList/%@",self.comment.ID];
    [TFNetworkTools getResultWithUrl:urlStr params:nil success:^(id responseObject) {
        
        homeSelf.buttonModel = [TFButtonModel mj_objectWithKeyValues:responseObject[@"data"]];
        
        if (!self.buttonModel.addinterest.count && !self.buttonModel.award.count && !self.buttonModel.relived) {
            
            [TFProgressHUD showInfoMsg:@"您没有任何优惠券"];
        } else {
            
            [self openChooseView];
        }
    } failure:^(NSError *error) { }];
}

/*** 确定按钮点击事件 ***/
- (void)chooseViewSureButtonClick:(UIButton *)sender;
{
    if (sender.tag == 1111) {
        _operationView.favorLabel.text = @"选择优惠类型";
        _favorableID = _favorableType = _money = nil;
        
        [self closeChooseView];
    } else {
        
        NSString *favorStr = @"";
        if ([_favorableType isEqualToString:@"relived"]) {
            
            favorStr = @"体验金";
        } else if ([_favorableType isEqualToString:@"award"]) {
            
            favorStr = @"现金劵";
        } else if ([_favorableType isEqualToString:@"addinterest"]) {
            
            favorStr = @"加息劵";
        }
        
        if (_money.length == 0) {
            
            __weak typeof(self) homeSelf = self;
            _alertView.block = ^(NSInteger index){
                
                [homeSelf.alertView removeFromSuperview];
            };
            [_alertView setPromptTitle:@"您还没有选择【加息劵/代金券/体验金】中任意一种优惠！" font:14];
            [_alertView setHintType:TFHintTypeDefault];
            [TFkeyWindowView addSubview:_alertView];
        } else {
            _operationView.favorLabel.text = [NSString stringWithFormat:@"%@:%@",favorStr, _money];
        }
        [self closeChooseView];
    }
}

/*** 底部投资按钮 ***/
- (void)loadBottomButtonView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, TFMainScreen_Height - 114, TFMainScreen_Width, 50)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    UIButton *btn = [UIButton createButtonFrame:CGRectMake(10, 5, baseView.xtf_width - 20, 40) title:@"确认投标" titleColor:[UIColor whiteColor] font:TFMoreTitleFont target:self action:@selector(notarizeButtonClick:)];
    [baseView addSubview:btn];
}

/*** 投标按钮点击 ***/
- (void)notarizeButtonClick:(UIButton *)sender
{
    [TFProgressHUD showLoading:@"正在为您投资!"];
    
    if (_favorableID == nil) {
        _favorableID = @"";
    }
    
    if (_favorableType == nil) {
        _favorableType = @"";
    }
    
    if (_operationView.moneyfield.text.length == 0) {
        [TFProgressHUD showInfoMsg:@"请输入投资金额！"];
    } else if ([self.investDetail.lock isEqualToString:@"on"] && _operationView.passField.text.length == 0) {
        [TFProgressHUD showInfoMsg:@"请输入约标密码！"];
    } else {
        
        NSString *urlStr = [NSString stringWithFormat:@"api/tender/%@",self.comment.ID];
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"money"] = _operationView.moneyfield.text;
        params[@"coupon"] = _favorableType;
        params[@"coupon_id"] = _favorableID;
        params[@"appoint"] = _operationView.passField.text;
        
        [TFNetworkTools postResultWithUrl:urlStr params:params success:^(id responseObject) {
            [TFProgressHUD dismiss];
            TFLog(@"-->%@",responseObject);
            if ([responseObject[@"code"] isEqual:@500011]) {
                [_alertView setPromptTitle:@"您还没有开户，部分功能因此受限！现在去开户吗？" font:14];
                [_alertView setHintType:TFHintTypeSelect];
                [TFkeyWindowView addSubview:_alertView];
                
                __weak typeof(self) homeSelf = self;
                _alertView.block = ^(NSInteger index){
                    [homeSelf.alertView removeFromSuperview];
                    if (index == 2001) {
                        [homeSelf authentication];
                    }
                };
            } else if ([responseObject[@"code"] isEqual:@200]) {
                
                [TFProgressHUD showSuccess:responseObject[@"msg"]];
                TFMineInvestController *mineInvest = [[TFMineInvestController alloc] init];
                [self.navigationController pushViewController:mineInvest animated:YES];
            } else {
                [TFProgressHUD showInfoMsg:responseObject[@"msg"]];
            }
        } failure:^(NSError *error) {  }];
    }
}

/*** 富友开户 ***/
- (void)authentication
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/user/zbankRegister.html")];
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark ----- 选择框
/*** 商品筛选View ***/
- (TFChooseView *)chooseView
{
    if (!_chooseView) {
        _chooseView = [[TFChooseView alloc] initWithFrame:CGRectMake(0, TFMainScreen_Height, TFMainScreen_Width, TFMainScreen_Height * 0.5)];
        _chooseView.delegate = self;
        
        _chooseView.buttonView.buttonBlock = ^(NSString *favorableID, NSString *favorable, NSString *money) {
            _favorableID = favorableID;
            _favorableType = favorable;
            _money = money;
        };
        _chooseView.buttonModel = self.buttonModel;
    }
    return _chooseView;
}

/*** 遮盖 ***/
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:TFScreeFrame];
        _maskView.backgroundColor = TFRGBColor(5, 5, 5, 0.3);
        /*** 添加点击背景按钮 ***/
        UIButton *btn = [[UIButton alloc] initWithFrame:TFScreeFrame];
        [btn addTarget:self action:@selector(closeChooseView) forControlEvents:UIControlEventTouchUpInside];
        [_maskView addSubview:btn];
    }
    return _maskView;
}

- (void)openChooseView
{
    [TFkeyWindowView addSubview:self.maskView];
    [TFkeyWindowView addSubview:self.chooseView];
    
    [UIView animateWithDuration:0.2 animations:^{
        self.view.layer.transform = [self firstStepTransform];
        self.maskView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [self secondStepTransform];
            self.chooseView.transform = CGAffineTransformTranslate(self.chooseView.transform, 0, -TFMainScreen_Height*0.5);
        }];
    }];
}

- (void)closeChooseView
{    
    if (self.isOpen) {
        self.open = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.maskView.alpha = 0.0;
        }completion:^(BOOL finished) {
            [self.maskView removeFromSuperview];
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.layer.transform = [self firstStepTransform];
            self.chooseView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                self.view.layer.transform = CATransform3DIdentity;
                self.maskView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.maskView removeFromSuperview];
                [self.chooseView removeFromSuperview];
            }];
        }];
    }
}

- (CATransform3D)secondStepTransform
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = [self firstStepTransform].m34;
    transform = CATransform3DTranslate(transform, 0, TFMainScreen_Width * -0.08, 0);
    transform = CATransform3DScale(transform, 0.8, 0.8, 1.0);
    return transform;
}

- (CATransform3D)firstStepTransform
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 1.0 / -500.0;
    transform = CATransform3DScale(transform, 0.98, 0.98, 1.0);
    transform = CATransform3DRotate(transform, 5.0 * M_PI / 180.0, 1, 0, 0);
    transform = CATransform3DTranslate(transform, 0, 0, -30.0);
    return transform;
}

- (void)dealloc
{
    _operationView.moneyfield.text = nil;
    _operationView.passField.text = nil;
}
@end
