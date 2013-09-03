//
//  MediaPickerManager.m
//
//  Created by Jerome Morissard on 8/15/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import "MediaPickerManager.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface MediaPickerManager () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIPopoverControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic) UIView *viewSelected;
@end

@implementation MediaPickerManager

+ (instancetype)sharedInstance {
    static MediaPickerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
    }
    return self;
}

- (IBAction)photoSelected:(id)sender
{
    self.viewSelected = (UIView *)sender;
    
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Prendre photo", @"De la bibliothèque", nil];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIViewController * root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [actionSheet showInView:root.view];
    }
    else {
        [actionSheet showFromRect:self.viewSelected.frame inView:self.viewSelected.superview animated:YES];
    }
}

- (IBAction)videoSelected:(id)sender
{
    UIActionSheet * actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:nil otherButtonTitles:@"Prendre une vidéo", @"De la bibliothèque", nil];
    self.viewSelected = (UIView *)sender;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIViewController * root = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [actionSheet showInView:root.view];
    }
    else {
        [actionSheet showFromRect:self.viewSelected.frame inView:self.viewSelected.superview animated:YES];
    }
}


#pragma mark UIActionSheetDelegate

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Prendre une vidéo"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Cet appareil ne peut pas prendre de vidéos" delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if ([buttonTitle isEqualToString:@"Prendre photo"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Cet appareil ne peut pas prendre de photos" delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
            [alertView show];
        }
    }
    else if ([buttonTitle isEqualToString:@"De la bibliothèque"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *arrayOfTypes = [NSMutableArray new];
            if (self.type & JMMediaTypeLibraryPhoto) {
                [arrayOfTypes addObject:@"public.image"];
            }
            else if (self.type & JMMediaTypeLibraryVideo) {
                [arrayOfTypes addObject:@"public.movie"];
            }
            self.imagePickerController.mediaTypes = arrayOfTypes;
        }
        else {
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Cet appareil n'a pas de galerie" delegate:self cancelButtonTitle:@"Fermer" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    [self presentImagePicker];
}

// Called when we cancel a view (eg. the user clicks the Home button). This is not called when the user clicks the cancel button.
// If not defined in the delegate, we simulate a click in the cancel button
- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{

}

#pragma mark -
-(void)presentImagePickerWithSourceType:(UIImagePickerControllerSourceType)sourceType andTypes:(NSArray *)arrayOfTypes
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        
        self.imagePickerController.sourceType = sourceType;
        if (arrayOfTypes) {
            self.imagePickerController.mediaTypes = arrayOfTypes;
        }
        
        [self presentImagePicker];
    }
    else {
        NSLog(@"UIImagePickerController not available for that source");
    }
}

-(void)presentImagePicker
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.presentationStyle == JMMediaPresentationStylePresentModal) {
            [self.delegate presentViewController:self.imagePickerController  animated:YES completion:nil];
        }
        else if (self.presentationStyle == JMMediaPresentationStyleAddSubView) {
            [self.delegate.view addSubview:self.imagePickerController.view];
        }
        else {
            [self.delegate customPresentImagePicker:self.imagePickerController];
        }
    } else {
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePickerController];
        self.popoverController.delegate = self;
        [self.popoverController presentPopoverFromRect:self.viewSelected.frame inView:self.viewSelected.superview permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSLog(@"%s",__FUNCTION__);

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.presentationStyle == JMMediaPresentationStylePresentModal) {
            [self.delegate dismissViewControllerAnimated:YES completion:nil];
        }
        else if (self.presentationStyle == JMMediaPresentationStyleAddSubView) {
            [self.delegate.view removeFromSuperview];
        }
        else {
            [self.delegate customDismissImagePicker:self.imagePickerController];
        }        
    }
    else {
        [self.popoverController dismissPopoverAnimated:YES];
    }
    
    [self.delegate bkImagePickerControllerDidFinishPickingMediaWithInfo:info];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"%s",__FUNCTION__);

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (self.presentationStyle == JMMediaPresentationStylePresentModal) {
            [self.delegate dismissViewControllerAnimated:YES completion:nil];
        }
        else if (self.presentationStyle == JMMediaPresentationStyleAddSubView) {
            [self.delegate.view removeFromSuperview];
        }
        else {
            [self.delegate customDismissImagePicker:self.imagePickerController];
        }
    }
    else {
        [self.popoverController dismissPopoverAnimated:YES];
    }
}

-(NSString *)description
{
    NSMutableString *str = [NSMutableString new];
    [str appendString:@"#POSSIBLE VALUES:\n"];
    [str appendFormat:@"JMMediaTypeCameraPhoto -> %d\n",JMMediaTypeCameraPhoto];
    [str appendFormat:@"JMMediaTypeCameraVideo -> %d\n",JMMediaTypeCameraVideo];
    [str appendFormat:@"JMMediaTypeLibraryPhoto -> %d\n",JMMediaTypeLibraryPhoto];
    [str appendFormat:@"JMMediaTypeLibraryVideo -> %d\n",JMMediaTypeLibraryVideo];
    [str appendFormat:@"JMMediaTypeCamera -> %d\n",JMMediaTypeCamera];
    [str appendFormat:@"JMMediaTypeLibrary -> %d\n",JMMediaTypeLibrary];
    [str appendFormat:@"JMMediaTypePhotos -> %d\n",JMMediaTypePhotos];
    [str appendFormat:@"JMMediaTypeAll -> %d\n",JMMediaTypeAll];
    [str appendFormat:@"#SELECTED TYPE: %d\n", self.type];

    return str;
}




@end
