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

@property (nonatomic, strong) NSMutableArray<GPUImageFilter *> *filters;
@property (nonatomic) int currentFilter;

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
    
    //Create image filters
    _filters = [NSMutableArray array];
    GPUImageFilter *newFilter = [[GPUImageGrayscaleFilter alloc] init];
    [_filters addObject:newFilter];
    newFilter = [[GPUImageToonFilter alloc] init];
    [_filters addObject:newFilter];
    newFilter = [[GPUImageHazeFilter alloc] init];
    [_filters addObject:newFilter];
    newFilter = [[GPUImageSepiaFilter alloc] init];
    [_filters addObject:newFilter];
    newFilter = [[GPUImageEmbossFilter alloc] init];
    [_filters addObject:newFilter];

    [self setFilter:0];
    
    //Start the camera
    [_videoCamera startCameraCapture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setFilter:(int)filterIndex {
    //Unhook previous filter
    if (_currentFilter >= 0 && [_filters objectAtIndex:_currentFilter]) {
        GPUImageFilter *filter = [_filters objectAtIndex:_currentFilter];
        [_videoCamera removeAllTargets];
        [filter removeAllTargets];
    }
    
    //Hook up new filter
    _currentFilter = filterIndex;
    GPUImageFilter *filter = [_filters objectAtIndex:_currentFilter];
    [_videoCamera addTarget:filter];
    [filter addTarget:self.cameraView];
}

- (IBAction)eventNextFilter:(UIButton *)sender {
    _currentFilter++;
    if (_currentFilter >= _filters.count) {
        _currentFilter = 0;
    }
    
    [self setFilter:_currentFilter];
}

@end
