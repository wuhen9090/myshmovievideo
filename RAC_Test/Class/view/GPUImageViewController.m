//
//  GPUImageViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/30.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "GPUImageViewController.h"
#import "GPUimageViewModel.h"
@interface GPUImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *selectImageButton;
@property (nonatomic, strong) UIButton *dealImageButton;
@property (nonatomic, strong) UIButton *dealCaptureButton;
@property (nonatomic, strong) UIButton *dealCaptureFilterButton;
@property (nonatomic, strong) GPUImageVideoCamera *cammera;
@property (nonatomic, strong) GPUImageFilter *fileter;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GPUImageView *cameraImageView;
@property (nonatomic, assign) BOOL isCaoeraDeal;
@property (nonatomic, strong) UIAlertController *selcectVC;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation GPUImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bindViewModel {
    [super bindViewModel];
    [[self.selectImageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self presentViewController:self.selcectVC animated:YES completion:^{
            
        }];
    }];
    [[ self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        UIImagePickerController *vc = tuple.first;
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIImage *image = [tuple.second objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
    }];
    [[self.dealImageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [((GPUimageViewModel*)self.viewModel).dealImageCommand execute:self.imageView.image];
    }];

//    [((GPUimageViewModel*)self.viewModel).dealImageCommand.executionSignals subscribeNext:^(RACSignal *output) {
//        [output subscribeNext:^(id x) {
//            [self.imageView setImage:x];
//        }];
//        
//    }];
    RAC(self.imageView,image) = ((GPUimageViewModel*)self.viewModel).dealImageCommand.executionSignals.switchToLatest;
    
    [[self.dealCaptureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.imageView.hidden = YES;
        [self.cammera startCameraCapture];
 
    }];
    [[self.dealCaptureFilterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RACSignal *output) {
        self.imageView.hidden = YES;
        RACTuple *data = [RACTuple tupleWithObjectsFromArray:@[self.cammera,self.cameraImageView,self.fileter]];
        if (!self.isCaoeraDeal) {
            [((GPUimageViewModel*)self.viewModel).dealCameraCommand execute:data];
            self.isCaoeraDeal = YES;
        }else
        {
            self.fileter = [[GPUImageFilter alloc] init];
            [self.cammera addTarget:self.fileter];
            [self.fileter addTarget:self.cameraImageView];
            self.isCaoeraDeal = NO;
        }
 //       [self.fileter removeAllTargets];
   //     [self.cammera removeAllTargets];
     //   self.fileter = [[GPUImageColorInvertFilter alloc] init];
       // [self.fileter addTarget:self.cameraImageView];
        //[self.cammera addTarget:self.fileter];

    }];
 //   RAC(self.cameraImageView,image) = ((GPUimageViewModel*)self.viewModel).dealCameraCommand.executionSignals.switchToLatest;


//    [[self.dealCaptureButton rac_signalForControlEvents:UIControlEventTouchDownRepeat] subscribeNext:^(id x) {
        
//        [self.cammera startCameraCapture];
        
//    }];


//    [self.selectImageButton.rac_command.executionSignals subscribeNext:^(RACSignal* alertVCSignal) {
//        [alertVCSignal subscribeNext:^(id x) {
//            [self presentViewController:x animated:YES completion:^{
//            
//                }];
//
//        }];
//    }];
}
- (void)initUI {
        [self.view addSubview:self.imageView];
        [self.view addSubview:self.selectImageButton];
        [self.view addSubview:self.dealImageButton];
    [self.view addSubview:self.dealCaptureButton];
    [self.view addSubview:self.cameraImageView];
    [self.view addSubview:self.dealCaptureFilterButton];
//    [self addChildViewController:self.imagePickerController];
//        self.refreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.testTableView
//                                                                      target:self
//                                                               refreshAction:@selector(refreshTriggered:)
//                                                                       plist:@"headViewForTableView"
//                                                                       color:[UIColor redColor]
//                                                                   lineWidth:2
//                                                                  dropHeight:80
//                                                                       scale:1
//                                                        horizontalRandomness:300
//                                                     reverseLoadingAnimation:NO
//                                                     internalAnimationFactor:1];
//    
//        self.refreshControl = [CBStoreHouseRefreshControl attachToScrollView:self.testTableView target:self refreshAction:@selector(refreshTriggered:) plist:@"AKTA" color:[UIColor blueColor] lineWidth:2 dropHeight:80 scale:0.7 horizontalRandomness:300 reverseLoadingAnimation:NO internalAnimationFactor:0.7];
        [self updateViewConstraintsForView ];
}
- (void)updateViewConstraintsForView {
    @weakify(self);
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        }];
        [self.cameraImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.view.mas_top).offset(64);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view.mas_bottom).offset(-100);
        }];

        [self.selectImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
            make.left.equalTo(self.view.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
        [self.dealImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
            make.left.equalTo(self.selectImageButton.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(80, 50));
        }];
    [self.dealCaptureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.left.equalTo(self.dealImageButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 50));

    }];
    [self.dealCaptureFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.left.equalTo(self.dealCaptureButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(80, 50));
    }];

}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"56logo"]];
    }
    return _imageView;
}
- (UIButton *)selectImageButton {
    if (!_selectImageButton) {
        _selectImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectImageButton setTitle:@"选取图像" forState:UIControlStateNormal];
        [_selectImageButton setTintColor:[UIColor redColor]];
        [_selectImageButton setBackgroundColor:[UIColor blueColor]];
    }
    return _selectImageButton;
}
- (UIButton *)dealImageButton{
    if (!_dealImageButton) {
        _dealImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealImageButton setTitle:@"处理图像" forState:UIControlStateNormal];
        [_dealImageButton setTintColor:[UIColor redColor]];
        [_dealImageButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealImageButton;
}
- (UIButton *)dealCaptureButton{
    if (!_dealCaptureButton) {
        _dealCaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealCaptureButton setTitle:@"摄像头" forState:UIControlStateNormal];
        [_dealCaptureButton setTintColor:[UIColor redColor]];
        [_dealCaptureButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealCaptureButton;
}
- (UIButton *)dealCaptureFilterButton{
    if (!_dealCaptureFilterButton) {
        _dealCaptureFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealCaptureFilterButton setTitle:@"实时处理" forState:UIControlStateNormal];
        [_dealCaptureFilterButton setTintColor:[UIColor redColor]];
        [_dealCaptureFilterButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealCaptureFilterButton;
}

- (GPUImageVideoCamera *)cammera {
    if (!_cammera) {
        self.cammera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        self.cammera.outputImageOrientation = UIDeviceOrientationPortrait;
        self.cammera.audioEncodingTarget = nil;
        self.cammera.horizontallyMirrorFrontFacingCamera = NO;
        self.cammera.horizontallyMirrorRearFacingCamera = NO;
        self.fileter = [[GPUImageFilter alloc] init];
        [self.cammera addTarget:self.fileter];
        [self.fileter addTarget:self.cameraImageView];

    }
    return _cammera;
}
- (GPUImageView *)cameraImageView{
    if (!_cameraImageView) {
        _cameraImageView = [[GPUImageView alloc ] init];
    }
    return _cameraImageView;
}
- (UIAlertController *)selcectVC{
    _selcectVC = [UIAlertController alertControllerWithTitle:@"选取图像" message:@"你喜欢的图像" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
         UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;        [self presentViewController:imagePickerController animated:YES completion:^{
            
        }];

    }];
    [_selcectVC addAction:action1];
    [_selcectVC addAction:action2];

    return _selcectVC;
}
@end
