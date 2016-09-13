//
//  ASImagePickerController.h
//  高仿UIImagePickerController
//
//  Created by alan on 9/11/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASPhotoGridController.h"

@interface ASImagePickerController : UINavigationController

@property (weak ,nonatomic) id<ASImagePickerControllerDelegate, UINavigationControllerDelegate> delegate;

@end
