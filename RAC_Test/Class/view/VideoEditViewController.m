//
//  VideoEditViewController.m
//  RAC_Test
//
//  Created by yuxiaoliang on 2017/4/19.
//  Copyright © 2017年 yuxiaoliang. All rights reserved.
//

#import "VideoEditViewController.h"
#import "ICGVideoTrimmerView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
@interface VideoEditViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIVideoEditorControllerDelegate,ICGVideoTrimmerDelegate>

@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;
@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) NSTimer *playbackTimeCheckerTimer;
@property (assign, nonatomic) CGFloat videoPlaybackPosition;


@property (strong, nonatomic) NSString *tempVideoPath;
@property (strong, nonatomic) AVAssetExportSession *exportSession;
@property (strong, nonatomic) AVAsset *asset;


@property (nonatomic, strong)  UIView *videoViewLayer;
@property (nonatomic, strong)  ICGVideoTrimmerView *trimmerView;
@property (nonatomic, strong)  UIView *trimmerViewD;
@property (nonatomic, strong)  UIButton *trimButton;

@property (assign, nonatomic) BOOL restartOnPlay;
@property (assign, nonatomic) CGFloat startTime;
@property (assign, nonatomic) CGFloat stopTime;


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
@property (nonatomic, strong) UIImage *orientImage;
@property (nonatomic, strong) GPUImageMovieWriter *moveWriter;

@end

@implementation VideoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.tempVideoPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"tmpMov.mov"];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)bindViewModel {
    [super bindViewModel];
}
- (void)initUI {
    [self addRightButton];
    [self addConstriansForView];
}
- (void)addRightButton{
    self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
    [_rightButton setTitle:@"选择视频" forState:UIControlStateNormal];
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:_rightButton];
    [[_rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        UIImagePickerController *myImagePickerController = [[UIImagePickerController alloc] init];
        myImagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        myImagePickerController.mediaTypes =[UIImagePickerController availableMediaTypesForSourceType:myImagePickerController.sourceType];
        myImagePickerController.delegate = self;
        myImagePickerController.editing = NO;
        [self presentViewController:myImagePickerController animated:YES completion:nil];

    }];
    self.navigationItem.rightBarButtonItem = rightBar;
}
#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if([mediaType isEqualToString:@"public.movie"]) {
            NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            
            if (self.isPlaying) {
                [self.player pause];
                [self.trimmerView removeFromSuperview];
                [self.playerLayer removeFromSuperlayer];
            }
            self.asset = [AVAsset assetWithURL:videoURL];
            
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:self.asset];
            
            self.player = [AVPlayer playerWithPlayerItem:item];
            self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
            self.playerLayer.frame = self.videoViewLayer.frame;
            self.playerLayer.contentsGravity = AVLayerVideoGravityResizeAspect;
            self.player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
            self.playerLayer.backgroundColor= (__bridge CGColorRef _Nullable)([UIColor clearColor]);
            [self.videoViewLayer.layer addSublayer:self.playerLayer];
//            self.playerLayer.frame = self.videoViewLayer.frame;
            self.videoViewLayer.backgroundColor = [UIColor clearColor];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnVideoLayer:)];
            [self.videoViewLayer addGestureRecognizer:tap];
            self.videoPlaybackPosition = 0;
            [self tapOnVideoLayer:tap];
            self.trimmerView = [[ICGVideoTrimmerView alloc] initWithFrame: self.trimmerViewD.frame asset:self.asset];
            [self.view addSubview:self.trimmerView];
            [self.trimmerView setThemeColor:[UIColor lightGrayColor]];
            [self.trimmerView setShowsRulerView:YES];
            [self.trimmerView setRulerLabelInterval:10];
            [self.trimmerView setTrackerColor:[UIColor cyanColor]];
            [self.trimmerView setDelegate:self];
//            self.stopTime = item.duration.value/item.duration.timescale;
            // important: reset subviews
            self.stopTime = self.asset.duration.value/self.asset.duration.timescale;

            [self.trimmerView resetSubviews];
            


//            UIVideoEditorController *editVC;
//            // 检查这个视频资源能不能被修改
//            if ([UIVideoEditorController canEditVideoAtPath:videoURL.path]) {
//                editVC = [[UIVideoEditorController alloc] init];
//                editVC.videoPath = videoURL.path;
//                editVC.delegate = self;
//            }
//            [self presentViewController:editVC animated:YES completion:nil];
        }
    }];
}
//编辑成功后的Video被保存在沙盒的临时目录中
- (void)videoEditorController:(UIVideoEditorController *)editor didSaveEditedVideoToPath:(NSString *)editedVideoPath {
    NSLog(@"+++++++++++++++%@",editedVideoPath);
}

