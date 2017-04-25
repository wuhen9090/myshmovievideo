//
//  AutomaticCalculationCellHeightViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 2017/4/25.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "AutomaticCalculationCellHeightViewController.h"
#import "HYBTestCell.h"
#import "HYBCommentCell.h"
#import "HYBTestModel.h"
#import "HYBCommentModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@interface AutomaticCalculationCellHeightViewController ()<HYBTestCellDelegate>

@end

@implementation AutomaticCalculationCellHeightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureCell:(HYBTestCell *)cell atIndexPath:(NSIndexPath *)indexPath withObject:(id)object {
    [cell configCellWithModel:object indexPath:indexPath];
}
- (UITableViewCell *)tableView:(UITableView *)tableView dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath {
    HYBTestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HYBTestCell"];
    if (cell == nil) {
        cell = [[HYBTestCell alloc] init];
        cell.delegate = self;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HYBTestModel *model = [self.viewModel.dataSource[0] objectAtIndex:indexPath.row];
    
    CGFloat h = [HYBTestCell hyb_heightForTableView:tableView config:^(UITableViewCell *sourceCell) {
        HYBTestCell *cell = (HYBTestCell *)sourceCell;
        [cell configCellWithModel:model indexPath:indexPath];
    } cache:^NSDictionary *{
        NSDictionary *cache = @{kHYBCacheUniqueKey : model.uid,
                                kHYBCacheStateKey  : @"",
                                kHYBRecalculateForStateKey : @(model.shouldUpdateCache)};
        model.shouldUpdateCache = NO;
        return cache;
    }];
    
    return h;
}
#pragma mark - HYBTestCellDelegate
- (void)reloadCellHeightForModel:(HYBTestModel *)model atIndexPath:(NSIndexPath *)indexPath {
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

@end
