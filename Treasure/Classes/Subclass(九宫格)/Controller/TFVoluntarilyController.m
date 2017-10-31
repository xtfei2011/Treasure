//
//  TFVoluntarilyController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/20.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFVoluntarilyController.h"
#import "TFVoluntarilyView.h"
#import "TFVoluntarily.h"
#import "TFPickerView.h"

@interface TFVoluntarilyController ()
/*** 保存按钮 ***/
@property (nonatomic ,strong) UIButton *saveBtn;
/*** 开启自动投标 ***/
@property (nonatomic ,strong) UIButton *voluntBtn;
@property (nonatomic ,strong) TFVoluntarily *voluntarily;
@property (nonatomic ,strong) TFPickerView *pickerView;
@property (nonatomic ,strong) TFVoluntarilyView *voluntarilyView;

@property (nonatomic ,strong) NSString *btnTitle;
/*** 是否开启自动投标 ***/
@property (nonatomic ,assign ,getter = isOpen) BOOL isOpen;
/*** 是否保存设置 ***/
@property (nonatomic ,assign ,getter = isSave) BOOL isSave;
@end

@implementation TFVoluntarilyController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isSave = NO;
    
    self.navigationItem.title = @"自动投标";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"help" highImage:nil target:self action:@selector(voluntarilyHelpClickBtn)];
    
    [self setupTableView];
    
    _pickerView = [[TFPickerView alloc] init];
    
    [self setupRefresh];
}

- (void)voluntarilyHelpClickBtn
{
    TFWebViewController *webView = [[TFWebViewController alloc] init];
    [webView loadWebURLString:Common_Interface_Montage(@"api/autobidHelp")];
    [self.navigationController pushViewController:webView animated:YES];
}

- (void)setupTableView
{
    _volunTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, TFMainScreen_Width, TFMainScreen_Height - 114)];
    _volunTableView.backgroundColor = TFGlobalBg;
    _volunTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _volunTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _volunTableView.tableFooterView = [UIView new];
    [self.view addSubview:_volunTableView];
}

- (void)setupRefresh
{
    self.volunTableView.mj_header = [TFRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadVoluntarilyData)];
    [self.volunTableView.mj_header beginRefreshing];
}

- (void)loadVoluntarilyData
{
    __weak typeof(self) homeSelf = self;
    [TFNetworkTools getResultWithUrl:@"api/user/autobidQuery" params:nil success:^(id responseObject) {
        
        self.voluntarily = [TFVoluntarily mj_objectWithKeyValues:responseObject[@"data"]];
        [homeSelf.volunTableView reloadData];
        [homeSelf.volunTableView.mj_header endRefreshing];
        [self initView];
    } failure:^(NSError *error) {
        
    }];
}

- (void)initView
{
    if ([self.voluntarily.status isEqual:@"0"]) {
        _isOpen = NO;
        _btnTitle = @"开启自动投标";
    }else{
        _isOpen = YES;
        _btnTitle = @"关闭自动投标";
    }
    
    [self setvoluntarilyInvestView];
    /** 加载底部按钮 ***/
    [self loadBottomButtonView];
}

- (void)setvoluntarilyInvestView
{
    _voluntarilyView = [TFVoluntarilyView viewFromXib];
    _voluntarilyView.voluntarily = self.voluntarily;
    
    [_voluntarilyView.lowestRecognizer addTarget:self action:@selector(lowestChoose:)];
    [_voluntarilyView.highestRecognizer addTarget:self action:@selector(highestChoose:)];
    [_voluntarilyView.minimumRecognizer addTarget:self action:@selector(minimumChoose:)];
    [_voluntarilyView.tallestRecognizer addTarget:self action:@selector(tallesttChoose:)];
    [_volunTableView addSubview:_voluntarilyView];
}

- (void)loadBottomButtonView
{
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0,  CGRectGetMaxY(_volunTableView.frame), TFMainScreen_Width, 50)];
    baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:baseView];
    
    _saveBtn = [UIButton createButtonFrame:CGRectMake(10, 5, (baseView.xtf_width - 30) * 0.5, 40) title:@"保存设置" titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(saveButtonClick:)];
    [baseView addSubview:_saveBtn];
    
    _voluntBtn = [UIButton createButtonFrame:CGRectMake(CGRectGetMaxX(_saveBtn.frame) + 10, 5, (baseView.xtf_width - 30) * 0.5, 40) title:_btnTitle titleColor:[UIColor whiteColor]  font:[UIFont systemFontOfSize:19] target:self action:@selector(voluntButtonClick:)];
    _voluntBtn.backgroundColor = TFrayColor(123);
    [baseView addSubview:_voluntBtn];
}

