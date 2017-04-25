//
//  HYBTestModel.m
//  CellEmbedTableView
//
//  Created by huangyibiao on 16/3/1.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import "HYBTestModel.h"

@implementation HYBTestModel

- (NSMutableArray *)commentModels {
  if (_commentModels == nil) {
    _commentModels = [[NSMutableArray alloc] init];
  }
  
  return _commentModels;
}

@end
