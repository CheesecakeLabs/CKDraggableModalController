//
//  CKDraggableViewController.m
//  Pods
//
//  Created by Lucas Martins on 04/02/2015.
//
//

#import "CKDraggableViewController.h"

@interface CKDraggableViewController ()

@end

@implementation CKDraggableViewController

- (instancetype)initWithFrontViewController:(UIViewController *)frontViewController backViewController:(UIViewController *)backViewController
{
	self = [super init];
	if (self) {
		self.frontViewController = frontViewController;
		self.backViewController = backViewController;
	}

	return self;
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	[self initViews];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)initViews
{
	[self configureBackView];
	[self configureFrontView];
	self.closedOffset = kInitialClosedOffset;
	[self setViewPositionForState];
}

- (void)configureFrontView
{
	if (self.frontViewController) {
		[self addChildViewController:self.frontViewController];
		[self.view addSubview:self.frontViewController.view];
	}
}

- (void)configureBackView
{
	if (self.backViewController) {
		[self addChildViewController:self.backViewController];
		[self.view addSubview:self.backViewController.view];
	}
}


- (void)setViewPositionForState
{
	CGRect frame = self.view.frame;
	frame.origin.y = frame.size.height - self.closedOffset;
	self.frontViewController.view.frame = frame;
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
