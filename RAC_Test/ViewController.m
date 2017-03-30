//
//  ViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/9.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "ViewController.h"
#import "firstViewModel.h"
#import "CBStoreHouseRefreshControl.h"
#import "MyTableViewCell.h"
@interface ViewController ()
//@property (nonatomic, strong) firstViewModel *viewModel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *testButton;
@property (nonatomic, strong) UITableView *testTableView;
@property (nonatomic, strong) CBStoreHouseRefreshControl *refreshControl;
@end

@implementation ViewController
- (void)dealloc{
    NSLog(@"dellac");
}
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initUI];


}
- (void)bindViewModel {
    [super bindViewModel];
    RACSignal *singal = [RACSignal createSignal:^RACDisposable *(id subscriber) {
        [subscriber sendNext:@"暮落晨曦"];
        return nil;
    }];
    [singal subscribeNext:^(id x) {
        NSLog(@"%@", x);
    }];

//     @weakify(self);
//    [RACObserve(self.viewModel, arrayData) subscribeNext:^(id x) {
//        @strongify(self);
//        [self.testTableView reloadData];
//    }];
    
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
    //   [[self.testButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
    //      [self.viewModel.loginCommand execute:nil];
    //   }];
    
//    self.testButton.rac_command = self.viewModel.loginCommand;


}
- (void)initUI {
//    self.tableView.backgroundColor = [UIColor redColor];
//    [self.view addSubview:self.imageView];
//    [self.view addSubview:self.testButton];
//    [self.view addSubview:self.testTableView];
//    self.refreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.testTableView
//                                                                  target:self
//                                                           refreshAction:@selector(refreshTriggered:)
//                                                                   plist:@"headViewForTableView"
//                                                                   color:[UIColor redColor]
//                                                               lineWidth:2
//                                                              dropHeight:80
//                                                                   scale:1
//                                                    horizontalRandomness:300
//                                                 reverseLoadingAnimation:NO
//                                                 internalAnimationFactor:1];
    
    //    self.refreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.testTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"AKTA" color:[UIColor blueColor] lineWidth:2 dropHeight:80 scale:0.7 horizontalRandomness:300 reverseLoadingAnimation:NO internalAnimationFactor:0.7];
//    [self updateViewConstraintsForView ];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    if (cell == nil) {
        cell = [[MyTableViewCell alloc] init];
    }
    return cell;
}

- (void)configureCell:(MyTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(NSString *)viewModel {
    [cell bindViewModel:viewModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    MRCNewsItemViewModel *viewModel = self.viewModel.dataSource[indexPath.section][indexPath.row];
//    return viewModel.height;
    return 40;
}

- (void)updateViewConstraintsForView {
    @weakify(self);
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(self.view.mas_top).offset(100);
//        make.left.equalTo(self.view.mas_left).offset(50);
//        make.size.mas_equalTo(self.imageView.image.size);
//    }];
//    [self.testButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(self.imageView.mas_bottom).offset(100);
//        make.left.equalTo(self.view.mas_left);
//        make.size.mas_equalTo(CGSizeMake(100, 50));
//    }];
//    [self.testTableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        @strongify(self);
//        make.top.equalTo(self.view.mas_top).offset(-64);
//        make.left.right.bottom.equalTo(self.view);
//    }];

}
//
//- (UIImageView *)imageView {
//    if (!_imageView) {
//        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"56logo"]];
//    }
//    return _imageView;
//}
//- (UIButton *)testButton {
//    if (!_testButton) {
//        _testButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_testButton setTitle:@"测试" forState:UIControlStateNormal];
//        [_testButton setTintColor:[UIColor redColor]];
//        [_testButton setBackgroundColor:[UIColor blueColor]];
//    }
//    return _testButton;
//}
//- (UITableView *)testTableView {
//    if (!_testTableView) {
//        _testTableView = [[UITableView alloc]initWithFrame:self.view.bounds];
//        _testTableView.contentInset  = UIEdgeInsetsMake(64, 0, 0, 0);
//        _testTableView.delegate = self;
//        _testTableView.dataSource = self;
//        [_testTableView registerClass:[MyTableViewCell class] forCellReuseIdentifier:@"cell"];
//        _testTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _testTableView.alwaysBounceVertical = YES;
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.automaticallyAdjustsScrollViewInsets = NO;
//
//    }
//    return _testTableView;
//}
//
//#pragma mark - Notifying refresh control of scrolling
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    [self.refreshControl scrollViewDidScroll];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    [self.refreshControl scrollViewDidEndDragging];
//}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    [self.refreshControl scrollViewDidEndDragging];
//}

#pragma mark - Listening for the user to trigger a refresh

- (void)refreshTriggered:(id)sender
{
    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
}

- (void)finishRefreshControl
{
    [self.refreshControl finishingLoading];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
