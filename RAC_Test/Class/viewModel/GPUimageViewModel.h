//
//  GPUimageViewModel.h
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/30.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "MRCViewModel.h"

@interface GPUimageViewModel : MRCViewModel
@property (nonatomic, strong) RACCommand *importImageCommand;
@property (nonatomic, strong) RACCommand *dealImageCommand ;
@property (nonatomic, strong) RACCommand *dealCameraCommand ;
@property (nonatomic, strong) RACCommand *dealCameraGroupfiltersCommand ;
@property (nonatomic, strong) RACCommand *dealSaveCommand ;


@property (nonatomic, strong) NSArray    *filterArray ;
@end
