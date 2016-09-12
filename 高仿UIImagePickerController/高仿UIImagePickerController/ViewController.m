//
//  ViewController.m
//  高仿UIImagePickerController
//
//  Created by alan on 9/11/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ViewController.h"
#import "ASImagePickerController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)chooseAssets:(id)sender {
    
    [self presentViewController:[[ASImagePickerController alloc] init] animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