/*** 最小年利率 ***/
- (void)lowestChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    self.pickerView.dataSource = InterestArray;
    self.pickerView.title = @"年利率";
    self.pickerView.defaultStr = nil;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.selectValue = ^(NSString *value){
        NSArray *stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.voluntarilyView.lowestLabel.text = (stateArr[0] == nil) ? @"5%" : stateArr[0];
    };
    [self.pickerView show];
}

/*** 最大年利率 ***/
- (void)highestChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    self.pickerView.dataSource = InterestArray;
    self.pickerView.title = @"年利率";
    self.pickerView.defaultStr = nil;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.selectValue = ^(NSString *value){
        NSArray *stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.voluntarilyView.highestLabel.text = (stateArr[0] == nil) ? @"24%" : stateArr[0];
    };
    [self.pickerView show];
}

/*** 最小期限 ***/
- (void)minimumChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    self.pickerView.dataSource = TimeLimitArray;
    self.pickerView.title = @"期限";
    self.pickerView.defaultStr = nil;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.selectValue = ^(NSString *value){
        NSArray *stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.voluntarilyView.minimumLabel.text = (stateArr[0] == nil) ? @"1个月" : stateArr[0];
    };
    [self.pickerView show];
}

/*** 最大期限 ***/
- (void)tallesttChoose:(UITapGestureRecognizer *)sender
{
    [self.view endEditing:YES];
    
    self.pickerView.dataSource = TimeLimitArray;
    self.pickerView.title = @"期限";
    self.pickerView.defaultStr = nil;
    
    __weak typeof(self) weakSelf = self;
    self.pickerView.selectValue = ^(NSString *value){
        NSArray *stateArr = [value componentsSeparatedByString:@"/"];
        weakSelf.voluntarilyView.tallestLabel.text = (stateArr[0] == nil) ? @"36个月" : stateArr[0];
    };
    [self.pickerView show];
}

- (void)saveButtonClick:(UIButton *)sender
{
    [TFProgressHUD showLoading:@"保存中···"];
    
    NSString *apr_min = [_voluntarilyView.lowestLabel.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSString *apr_max = [_voluntarilyView.highestLabel.text stringByReplacingOccurrencesOfString:@"%" withString:@""];
    NSString *month_min = [_voluntarilyView.minimumLabel.text stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    NSString *month_max = [_voluntarilyView.tallestLabel.text stringByReplacingOccurrencesOfString:@"个月" withString:@""];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"total"] = _voluntarilyView.rentalField.text;
    params[@"money"] = _voluntarilyView.onceField.text;
    params[@"apr_min"] = apr_min;
    params[@"apr_max"] = apr_max;
    params[@"month_min"] = month_min;
    params[@"month_max"] = month_max;
    params[@"retain"] = _voluntarilyView.surplusField.text;
    params[@"repay_method"] = @"none";
    
    [TFNetworkTools postResultWithUrl:@"api/user/autobid" params:params success:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqual:@200]) {
            [TFProgressHUD showSuccess:responseObject[@"msg"]];
            self.isSave = YES;
            _voluntBtn.backgroundColor = TFColor(252, 99, 102);
        }else{
            [TFProgressHUD showFailure:responseObject[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)voluntButtonClick:(UIButton *)sender
{
    NSString *service = @"";
    if (!_isOpen && !_isSave) {
        [TFProgressHUD showInfoMsg:@"您还没有对您的设置保存！"];
        
    } else if (!_isOpen && _isSave) {
        service = @"api/user/autobidSwitch/on";
        [self voluntSwitchButtonClick:service];
        
    }else if (_isOpen){
        service = @"api/user/autobidSwitch/off";
        [self voluntSwitchButtonClick:service];
    }
}

- (void)voluntSwitchButtonClick:(NSString *)service
{
    [TFNetworkTools getResultWithUrl:service params:nil success:^(id responseObject) {
        
        if (!_isOpen && _isSave) {
            _isOpen = YES;
        }else{
            _isOpen = NO;
        }
        [TFProgressHUD showSuccess:responseObject[@"msg"]];
        [self loadVoluntarilyData];
    } failure:^(NSError *error) {
        
    }];
}
@end
