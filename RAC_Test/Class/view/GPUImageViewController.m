//
//  GPUImageViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 17/3/30.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "GPUImageViewController.h"
#import "GPUimageViewModel.h"
@interface GPUImageViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIButton *selectImageButton;
@property (nonatomic, strong) UIButton *dealImageButton;
@property (nonatomic, strong) UIButton *dealCaptureButton;
@property (nonatomic, strong) UIButton *dealCaptureFilterButton;
@property (nonatomic, strong) UIButton *dealCaptureGroupFilterButton;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) GPUImageVideoCamera *cammera;
@property (nonatomic, strong) GPUImageFilter *fileter;
@property (nonatomic, strong) GPUImageFilterGroup *fileterGroup;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GPUImageView *cameraImageView;
@property (nonatomic, assign) BOOL isCaoeraDeal;
@property (nonatomic, strong) UIAlertController *selcectVC;
@property (nonatomic, strong) UIPickerView *selcectPickerView;
@property (nonatomic, strong) NSArray *filterArray;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) NSInteger slelectFilterIndex;
@property (nonatomic, assign) NSInteger imageType;
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
    //处理图像
    [[ self rac_signalForSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:) fromProtocol:@protocol(UIImagePickerControllerDelegate)] subscribeNext:^(RACTuple *tuple) {
        UIImagePickerController *vc = tuple.first;
        [vc dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        UIImage *image = [tuple.second objectForKey:UIImagePickerControllerOriginalImage];
        self.imageView.image = image;
        self.imageType = 1;
        [self.cammera stopCameraCapture];
        self.cameraImageView.hidden = YES;
        self.imageView.hidden = NO;
    }];
    [[self.dealImageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        //拉起选择器
        self.selcectPickerView.hidden = NO;
        self.dealCaptureFilterButton.hidden = NO;
    }];

