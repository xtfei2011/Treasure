//
//  TFSetViewController.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/14.
//  Copyright © 2017年 谢腾飞. All rights reserved.
//

#import "TFSetViewController.h"
#import "TFSetHeaderView.h"
#import "TFPersonGroup.h"
#import "TFNormalViewCell.h"
#import "TFActionSheet.h"
#import "TFNoteChangeController.h"
#import "TFChangePasswordController.h"
#import "TFCardInformationController.h"

@interface TFSetViewController ()<ReplaceHeaderDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
/*** 添加组的数组 ***/
@property (nonatomic ,strong) NSMutableArray *normalArray;
@property (nonatomic ,strong) TFSetHeaderView *setView;
@end

@implementation TFSetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    self.tableView.tableFooterView = [UIView new];
    self.tableView.rowHeight = 44;
    
    [self setupTopView];
    [self setupGroup];
}

- (void)setupTopView
{
    _setView = [TFSetHeaderView viewFromXib];
    _setView.accountModel = self.accountModel;
    _setView.delegate = self;
    self.tableView.tableHeaderView = _setView;
}

- (void)setupGroup
{
    self.normalArray = [NSMutableArray array];
    
    /*** 第一组 ***/
    TFPersonGroup *group0 = [[TFPersonGroup alloc] init];
    TFNormalModel *info0 = [[TFNormalModel alloc] initWithTitle:@"绑定银行卡"];
    TFNormalModel *info1 = [[TFNormalModel alloc] initWithTitle:@"修改密码"];
    TFNormalModel *info2 = [[TFNormalModel alloc] initWithTitle:@"客户热线" subTitle:@"400-027-1848"];
    
    group0.items = @[info0, info1, info2];
    
    [self.normalArray addObject:group0];
    
    /*** 退出登录 ***/
    [self.tableView addSubview:[UIButton createButtonFrame:CGRectMake(10, 350, TFMainScreen_Width - 20, 40) title:@"退出登录" titleColor:[UIColor whiteColor] font:TFSetPromptTitleFont target:self action:@selector(exitBtnClick)]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TFPersonGroup *temp = self.normalArray[section];
    return temp.items.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.normalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TFNormalViewCell *cell = [TFNormalViewCell initWithTableView:tableView];
    TFPersonGroup *group = self.normalArray[indexPath.section];
    TFNormalModel *normalModel = group.items[indexPath.row];
    cell.normalModel = normalModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        if ([self.accountModel.open_zbank isEqualToString:@"inactivated"]) {
            TFWebViewController *webView = [[TFWebViewController alloc] init];
            [webView loadWebURLString:Common_Interface_Montage(@"api/user/zbankRegister.html")];
            [self.navigationController pushViewController:webView animated:YES];
        } else {
            
            TFCardInformationController *cardInformation = [[TFCardInformationController alloc] init];
            [self.navigationController pushViewController:cardInformation animated:YES];
        }
        
    } else if (indexPath.row == 1){
        
        NSArray *titles = @[@"通过短信验证修改密码", @"通过旧密码修改", @"修改支付密码"];
        
        TFActionSheet *sheet = [[TFActionSheet alloc] initWithTitles:titles clickAction:^(TFActionSheet *sheet, NSIndexPath *indexPath) {
            
            if (indexPath.row == 0) {
                TFNoteChangeController *noteChange = [[TFNoteChangeController alloc] init];
                noteChange.accountModel = self.accountModel;
                [self.navigationController pushViewController:noteChange animated:YES];
                
            } else if (indexPath.row == 1) {
                TFChangePasswordController *changePassword = [[TFChangePasswordController alloc] init];
                changePassword.type = true;
                [self.navigationController pushViewController:changePassword animated:YES];
                
            } else {
                TFChangePasswordController *changPassword = [[TFChangePasswordController alloc] init];
                changPassword.type = false;
                [self.navigationController pushViewController:changPassword animated:YES];
            }
        }];
        [sheet show];
        
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400-027-1848"]];
    }
}

- (void)replaceHeaderButtonClick:(UIButton *)sender
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"选择符合你气质的头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self openCamera];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self openPhotoAlbum];
    }]];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:controller animated:YES completion:nil];
}

/*** 打开相机 ***/
- (void)openCamera
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
    ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:ipc animated:YES completion:nil];
}

/*** 打开相册 ***/
- (void)openPhotoAlbum
{
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
    ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:ipc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    _setView.headerView.image = image;
    
    [TFProgressHUD showLoading:@"头像上传中..."];
    
    TFAccount *account = [TFAccountTool account];
    NSString *str = [@"Bearer " stringByAppendingString:account.access_token];
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manger.requestSerializer setValue:str forHTTPHeaderField:@"Authorization"];
    
    [manger POST:Common_Interface_Montage(@"api/user/upload/avatar") parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *titlefile = [NSString stringWithFormat:@"%@.png", str];
        NSData *imageData = UIImageJPEGRepresentation(_setView.headerView.image, 0.5);
        [formData appendPartWithFileData:imageData name:@"file" fileName:titlefile mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        TFLog(@"%@",responseObject);
        [TFProgressHUD showSuccess:@"头像更换完成"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [TFProgressHUD showFailure:@"网络好像出问题啦"];
    }];
}

/*** 退出登录 ***/
- (void)exitBtnClick
{
    [TFAccountTool logoutAccount];
    
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popViewControllerAnimated:YES];
    });
}

@end
