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
    self.dealImageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *inputData) {
        
//                GPUImageHarrisCornerDetectionFilter *disFilter = [[GPUImageHarrisCornerDetectionFilter alloc] init];
//        [disFilter setThreshold:0.9];
        UIImage *imageView = (UIImage *)inputData.first;
        NSInteger filterIndex = [inputData.last integerValue];

        GPUImageFilter *filer = [self getFileterForImageFromIndex:filterIndex];
        //设置要渲染的区域
        [filer forceProcessingAtSize:imageView.size];
        [filer useNextFrameForImageCapture];
        
        //获取数据源
        GPUImagePicture *stillImageSource = [[GPUImagePicture alloc]initWithImage:imageView];
        
        //添加上滤镜
        [stillImageSource addTarget:filer];
        //开始渲染
        [stillImageSource processImage];
        //获取渲染后的图片
        UIImage *newImage = [filer imageFromCurrentFramebuffer];
        
        return [RACSignal return:newImage];
    }];
    
    self.dealCameraCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *tuple) {
        NSInteger filterIndex = [tuple.last integerValue];
        if (tuple.count > 2) {
            GPUImageVideoCamera *camera = (GPUImageVideoCamera *)tuple.first;
            GPUImageView *imageView = (GPUImageView *)tuple.second;
            GPUImageFilter *filer = (GPUImageFilter *)tuple.third;
            [filer removeAllTargets];
            [camera removeAllTargets];
            filer =[self getFileterForImageFromIndex:filterIndex];
            [filer addTarget:imageView];
            [camera addTarget:filer];
            return [RACSignal return:camera];
        }
        return [RACSignal empty];
    }];
    
    self.filterArray = @[@"本色显示",
                         @"边缘检测",
                         @"朦胧加暗",
                         @"3*3卷积，加亮边缘",
                         @"色彩丢失 模糊",
                         @"像素画",
                         @"动作检测",
                         @"双边模糊 美白平滑",
                         @"CGA色彩过滤",
                         @"浮雕效果",
                         @"卡通",
                         @"反色",
                         @"凸起失真",
                         @"自适应阈值",
                         @"褐色"];
}
- (GPUImageFilter *)getFileterForImageFromIndex:(NSInteger) index
{
    GPUImageFilter *filter = nil;
    switch (index) {
        case 0:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 1:
            filter = [[GPUImagePrewittEdgeDetectionFilter alloc] init];
            break;
        case 2:
            filter = [[GPUImageHazeFilter alloc] init];
            break;
        case 3:
            filter = [[GPUImage3x3ConvolutionFilter alloc] init];
            break;
        case 4:
            filter = [[GPUImageColorPackingFilter alloc] init];
            break;
        case 5:
            filter = [[GPUImagePixellateFilter alloc] init];
            break;
        case 6:
            filter = [[GPUImageMotionDetector alloc] init];
            break;
        case 7:
            filter = [[GPUImageBilateralFilter alloc] init];
            break;
        case 8:
            filter = [[GPUImageCGAColorspaceFilter alloc] init];
            break;
        case 9:
            filter = [[GPUImageEmbossFilter alloc] init];
            break;
        case 10:
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 11:
            filter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 12:
            filter = [[GPUImageBulgeDistortionFilter alloc] init];
            break;
        case 13:
            filter = [[GPUImageAdaptiveThresholdFilter alloc] init];
            break;
        case 14:
            filter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 15:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 16:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 17:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 18:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 19:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 20:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 21:
            filter = [[GPUImageFilter alloc] init];
            break;
        case 22:
            filter = [[GPUImageFilter alloc] init];
            break;

            
        default:
            break;
    }
    return filter;
}
@end
