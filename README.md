MediaPickerManager
==================
- allows to simplify usage of UIImagePickerController, 
- more code clarity, 
- iPad and iPhone support.

### Shared object that
```objective-c
[MediaPickerManager sharedInstance]
```

### Enum to configure the mediaPicker

```objective-c
typedef enum {
    JMMediaTypeCameraPhoto = 1UL << 0,
    JMMediaTypeCameraVideo = 1UL << 1,
    JMMediaTypeLibraryPhoto = 1UL << 2,
    JMMediaTypeLibraryVideo = 1UL << 3,
    JMMediaTypeCamera = JMMediaTypeCameraPhoto | JMMediaTypeCameraVideo,
    JMMediaTypeLibrary = JMMediaTypeLibraryPhoto | JMMediaTypeLibraryVideo,
    JMMediaTypePhotos = JMMediaTypeCameraPhoto | JMMediaTypeLibraryPhoto,
    JMMediaTypeVideos = JMMediaTypeCameraVideo | JMMediaTypeLibraryVideo,
    JMMediaTypeAll = JMMediaTypeCamera | JMMediaTypeLibrary,
} JMMediaType;
```

### Usage ... very simple with a protocol 

```objective-c
@protocol JMMediaPickerManagerDelegate <NSObject>
- (void)bkImagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info;
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



