//
//  HYBTestModel.h
//  CellEmbedTableView
//
//  Created by huangyibiao on 16/3/1.
//  Copyright © 2016年 huangyibiao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HYBTestModel : NSObject

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *headImage;

// 评论数据源
@property (nonatomic, strong) NSMutableArray *commentModels;

// 因为评论是动态的，因此要标识是否要更新缓存
@property (nonatomic, assign) BOOL shouldUpdateCache;

@end
