//
//  HYBTestCell.m
//  CellEmbedTableView
//
//  Created by huangyibiao on 16/3/1.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBTestCell.h"
#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "Masonry.h"
#import "HYBCommentCell.h"
#import "HYBTestModel.h"
#import "HYBCommentModel.h"

@interface HYBTestCell () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) HYBTestModel *testModel;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation HYBTestCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImageView = [[UIImageView alloc] init];
    self.headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.headImageView];
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.top.mas_equalTo(10);
      make.width.height.mas_equalTo(80);
    }];
    
    // title
    self.titleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.preferredMaxLayoutWidth = screenWidth - 90 - 20;
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    __weak __typeof(self) weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(weakSelf.headImageView.mas_right).offset(10);
      make.top.mas_equalTo(weakSelf.headImageView);
      make.right.mas_equalTo(-10);
    }];
    
    // desc
    self.descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.descLabel];
    self.descLabel.preferredMaxLayoutWidth = screenWidth - 90 - 20;
    self.descLabel.numberOfLines = 0;
    self.descLabel.font = [UIFont systemFontOfSize:13];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.right.mas_equalTo(weakSelf.titleLabel);
      make.top.mas_equalTo(weakSelf.titleLabel.mas_bottom).offset(10);
    }];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.scrollEnabled = NO;
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(weakSelf.descLabel);
      make.top.mas_equalTo(weakSelf.descLabel.mas_bottom).offset(10);
      make.right.mas_equalTo(-10);
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.hyb_lastViewInCell = self.tableView;
    self.hyb_bottomOffsetToCell = 10;
  }
  
  return self;
}

- (void)configCellWithModel:(HYBTestModel *)model indexPath:(NSIndexPath *)indexPath {
  self.indexPath = indexPath;
  
  self.titleLabel.text = model.title;
  self.descLabel.text = model.desc;
  self.headImageView.image = [UIImage imageNamed:model.headImage];
  
  self.testModel = model;
  CGFloat tableViewHeight = 0;
  for (HYBCommentModel *commentModel in model.commentModels) {
    CGFloat cellHeight = [HYBCommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
      HYBCommentCell *cell = (HYBCommentCell *)sourceCell;
      [cell configCellWithModel:commentModel];
    } cache:^NSDictionary *{
      return @{kHYBCacheUniqueKey : commentModel.cid,
               kHYBCacheStateKey : @"",
               kHYBRecalculateForStateKey : @(NO)};
    }];
    tableViewHeight += cellHeight;
  }
  
  [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
    make.height.mas_equalTo(tableViewHeight);
  }];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
  
  if (!cell) {
    cell = [[HYBCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
  }
  
  HYBCommentModel *model = [self.testModel.commentModels objectAtIndex:indexPath.row];
  [cell configCellWithModel:model];
  
  return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.testModel.commentModels.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  HYBCommentModel *model = [self.testModel.commentModels objectAtIndex:indexPath.row];
  
  return [HYBCommentCell hyb_heightForTableView:self.tableView config:^(UITableViewCell *sourceCell) {
    HYBCommentCell *cell = (HYBCommentCell *)sourceCell;
    [cell configCellWithModel:model];
  } cache:^NSDictionary *{
    return @{kHYBCacheUniqueKey : model.cid,
             kHYBCacheStateKey : @"",
             kHYBRecalculateForStateKey : @(NO)};
  }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  // 添加一条数据
  HYBCommentModel *model = [[HYBCommentModel alloc] init];
  model.name = @"标哥";
  model.reply = @"标哥的技术博客";
  model.comment = @"哈哈，我被点击后自动添加了一条数据的，不要在意我~";
  model.cid = [NSString stringWithFormat:@"commonModel%ld",  self.testModel.commentModels.count + 1];
  [self.testModel.commentModels addObject:model];
  
  if ([self.delegate respondsToSelector:@selector(reloadCellHeightForModel:atIndexPath:)]) {
    self.testModel.shouldUpdateCache = YES;
    [self.delegate reloadCellHeightForModel:self.testModel atIndexPath:self.indexPath];
  }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
  return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
  if (editingStyle == UITableViewCellEditingStyleDelete) {
    [self.testModel.commentModels removeObjectAtIndex:indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(reloadCellHeightForModel:atIndexPath:)]) {
      self.testModel.shouldUpdateCache = YES;
      [self.delegate reloadCellHeightForModel:self.testModel atIndexPath:self.indexPath];
    }
  }
}

@end
