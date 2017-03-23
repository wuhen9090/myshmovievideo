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
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *testButton;
@end

@implementation ViewController
- (void)dealloc{
    NSLog(@"dellac");
}
- (instancetype)init {
    self = [super init];
    if (self) {
//        self.edgesForExtendedLayout = UIRectEdgeNone; // default: UIRectEdgeAll
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        self.edgesForExtendedLayout = UIRectEdgeAll;
        [self initUI];
    }
    return self;
}
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

- (void)initUI {
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.testButton];
    [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
    }];

    [self updateViewConstraintsForView ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraintsForView {
    @weakify(self);
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.view.mas_top).offset(100);
        make.left.equalTo(self.view.mas_left).offset(50);
        make.size.mas_equalTo(self.imageView.image.size);
    }];
    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(100);
        make.left.equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 50));
    }];

}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"56logo"]];
    }
    return _imageView;
}
- (UIButton *)testButton {
    if (!_testButton) {
        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_testButton setTitle:@"测试" forState:UIControlStateNormal];
        [_testButton setTintColor:[UIColor redColor]];
        [_testButton setBackgroundColor:[UIColor blueColor]];
    }
    return _testButton;
}
@end
