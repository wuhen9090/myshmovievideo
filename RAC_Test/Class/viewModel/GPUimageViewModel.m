//
//  GPUimageViewModel.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/30.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "GPUimageViewModel.h"

@implementation GPUimageViewModel
- (instancetype)initWithServices:(id<MRCViewModelServices>)services params:(NSDictionary *)params {
    self = [super initWithServices:services params:params];
    if (self) {
    }
    return self;
}
- (void)initialize{
    self.importImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *alertSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"选取图像" message:@"你喜欢的图像" preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                
            }];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertView addAction:action1];
            [alertView addAction:action2];
            [subscriber sendNext:alertView];
            [subscriber sendCompleted];

            return nil;
        }];
        return alertSignal;
    }];
    self.dealImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(UIImage *inputImage) {
        //使用黑白素描滤镜
        GPUImageSketchFilter *disFilter = [[GPUImageSketchFilter alloc] init];
        
        //设置要渲染的区域
        [disFilter forceProcessingAtSize:inputImage.size];
        [disFilter useNextFrameForImageCapture];
        
        //获取数据源
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:inputImage];
        
        //添加上滤镜
        [stillImageSource addTarget:disFilter];
        //开始渲染
        [stillImageSource processImage];
        //获取渲染后的图片
        UIImage *newImage = [disFilter imageFromCurrentFramebuffer];

        return [RACSignal return:newImage];
    }];
}
@end
