//
//  MediaPickerManager.h
//
//  Created by Jerome Morissard on 8/15/13.
//  Copyright (c) 2013 Jerome Morissard. All rights reserved.
//

#import <Foundation/Foundation.h>


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


typedef NS_ENUM(NSInteger,  JMMediaPresentationStyle) {
    JMMediaPresentationStylePresentModal,
    JMMediaPresentationStyleAddSubView,
    JMMediaPresentationStyleCustom
};


@protocol JMMediaPickerManagerDelegate <NSObject>
- (void)imagePickerControllerDidFinishPickingMediaWithInfo:(NSDictionary *)info;
@optional
- (void)customPresentImagePicker:(UIViewController *)controller;
- (void)customDismissImagePicker:(UIViewController *)controller;
@end

@interface MediaPickerManager : NSObject

@property (assign) JMMediaType type;
@property (assign) JMMediaPresentationStyle presentationStyle;

@property (weak, nonatomic) UIViewController <JMMediaPickerManagerDelegate> *delegate;

+ (instancetype)sharedInstance;

- (void)presentPhotosFrom:(id)sender;
- (void)presentVideosFrom:(id)sender;

@end
