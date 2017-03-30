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
@end

@implementation ViewController
- (void)dealloc{
    NSLog(@"dellac");
}
- (void)viewDidLoad {
    [super viewDidLoad];
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

//#pragma mark - Listening for the user to trigger a refresh
//
//- (void)refreshTriggered:(id)sender
//{
//    [self performSelector:@selector(finishRefreshControl) withObject:nil afterDelay:3 inModes:@[NSRunLoopCommonModes]];
//}
//
//- (void)finishRefreshControl
//{
//    [self.refreshControl finishingLoading];
//}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
