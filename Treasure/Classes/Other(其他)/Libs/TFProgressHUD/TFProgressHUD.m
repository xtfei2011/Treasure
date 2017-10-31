//
//  TFProgressHUD.m
//  Q友社交
//
//  Created by 谢腾飞 on 2016/11/2.
//  Copyright © 2016年 谢腾飞. All rights reserved.
//

#import "TFProgressHUD.h"

@implementation TFProgressHUD

+ (instancetype)sharedHUD
{
    static TFProgressHUD *hud;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hud = [[TFProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    });
    return hud;
}

+ (void)showStatus:(TFProgressHUDStatus)status text:(NSString *)text
{
    TFProgressHUD *hud = [TFProgressHUD sharedHUD];
    [hud show:YES];
    [hud setLabelText:text];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:14]];
    [hud setMinSize:CGSizeMake(100, 100)];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    
    switch (status) {
            
        case TFProgressHUDStatusSuccess: {
            
            UIImage *sucImage = [UIImage imageNamed:@"hud_success"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *sucView = [[UIImageView alloc] initWithImage:sucImage];
            hud.customView = sucView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case TFProgressHUDStatusError: {
            
            UIImage *errImage = [UIImage imageNamed:@"hud_error"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *errView = [[UIImageView alloc] initWithImage:errImage];
            hud.customView = errView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        case TFProgressHUDStatusWaitting: {
            
            hud.mode = MBProgressHUDModeIndeterminate;
        }
            break;
            
        case TFProgressHUDStatusInfo: {
            
            UIImage *infoImage = [UIImage imageNamed:@"hud_info"];
            hud.mode = MBProgressHUDModeCustomView;
            UIImageView *infoView = [[UIImageView alloc] initWithImage:infoImage];
            hud.customView = infoView;
            [hud hide:YES afterDelay:2.0f];
        }
            break;
            
        default:
            break;
    }
}

+ (void)showMessage:(NSString *)text
{
    TFProgressHUD *hud = [TFProgressHUD sharedHUD];
    [hud show:YES];
    [hud setLabelText:text];
    [hud setMinSize:CGSizeZero];
    [hud setMode:MBProgressHUDModeText];
    [hud setRemoveFromSuperViewOnHide:YES];
    [hud setLabelFont:[UIFont boldSystemFontOfSize:14]];
    [[UIApplication sharedApplication].keyWindow addSubview:hud];
    [hud hide:YES afterDelay:2.0f];
}

+ (void)showInfoMsg:(NSString *)text {
    
    [self showStatus:TFProgressHUDStatusInfo text:text];
}

+ (void)showFailure:(NSString *)text {
    
    [self showStatus:TFProgressHUDStatusError text:text];
}

+ (void)showSuccess:(NSString *)text {
    
    [self showStatus:TFProgressHUDStatusSuccess text:text];
}

+ (void)showLoading:(NSString *)text {
    
    [self showStatus:TFProgressHUDStatusWaitting text:text];
}

+ (void)dismiss {
    
    [[TFProgressHUD sharedHUD] hide:YES];
}
@end
