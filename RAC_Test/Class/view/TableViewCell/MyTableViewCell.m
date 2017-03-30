//
//  MyTableViewCell.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/28.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bindViewModel:(NSString *)viewModel {
//    self.viewModel = viewModel;
//    
//    [self.avatarButton sd_setImageWithURL:viewModel.event.actorAvatarURL forState:UIControlStateNormal];
//    
//    self.detailLabel.height = viewModel.textLayout.textBoundingSize.height;
//    self.detailLabel.textLayout = viewModel.textLayout;
    self.textLabel.text = viewModel;
}

@end
