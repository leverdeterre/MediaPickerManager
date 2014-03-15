MediaPickerManager
==================
- allows to simplify usage of UIImagePickerController, 
- no need to manipulate UIPopoverController / UIActionSheet
- more code clarity, 
- iPad and iPhone support.

### Shared object that
```objective-c
[MediaPickerManager sharedInstance]
```

### Enum to configure the mediaPicker

```objective-c
typedef NS_OPTIONS(NSInteger,  JMMediaType) {
    JMMediaTypeCameraPhoto = 0,
    JMMediaTypeCameraVideo = 1 << 0,
    JMMediaTypeLibraryPhoto = 1 << 1,
    JMMediaTypeLibraryVideo = 1 << 2,
    JMMediaTypeCamera = JMMediaTypeCameraPhoto | JMMediaTypeCameraVideo,
    JMMediaTypeLibrary = JMMediaTypeLibraryPhoto | JMMediaTypeLibraryVideo,
    JMMediaTypePhotos = JMMediaTypeCameraPhoto | JMMediaTypeLibraryPhoto,
    JMMediaTypeVideos = JMMediaTypeCameraVideo | JMMediaTypeLibraryVideo,
    JMMediaTypeAll = JMMediaTypeCamera | JMMediaTypeLibrary,
};
```

### Enum to configure the the presentation of ImagePicker

```objective-c
typedef NS_ENUM(NSInteger,  JMMediaPresentationStyle) {
    JMMediaPresentationStylePresentModal,
    JMMediaPresentationStyleAddSubView,
    JMMediaPresentationStyleCustom
};
```

### Usage ... very simple with a protocol 

```objective-c
@protocol JMMediaPickerManagerDelegate <NSObject>
- (void)imagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info;
@optional
- (void)customPresentImagePicker:(UIViewController *)controller;
- (void)customDismissImagePicker:(UIViewController *)controller;
@end
```


```objective-c
#import "MediaPickerManager.h"

- (IBAction)photoSelected:(id)sender 
{
    [MediaPickerManager sharedInstance].type = JMMediaTypePhotos;
    [MediaPickerManager sharedInstance].delegate = self;
    [[MediaPickerManager sharedInstance] presentPhotosFrom:sender];
}

#pragma mark JMMediaPickerManagerDelegate

- (void)imagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info
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

```



