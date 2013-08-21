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
typedef enum {
    JMMediaTypeCameraPhoto = 0,
    JMMediaTypeCameraVideo = 1 << 0,
    JMMediaTypeLibraryPhoto = 1 << 1,
    JMMediaTypeLibraryVideo = 1 << 2,
    JMMediaTypeCamera = JMMediaTypeCameraPhoto | JMMediaTypeCameraVideo,
    JMMediaTypeLibrary = JMMediaTypeLibraryPhoto | JMMediaTypeLibraryVideo,
    JMMediaTypePhotos = JMMediaTypeCameraPhoto | JMMediaTypeLibraryPhoto,
    JMMediaTypeVideos = JMMediaTypeCameraVideo | JMMediaTypeLibraryVideo,
    JMMediaTypeAll = JMMediaTypeCamera | JMMediaTypeLibrary,
} JMMediaType;
```

### Enum to configure the the presentation of ImagePicker

typedef enum {
    JMMediaPresentationStylePresentModal = 0,
    JMMediaPresentationStyleAddSubView = 1,
    JMMediaPresentationStyleCustom = 2
} JMMediaPresentationStyle;


### Usage ... very simple with a protocol 

```objective-c
@protocol JMMediaPickerManagerDelegate <NSObject>
- (void)bkImagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info;
@optional
//Your are responsible of the present and dismiss ..
- (void)customPresentImagePicker:(UIViewController *)controller;
- (void)customDismissImagePicker:(UIViewController *)controller;
@end
```


```objective-c
#import "MediaPickerManager.h"

- (IBAction)photoSelected:(id)sender {
    [MediaPickerManager sharedInstance].type = JMMediaTypePhotos;
    [MediaPickerManager sharedInstance].delegate = self;
    [[MediaPickerManager sharedInstance] photoSelected:sender];
}

#pragma mark JMMediaPickerManagerDelegate

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

```