// 编辑失败后调用的方法
- (void)videoEditorController:(UIVideoEditorController *)editor didFailWithError:(NSError *)error {
    NSLog(@"%@",error.description);
}

//编辑取消后调用的方法
- (void)videoEditorControllerDidCancel:(UIVideoEditorController *)editor {
    
}
#pragma mark - ICGVideoTrimmerDelegate

- (void)trimmerView:(ICGVideoTrimmerView *)trimmerView didChangeLeftPosition:(CGFloat)startTime rightPosition:(CGFloat)endTime
{
    _restartOnPlay = YES;
    [self.player pause];
    self.isPlaying = NO;
    [self stopPlaybackTimeChecker];
    
    [self.trimmerView hideTracker:true];
    
    if (startTime != self.startTime) {
        //then it moved the left position, we should rearrange the bar
        [self seekVideoToPos:startTime];
    }
    else{ // right has changed
        [self seekVideoToPos:endTime];
    }
    self.startTime = startTime;
    self.stopTime = endTime;
    
}
- (void)tapOnVideoLayer:(UITapGestureRecognizer *)tap
{
    if (self.isPlaying) {
        [self.player pause];
        [self stopPlaybackTimeChecker];
    }else {
        if (_restartOnPlay){
            [self seekVideoToPos: self.startTime];
            [self.trimmerView seekToTime:self.startTime];
            _restartOnPlay = NO;
        }
        [self.player play];
        [self startPlaybackTimeChecker];
    }
    self.isPlaying = !self.isPlaying;
    [self.trimmerView hideTracker:!self.isPlaying];
}
- (void)startPlaybackTimeChecker
{
    [self stopPlaybackTimeChecker];
    
    self.playbackTimeCheckerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(onPlaybackTimeCheckerTimer) userInfo:nil repeats:YES];
}

- (void)stopPlaybackTimeChecker
{
    if (self.playbackTimeCheckerTimer) {
        [self.playbackTimeCheckerTimer invalidate];
        self.playbackTimeCheckerTimer = nil;
    }
}
#pragma mark - PlaybackTimeCheckerTimer

- (void)onPlaybackTimeCheckerTimer
{
    CMTime curTime = [self.player currentTime];
    Float64 seconds = CMTimeGetSeconds(curTime);
    if (seconds < 0){
        seconds = 0; // this happens! dont know why.
    }
    self.videoPlaybackPosition = seconds;
    
    [self.trimmerView seekToTime:seconds];
    
    if (self.videoPlaybackPosition >= self.stopTime) {
        self.videoPlaybackPosition = self.startTime;
        [self seekVideoToPos: self.startTime];
        [self.trimmerView seekToTime:self.startTime];
    }
}
- (void)seekVideoToPos:(CGFloat)pos
{
    self.videoPlaybackPosition = pos;
    CMTime time = CMTimeMakeWithSeconds(self.videoPlaybackPosition, self.player.currentTime.timescale);
    //NSLog(@"seekVideoToPos time:%.2f", CMTimeGetSeconds(time));
    [self.player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}
- (UIView *)videoViewLayer{
    if (!_videoViewLayer) {
        _videoViewLayer = [[UIView alloc] init];
        _videoViewLayer.backgroundColor = [UIColor yellowColor];
    }
    return _videoViewLayer;
}
- (UIView *)trimmerViewD{
    if (!_trimmerViewD) {
        _trimmerViewD = [[UIView alloc]init];
        _trimmerViewD.backgroundColor = [UIColor blueColor];
    }
    return _trimmerViewD;
}
- (UIButton *)trimButton{
    if (!_trimButton) {
        _trimButton = [[UIButton alloc] init];
        [_trimButton setTitle:@"存储视频" forState:UIControlStateNormal];
        _trimButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_trimButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    return _trimButton;
}
- (void)addConstriansForView{

    [self.view addSubview:self.videoViewLayer];
    [self.view addSubview:self.trimmerViewD];
    [self.view addSubview:self.trimButton];
    @weakify(self);
    [self.videoViewLayer mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(40);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-200);
    }];
    [self.trimmerViewD mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.videoViewLayer.mas_bottom);
        make.height.mas_equalTo(150);
    }];
    [self.trimButton mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.top.equalTo(self.trimmerViewD.mas_bottom).offset(5);
        make.size.mas_equalTo(CGSizeMake(150, 40));
        make.left.equalTo(self.view.mas_left).offset(20);
    }];


}
@end
