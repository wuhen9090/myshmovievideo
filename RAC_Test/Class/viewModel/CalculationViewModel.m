//
//  CalculationViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 2017/4/25.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "CalculationViewModel.h"
#import "HYBTestModel.h"
#import "HYBCommentModel.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"

@implementation CalculationViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
        [self setUpSingal];
    }
    return self;
}

- (void)setUpSingal {
    self.shouldPullToRefresh = YES;
    self.arrayData = [NSMutableArray array];
    for (NSUInteger i = 0; i < 100; ++i) {
        HYBTestModel *testModel = [[HYBTestModel alloc] init];
        testModel.title = @"标哥的技术博客";
        testModel.desc = @"由标哥的技术博客出品，学习如何在cell中嵌套使用tableview并自动计算行高。同时演示如何通过HYBMasonryAutoCellHeight自动计算行高，关注博客：http://www.henishuo.com";
        testModel.headImage = @"head";
        testModel.uid = [NSString stringWithFormat:@"testModel%ld", i + 1];
        NSUInteger randCount = arc4random() % 10 + 1;
        for (NSUInteger j = 0; j < randCount; ++j) {
            HYBCommentModel *model = [[HYBCommentModel alloc] init];
            model.name = @"标哥";
            model.reply = @"标哥的技术博客";
            model.comment = @"可以试试HYBMasonryAutoCellHeight这个扩展，自动计算行高的";
            model.cid = [NSString stringWithFormat:@"commonModel%ld", j + 1];
            [testModel.commentModels addObject:model];
        }
        
        [self.arrayData addObject:testModel];
    }
    self.dataSource = @[self.arrayData];
}

@end
