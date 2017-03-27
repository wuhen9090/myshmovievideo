//
//  firstViewModel.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/23.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface firstViewModel : NSObject
@property (nonatomic, strong) RACSignal *loginSingal;
@property (nonatomic, strong) RACCommand *loginCommand;
@end
