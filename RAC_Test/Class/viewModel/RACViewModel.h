//
//  RACViewModel.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/29.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCViewModelServices.h"
@interface RACViewModel : MRCViewModel
@property (nonatomic, strong) RACSignal *loginSingal;
@property (nonatomic, strong) RACCommand *loginCommand;
@end
