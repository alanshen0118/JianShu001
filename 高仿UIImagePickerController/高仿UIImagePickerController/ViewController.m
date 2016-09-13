//
//  ViewController.m
//  高仿UIImagePickerController
//
//  Created by alan on 9/11/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ViewController.h"
#import "ASImagePickerController.h"

@interface ViewController ()<ASImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)chooseAssets:(id)sender {
    ASImagePickerController *imagePicker = [[ASImagePickerController alloc] init];
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)as_didFinishPickingImageData:(NSArray *)imageDatas {
    CGFloat currentY = 0.f;
    for (UIImageView *imageView in self.scrollView.subviews) {
        [imageView removeFromSuperview];
    }
    for (NSData *data in imageDatas) {
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(0, currentY, 100, 100);
        currentY += CGRectGetHeight(imageView.frame) + 10.f;
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), currentY);
        [self.scrollView addSubview:imageView];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
