//
//  ASPhotoGridController.h
//  高仿UIImagePickerController
//
//  Created by alan on 9/12/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ASImagePickerControllerDelegate <NSObject>

@optional
- (void)as_didFinishPickingImageData:(NSArray *)imageDatas;

@end

@import Photos;

@interface ASPhotoGridController : UIViewController

@property (strong, nonatomic) PHFetchResult *assetsFetchResults;

@property (strong, nonatomic) id<ASImagePickerControllerDelegate> delegate;

@end