//    [((GPUimageViewModel*)self.viewModel).dealImageCommand.executionSignals subscribeNext:^(RACSignal *output) {
//        [output subscribeNext:^(id x) {
//            [self.imageView setImage:x];
//        }];
//        
//    }];
    //显示处理过得图像
    RAC(self.imageView,image) = ((GPUimageViewModel*)self.viewModel).dealImageCommand.executionSignals.switchToLatest;
    
    [[self.dealCaptureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.imageView.hidden = YES;
        [self.cammera startCameraCapture];
        self.imageType = 2;
        self.imageView.hidden = YES;
        self.cameraImageView.hidden = NO;
 
    }];
    //多重滤镜
    [[self.dealCaptureGroupFilterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        self.selcectPickerView.hidden = YES;
        self.dealCaptureFilterButton.hidden = YES;
        if (self.imageType == 1) {
            self.imageView.hidden = NO;
            [self.cammera stopCameraCapture];
            RACTuple *data = [RACTuple tupleWithObjectsFromArray:@[self.imageView.image,[[NSNumber alloc] initWithInteger:self.imageType]]];
            
            [((GPUimageViewModel*)self.viewModel).dealCameraGroupfiltersCommand execute:data];
        }
        else if (self.imageType == 2)
        {
            [_cammera addTarget:self.fileterGroup];
            [self.fileterGroup addTarget:self.cameraImageView];
            self.imageView.hidden = YES;
            RACTuple *data = [RACTuple tupleWithObjectsFromArray:@[self.cammera,self.cameraImageView,self.fileterGroup,[[NSNumber alloc] initWithInteger:self.imageType]]];
            //给model传递参数数据并添加过滤器
            [((GPUimageViewModel*)self.viewModel).dealCameraGroupfiltersCommand execute:data];
        }

        
    }];
    //存储处理结果
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
    }];
    //处理摄像
    [[self.dealCaptureFilterButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(RACSignal *output) {
        self.selcectPickerView.hidden = YES;
        self.dealCaptureFilterButton.hidden = YES;
        if (self.imageType == 1) {
            self.imageView.hidden = NO;
            [self.cammera stopCameraCapture];
            RACTuple *data = [RACTuple tupleWithObjectsFromArray:@[self.imageView.image,[[NSNumber alloc] initWithInteger:self.slelectFilterIndex]]];

            [((GPUimageViewModel*)self.viewModel).dealImageCommand execute:data];
        }
        else if (self.imageType == 2)
        {
            self.imageView.hidden = YES;
            RACTuple *data = [RACTuple tupleWithObjectsFromArray:@[self.cammera,self.cameraImageView,self.fileter,[[NSNumber alloc] initWithInteger:self.slelectFilterIndex]]];
            //给model传递参数数据并添加过滤器
            [((GPUimageViewModel*)self.viewModel).dealCameraCommand execute:data];
        }
       //        if (!self.isCaoeraDeal) {
//            [((GPUimageViewModel*)self.viewModel).dealCameraCommand execute:data];
//            self.isCaoeraDeal = YES;
//        }else
//        {
//            self.fileter = [[GPUImageFilter alloc] init];
//            [self.cammera addTarget:self.fileter];
//            [self.fileter addTarget:self.cameraImageView];
//            self.isCaoeraDeal = NO;
//        }
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
//    [RACObserve(self.cammera,cameraPosition) subscribeNext:^(id x) {
//        if (x!=AVCaptureDevicePositionUnspecified) {
//            self.rightButton.hidden = NO;
//        }else{
//            self.rightButton.hidden = YES;
//        }
//    }];
}
- (void)initUI {
    [self.view addSubview:self.imageView];
  
    [self.view addSubview:self.cameraImageView];
    [self.view addSubview:self.dealCaptureFilterButton];
    [self.view addSubview:self.selcectPickerView];
    [self.view addSubview:self.selectImageButton];
    [self.view addSubview:self.dealImageButton];
    [self.view addSubview:self.dealCaptureButton];
    [self.view addSubview:self.dealCaptureGroupFilterButton];
    [self.view addSubview:self.saveButton];
    [self addRightButton];
    self.selcectPickerView.hidden = YES;
    self.dealCaptureFilterButton.hidden = YES;
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
- (void)addRightButton{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_rightButton setTitle:@"翻转摄像头" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self.cammera rotateCamera];
    }];
    self.navigationItem.rightBarButtonItem = rightBar;

}
- (void)updateViewConstraintsForView {
    CGFloat width = (self.view.width-40) /5;
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
            make.left.equalTo(self.view.mas_left);
            make.size.mas_equalTo(CGSizeMake(width, 50));
        }];
        [self.dealImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.top.equalTo(self.imageView.mas_bottom).offset(20);
            make.left.equalTo(self.selectImageButton.mas_right).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, 50));
        }];
    [self.dealCaptureButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.left.equalTo(self.dealImageButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(width, 50));

    }];
    [self.dealCaptureGroupFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.left.equalTo(self.dealCaptureButton.mas_right).offset(10);
        make.size.mas_equalTo(CGSizeMake(width, 50));
        
    }];
    [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(20);
        make.right.equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(width, 50));
        
    }];

    [self.selcectPickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(self.view.height/3);
    }];
    [self.dealCaptureFilterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.selcectPickerView.mas_top);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
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
        _selectImageButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_selectImageButton setTintColor:[UIColor redColor]];
        [_selectImageButton setBackgroundColor:[UIColor blueColor]];
    }
    return _selectImageButton;
}
- (UIButton *)dealImageButton{
    if (!_dealImageButton) {
        _dealImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealImageButton setTitle:@"选取过滤器" forState:UIControlStateNormal];
        _dealImageButton.titleLabel.font = [UIFont systemFontOfSize:13];

        [_dealImageButton setTintColor:[UIColor redColor]];
        [_dealImageButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealImageButton;
}
- (UIButton *)dealCaptureButton{
    if (!_dealCaptureButton) {
        _dealCaptureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealCaptureButton setTitle:@"摄像头" forState:UIControlStateNormal];
        _dealCaptureButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_dealCaptureButton setTintColor:[UIColor redColor]];
        [_dealCaptureButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealCaptureButton;
}
- (UIButton *)dealCaptureFilterButton{
    if (!_dealCaptureFilterButton) {
        _dealCaptureFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealCaptureFilterButton setTitle:@"确定" forState:UIControlStateNormal];
        [_dealCaptureFilterButton setTintColor:[UIColor redColor]];
        [_dealCaptureFilterButton setBackgroundColor:[UIColor blueColor]];
    }
    return _dealCaptureFilterButton;
}
- (UIButton *)dealCaptureGroupFilterButton{
    if (!_dealCaptureGroupFilterButton) {
        _dealCaptureGroupFilterButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dealCaptureGroupFilterButton setTitle:@"多重滤镜" forState:UIControlStateNormal];
        _dealCaptureGroupFilterButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_dealCaptureGroupFilterButton setTintColor:[UIColor redColor]];
        [_dealCaptureGroupFilterButton setBackgroundColor:[UIColor blueColor]];

    }
    return _dealCaptureGroupFilterButton;
}
- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTintColor:[UIColor redColor]];
        [_saveButton setBackgroundColor:[UIColor blueColor]];
        
    }
    return _saveButton;
}
- (GPUImageVideoCamera *)cammera {
    if (!_cammera) {
        self.cammera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        self.cammera.outputImageOrientation = UIDeviceOrientationPortrait;
        self.cammera.audioEncodingTarget = nil;
        self.cammera.horizontallyMirrorFrontFacingCamera = NO;
        self.cammera.horizontallyMirrorRearFacingCamera = NO;
        self.fileter = [[GPUImageFilter alloc] init];
        self.fileterGroup = [[GPUImageFilterGroup alloc] init];
        [self.cammera addTarget:self.fileter];
        [self.fileter addTarget:self.cameraImageView];

    }
    return _cammera;
}
- (UIPickerView *)selcectPickerView{
    if (!_selcectPickerView) {
        _selcectPickerView= [[UIPickerView alloc] init];
        _selcectPickerView.delegate = self;
        _selcectPickerView.dataSource = self;
        _selcectPickerView.showsSelectionIndicator =YES;
        _selcectPickerView.backgroundColor = [UIColor whiteColor];
    }
    return _selcectPickerView;
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
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_selcectVC dismissViewControllerAnimated:YES completion:^{
    
        }];
    }];

    [_selcectVC addAction:action1];
    [_selcectVC addAction:action2];
    [_selcectVC addAction:action3];

    return _selcectVC;
}
#pragma pickview datasoure
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return ((GPUimageViewModel *)self.viewModel).filterArray.count;
}


#pragma pickview datasoure
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30;
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return self.view.width;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.title = ((GPUimageViewModel *)self.viewModel).filterArray[row];
    self.slelectFilterIndex = row;
    NSLog(@"xunaleni");
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return ((GPUimageViewModel *)self.viewModel).filterArray[row];
}
@end
