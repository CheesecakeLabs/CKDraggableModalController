//
//  CKDraggableViewController.m
//  Pods
//
//  Created by Lucas Martins on 04/02/2015.
//
//

#import "CKDraggableViewController.h"

@interface CKDraggableViewController ()

@property CGFloat maxCenter;
@property CGFloat minCenter;

@end

@implementation CKDraggableViewController

#pragma mark - LifeCycle

- (instancetype)initWithFrontViewController:(UIViewController *)frontViewController backViewController:(UIViewController *)backViewController
{
	self = [super init];
	if (self) {
		self.frontViewController = frontViewController;
		self.backViewController = backViewController;
		self.closedOffset = kInitialClosedOffset;
	}

	return self;
}


- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];

	[self initViews];
}


- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[self calculateMinAndMaxCenters];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


- (void)calculateMinAndMaxCenters
{
	self.maxCenter = self.backViewController.view.center.y + self.topLayoutGuide.length;
	self.minCenter = self.backViewController.view.center.y + self.frontViewController.view.frame.size.height - self.closedOffset;
}


- (void)initViews
{
	[self configureBackView];
	[self configureFrontView];

	[self setViewPositionForCurrentState];
}

- (void)configureFrontView
{
	if (self.frontViewController) {
		[self addChildViewController:self.frontViewController];
		[self.view addSubview:self.frontViewController.view];

		UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanFrontView:)];
		[self.frontViewController.view addGestureRecognizer:gestureRecognizer];
	}
}


- (void)open:(BOOL)open animated:(BOOL)animated
{
	if (open != self.open) {
		_open = open;

		void (^changeState)() = ^{
			[self setViewPositionForCurrentState];
		};

		if (animated) {
			[UIView animateWithDuration:0.4 animations:changeState];
		} else {
			changeState;
		}
	}
}


- (void)configureBackView
{
	if (self.backViewController) {
		[self addChildViewController:self.backViewController];
		[self.view addSubview:self.backViewController.view];
	}
}


- (void)setViewPositionForCurrentState
{
	CGRect frame = self.view.frame;

	frame.origin.y = self.open ? self.topLayoutGuide.length : frame.size.height - self.closedOffset;

	self.frontViewController.view.frame = frame;
}


#pragma mark - Pan Gestures

- (void)onPanFrontView:(UIPanGestureRecognizer *)recognizer
{
	CGPoint translation = [recognizer translationInView:self.view];
	CGPoint center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);

	if (center.y >= self.maxCenter && center.y <= self.minCenter) {
		recognizer.view.center = center;
		[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
	}
}

@end
