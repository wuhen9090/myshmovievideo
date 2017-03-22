//
//  ViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/9.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"暮落晨曦"];
        return nil;
    }];
    [singal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
