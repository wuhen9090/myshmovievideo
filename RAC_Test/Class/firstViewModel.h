//
//  firstViewModel.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MRCTableViewModel.h"
#import "MRCViewModelServices.h"
@interface firstViewModel : MRCTableViewModel
@property (nonatomic, strong) RACSignal *loginSingal;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *didSelectCommand;
@property (nonatomic, strong) NSArray *arrayData;
@end
