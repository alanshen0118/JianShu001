//
//  ASImagePickerController.m
//  高仿UIImagePickerController
//
//  Created by alan on 9/11/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASImagePickerController.h"
#import "ASAlbumListController.h"

@interface ASImagePickerController ()

@end

@implementation ASImagePickerController
@dynamic delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    ASAlbumListController *albumListController = [[ASAlbumListController alloc] init];
    albumListController.delegate = self.delegate;
    self.viewControllers = @[albumListController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
