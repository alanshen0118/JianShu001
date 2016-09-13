//
//  ASPhotoGridCell.h
//  高仿UIImagePickerController
//
//  Created by alan on 9/12/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASPhotoGridCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, copy) NSString *representedAssetIdentifier;

@end
