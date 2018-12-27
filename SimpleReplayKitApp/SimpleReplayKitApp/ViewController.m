//
//  ViewController.m
//  SimpleReplayKitApp
//
//  Created by HanGyo Jeong on 26/12/2018.
//  Copyright © 2018 HanGyoJeong. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <RPPreviewViewControllerDelegate, RPScreenRecorderDelegate>

@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)startRecording:(UIButton*)sender {
    if([RPScreenRecorder.sharedRecorder isAvailable]){
        [RPScreenRecorder.sharedRecorder startRecordingWithHandler:^(NSError *error){
            if(error == nil){   //Recording has started
                NSLog(@"Recording has no problem");
            
                //[sender removeTarget:self action:@selector(stopRecording:) forControlEvents:UIControlEventTouchUpInside];
                dispatch_async(dispatch_get_main_queue(), ^(){
                    self->_status.text = @"Recording now";
                });
                
            }else{
                NSLog(@"There is a problem Recording");
            }
        }];
    }
}

- (IBAction)stopRecording:(UIButton*)sender {
    [RPScreenRecorder.sharedRecorder stopRecordingWithHandler:^(RPPreviewViewController *previewController, NSError *error){
        if(!error){
            if(previewController != nil){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Recording"
                                                                             message:@"Do you want to discard or view your gameplay recording?"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
                 UIAlertAction *discardAction = [UIAlertAction actionWithTitle:@"Discard" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [RPScreenRecorder.sharedRecorder discardRecordingWithHandler:^(){
                        
                    }];
                }];
                UIAlertAction *viewAction = [UIAlertAction actionWithTitle:@"View" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self presentViewController:previewController animated:YES completion:nil];
                }];
                
                [alertController addAction:discardAction];
                [alertController addAction:viewAction];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    self->_status.text = @"Recording Stop";
                });
                
                [self presentViewController:alertController animated:YES completion:nil];
            }else{
                NSLog(@"previewController is nil");
            }
        }else{
            NSLog(@"Problem during recording");
        }
        
    }];
}
@end
