//
//  TFConst.m
//  Treasure
//
//  Created by 谢腾飞 on 2017/6/3.
//  Copyright © 2017年 谢腾飞. All rights reserved.
// @"https://api.minibook.cc/";

#import <UIKit/UIKit.h>

/*** 公共接口 ***/
NSString * const Comment_DataInterface = @"https://api.xjycf.com/";

NSString * const Upgrade_StoreInterface = @"https://itunes.apple.com/cn/app/%E6%96%B0%E7%BA%AA%E5%85%83%E9%87%91%E6%9C%8D/id1239298388?mt=8";


/*** 九宫格子分类顶部菜单 ***/
/*** 资金记录 ***/
NSString * const MENU_BASE_FUNDRECORD = @"api/user/fundsCondition";
/*** 我的投资 ***/
NSString * const MENU_BASE_MINEINVEST = @"api/user/investCondition";
/*** 待回收 ***/
NSString * const MENU_BASE_NOTRECOVERED = @"api/user/investRepayCondition/to_be_recovered";
/*** 已回收 ***/
NSString * const MENU_BASE_HASBEENBACK = @"api/user/investRepayCondition/recycled";


/*** 九宫格子分类界面数据 ***/
/*** 资金记录 ***/
NSString * const BASE_LIST_FUNDRECORD = @"api/user/fundsList";
/*** 我的投资 ***/
NSString * const BASE_LIST_MINEINVEST = @"api/user/investList";
/*** 待回收 ***/
NSString * const BASE_LIST_NOTRECOVERED = @"api/user/investRepayList/to_be_recovered";
/*** 已回收 ***/
NSString * const BASE_LIST_HASBEENBACK = @"api/user/investRepayList/recycled";


/*** 网络判断 ***/
BOOL whetherHaveNetwork = NO;
