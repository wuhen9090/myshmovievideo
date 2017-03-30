//
//  RACViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/29.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "RACViewController.h"
#import "RACViewModel.h"
@interface RACViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *testButton;

@end

@implementation RACViewController
- (void)bindViewModel {
    [super bindViewModel];
    //第一种方式
    //    [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //
    //        [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    //    }];
    //第二种
    //    self.testButton.rac_command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
    //        return self.viewModel.loginSingal;
    //    }];
    //    [self.testButton.rac_command.executionSignals subscribeNext:^(RACSignal *loginSingal) {
    //        [loginSingal subscribeNext:^(id x) {
    //            if ([x integerValue] > 0) {
    //                NSLog(@"denglu success");
    //            }else{
    //                NSLog(@"denglu fail");
    //            }
    //        }];
    //    }];
    //第三中
       [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
          [((RACViewModel *)self.viewModel).loginCommand execute:nil];
       }];
    
        self.testButton.rac_command = ((RACViewModel *)self.viewModel).loginCommand;

}
@end
