//
//  ViewController.m
//  goldfish
//
//  Created by Jesse Helton on 9/29/17.
//  Copyright © 2017 Jesse Helton. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()

@property (nonatomic, strong) IBOutlet GPUImageView *cameraView;

@property (nonatomic, strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong) GPUImageFilter *customFilter;

@end

@implementation ViewController

//NOTE: No need to call this function.  It is here to make sure these classes aren't stripped by the linker.
- (void)keepAtLinkTime {
    [GPUImageView class];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set up camera
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    
    //Create image filter
    _customFilter = [[GPUImageGrayscaleFilter alloc] init];
    
    //Hook up outputs to targets - camera->filter->view
    [_videoCamera addTarget:_customFilter];
    [_customFilter addTarget:self.cameraView];
    
    //Start the camera
    [_videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
