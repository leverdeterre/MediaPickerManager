//
//  MediaPickerManager.h
//
//  Created by Jerome Morissard on 8/15/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@protocol JMMediaPickerManagerDelegate <NSObject>
- (void)bkImagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info;
@end

@interface MediaPickerManager : NSObject

@property (assign) JMMediaType type;
@property (weak, nonatomic) UIViewController <JMMediaPickerManagerDelegate> *delegate;

+ (instancetype)sharedInstance;

- (IBAction)photoSelected:(id)sender;
- (IBAction)videoSelected:(id)sender;

@end
