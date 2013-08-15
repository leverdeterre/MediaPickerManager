//
//  JMOViewController.m
//  GenericPickerManager
//
//  Created by Jerome Morissard on 8/15/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "JMOViewController.h"
#import "MediaPickerManager.h"

@interface JMOViewController () <JMMediaPickerManagerDelegate>
@end

@implementation JMOViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)photoSelected:(id)sender {
    [MediaPickerManager sharedInstance].type = JMMediaTypePhotos;
    [MediaPickerManager sharedInstance].delegate = self;
    [[MediaPickerManager sharedInstance] photoSelected:sender];
}


- (IBAction)videoSelected:(id)sender {
    [MediaPickerManager sharedInstance].type = JMMediaTypeVideos;
    [MediaPickerManager sharedInstance].delegate = self;
    [[MediaPickerManager sharedInstance] videoSelected:sender];
}

#pragma marJMMMediaPickerManagerDelegate

- (void)bkImagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s",__FUNCTION__);
    
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ( [mediaType isEqualToString:@"public.movie" ])
    {
        NSLog(@"Picked a movie at URL %@",  [info objectForKey:UIImagePickerControllerMediaURL]);
        NSURL *url =  [info objectForKey:UIImagePickerControllerMediaURL];
        
    }
    else {
        UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    }
}

@end
