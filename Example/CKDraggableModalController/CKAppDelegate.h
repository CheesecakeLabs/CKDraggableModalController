//
//  CKAppDelegate.h
//  CKDraggableModalController
//
//  Created by CocoaPods on 02/04/2015.
//  Copyright (c) 2014 Lucas Martins. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CKDraggableViewController;

@interface CKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic, strong) CKDraggableViewController *draggableViewController;
@end
