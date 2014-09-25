#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

@interface PhotoViewController ()

@end

@implementation PhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView 
{
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	    
    // Yes, I know I'm a caveman for doing all this by hand
	GPUImageView *primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
//    filterSettingsSlider = [[UISlider alloc] initWithFrame:CGRectMake(25.0, mainScreenFrame.size.height - 50.0, mainScreenFrame.size.width - 50.0, 40.0)];
//    [filterSettingsSlider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
//	filterSettingsSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
//    filterSettingsSlider.minimumValue = 0.0;
//    filterSettingsSlider.maximumValue = 3.0;
//    filterSettingsSlider.value = 1.0;
//    
//    [primaryView addSubview:filterSettingsSlider];
    
    photoCaptureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [photoCaptureButton setBackgroundImage:[UIImage imageNamed:@"cameraButton"] forState:UIControlStateNormal];
    photoCaptureButton.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    photoCaptureButton.tintColor = [UIColor whiteColor];
    CGFloat btnRadius = 70;
    photoCaptureButton.frame = CGRectMake(0, 0, btnRadius, btnRadius);
    photoCaptureButton.center = CGPointMake(mainScreenFrame.size.width/2, mainScreenFrame.size.height -40);
    photoCaptureButton.layer.cornerRadius = btnRadius/2;
    photoCaptureButton.layer.borderWidth = 5;
    photoCaptureButton.layer.borderColor = [[UIColor colorWithWhite:0.5 alpha:0.5] CGColor];
    //[photoCaptureButton setTitle:@"Capture Photo" forState:UIControlStateNormal];
	photoCaptureButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [photoCaptureButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [photoCaptureButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    
    rotateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rotateButton setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    rotateButton.frame = CGRectMake(15, 15, 30, 30);
    [rotateButton addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
    rotateButton.tintColor = [UIColor whiteColor];
//    
//    albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [albumButton setTitle:@"Album" forState:UIControlStateNormal];
//    [albumButton addTarget:self action:@selector(presentAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    albumButton.frame = CGRectMake(15, primaryView.frame.size.height - 35, 30, 50);
    
    [primaryView addSubview:photoCaptureButton];
    [primaryView addSubview:rotateButton];
//    [primaryView addSubview:albumButton];
    
	self.view = primaryView;	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    stillCamera = [[GPUImageStillCamera alloc] init];
//    stillCamera = [[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    stillCamera.jpegCompressionQuality = 0.9;
    stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    filter = [[GPUImageGammaFilter alloc] init];
    filter = [[GPUImageSketchFilter alloc] init];
//    filter = [[GPUImageUnsharpMaskFilter alloc] init];
//    [(GPUImageSketchFilter *)filter setTexelHeight:(1.0 / 1024.0)];
//    [(GPUImageSketchFilter *)filter setTexelWidth:(1.0 / 768.0)];
//    filter = [[GPUImageSmoothToonFilter alloc] init];
//    filter = [[GPUImageSepiaFilter alloc] init];
//    filter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake(0.5, 0.5, 0.5, 0.5)];
//    secondFilter = [[GPUImageSepiaFilter alloc] init];
//    terminalFilter = [[GPUImageSepiaFilter alloc] init];
//    [filter addTarget:secondFilter];
//    [secondFilter addTarget:terminalFilter];
    
//	[filter prepareForImageCapture];
//	[terminalFilter prepareForImageCapture];
    
    [stillCamera addTarget:filter];
    
    GPUImageView *filterView = (GPUImageView *)self.view;
//    [filter addTarget:filterView];
    [filter addTarget:filterView];
//    [terminalFilter addTarget:filterView];
    
//    [stillCamera.inputCamera lockForConfiguration:nil];
//    [stillCamera.inputCamera setFlashMode:AVCaptureFlashModeOn];
//    [stillCamera.inputCamera unlockForConfiguration];
    
    [stillCamera startCameraCapture];
    
//    UIImage *inputImage = [UIImage imageNamed:@"Lambeau.jpg"];
//    memoryPressurePicture1 = [[GPUImagePicture alloc] initWithImage:inputImage];
//
//    memoryPressurePicture2 = [[GPUImagePicture alloc] initWithImage:inputImage];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (IBAction)updateSliderValue:(id)sender
{
//    [(GPUImagePixellateFilter *)filter setFractionalWidthOfAPixel:[(UISlider *)sender value]];
//    [(GPUImageGammaFilter *)filter setGamma:[(UISlider *)sender value]];
}

- (IBAction)rotate:(id)sender{
    [stillCamera rotateCamera];
}

- (IBAction)presentAlbum:(id)sender{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (IBAction)takePhoto:(id)sender;
{
    [photoCaptureButton setEnabled:NO];
    
    [stillCamera capturePhotoAsJPEGProcessedUpToFilter:filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){

        // Save to assets library
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        NSMutableDictionary *meta = [NSMutableDictionary dictionaryWithDictionary:stillCamera.currentCaptureMetadata];
        [meta setObject:@([UIDevice currentDevice].orientation) forKey:@"Orientation"];
        
        //present
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = [UIImage imageWithData:processedJPEG];
        imageView.alpha = 0;
        [self.view addSubview:imageView];
        [UIView animateWithDuration:0.5 animations:^{
            imageView.alpha = 1;
        }completion:^(BOOL finished) {
            //stop camera
        }];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView transitionWithView:imageView duration:0.5 options:UIViewAnimationOptionTransitionCurlUp animations:^{
                imageView.alpha = 0;
            } completion:^(BOOL finished) {
                [imageView removeFromSuperview];
            }];
        });
        
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:meta completionBlock:^(NSURL *assetURL, NSError *error2)
         {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }
			 
             runOnMainQueueWithoutDeadlocking(^{
                 [photoCaptureButton setEnabled:YES];
             });
        }];
    }];
}

@end
