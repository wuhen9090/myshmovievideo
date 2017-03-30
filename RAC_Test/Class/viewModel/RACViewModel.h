//
//  RACViewModel.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/29.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCViewModelServices.h"
@interface RACViewModel : NSObject
@property (nonatomic, strong, readonly) id<MRCViewModelServices> services;
@end
