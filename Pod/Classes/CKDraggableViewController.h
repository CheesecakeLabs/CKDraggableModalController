//
//  CKDraggableViewController.h
//  Pods
//
//  Created by Lucas Martins on 04/02/2015.
//
//

#import <UIKit/UIKit.h>

static const float kInitialClosedOffset = 45.f;

@interface CKDraggableViewController : UIViewController <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property(nonatomic, strong) UIViewController *backViewController;
@property(nonatomic, strong) UIViewController *frontViewController;

@property(readonly) BOOL open;

@property CGFloat closedOffset;
@property CGFloat openedOffset;

- (instancetype)initWithFrontViewController:(UIViewController *)frontViewController backViewController:(UIViewController *)backViewController;

- (void)open:(BOOL)open animated:(BOOL)animated;
@end
