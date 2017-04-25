//
//  HYBTestCell.h
//  CellEmbedTableView
//
//  Created by huangyibiao on 16/3/1.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HYBTestModel;

@protocol HYBTestCellDelegate <NSObject>

- (void)reloadCellHeightForModel:(HYBTestModel *)model atIndexPath:(NSIndexPath *)indexPath;

@end

@interface HYBTestCell : UITableViewCell

@property (nonatomic, weak) id delegate;

- (void)configCellWithModel:(HYBTestModel *)model indexPath:(NSIndexPath *)indexPath;

@end
