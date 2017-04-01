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
        
                GPUImageHarrisCornerDetectionFilter *disFilter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
        [disFilter setThreshold:0.9];
        //使用褐色滤镜
       // [[GPUImageSepiaFilter alloc] init]
        //使用黑白素描滤镜

        //[[GPUImageSketchFilter alloc] init];
        
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
    
    self.dealCameraCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        
        GPUImageVideoCamera *camera = (GPUImageVideoCamera *)tuple.first;
        GPUImageView *imageView = (GPUImageView *)tuple.second;
        GPUImageFilter *filer = (GPUImageFilter *)tuple.third;
        [filer removeAllTargets];
        [camera removeAllTargets];
        
        //边缘检测
        filer = [[GPUImagePrewittEdgeDetectionFilter alloc] init];

        //朦胧假案
 //       filer = [[GPUImageHazeFilter alloc] init];

        //自适应阈值
  //      filer = [[GPUImageAdaptiveThresholdFilter alloc] init];
        
        //3*3卷积，加亮边缘
//        filer = [[GPUImage3x3ConvolutionFilter alloc] init];

        //色彩丢失 模糊
  //      filer = [[GPUImageColorPackingFilter alloc] init];

        //像素画
  //      filer = [[GPUImagePixellateFilter alloc] init];
        //动作检测
    //    filer = [[GPUImageMotionDetector alloc] init];

        //双边模糊 美白平滑
 //       filer = [[GPUImageBilateralFilter alloc] init];

        //CGA色彩过滤
//        filer = [[GPUImageCGAColorspaceFilter alloc] init];

        //浮雕效果
 //       filer = [[GPUImageEmbossFilter alloc] init];
    
        //卡通
//        filer = [[GPUImageColorInvertFilter alloc] init];

        //反色
 //       filer = [[GPUImageColorInvertFilter alloc] init];
   
        //凸起失真
  //      filer = [[GPUImageBulgeDistortionFilter alloc] init];
        [filer addTarget:imageView];
        [camera addTarget:filer];
        return [RACSignal return:camera];
    }];
}

@end
