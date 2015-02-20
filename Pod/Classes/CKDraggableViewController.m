//
//  CKDraggableViewController.m
//  Pods
//
//  Created by Lucas Martins on 04/02/2015.
//
//

#import "CKDraggableViewController.h"


@interface CKDraggableViewController ()

@property(nonatomic) CGFloat maxCenter;
@property(nonatomic) CGFloat minCenter;

@property(nonatomic, strong) UIDynamicAnimator *animator;
@property(nonatomic, strong) UIGravityBehavior *gravity;

@property(nonatomic) BOOL goingUp;

@property(nonatomic) CGFloat topOffset;
@property(nonatomic) CGFloat bottomOffset;
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

	[self initBehaviors];

}


- (void)initBehaviors
{
	self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
	self.gravity = [[UIGravityBehavior alloc] initWithItems:@[self.frontViewController.view]];

	UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.frontViewController.view]];
	collisionBehavior.collisionDelegate = self;

	CGFloat boundaryBottom = self.bottomOffset + self.frontViewController.view.frame.size.height;

	CGPoint boundaryTopRight = CGPointMake(self.view.frame.size.width, self.topOffset);
	CGPoint boundaryTopLeft = CGPointMake(0, self.topOffset);
	CGPoint boundaryBottomLeft = CGPointMake(0, boundaryBottom);
	CGPoint boundaryBottomRight = CGPointMake(self.view.frame.size.width, boundaryBottom);

	[collisionBehavior addBoundaryWithIdentifier:@"top" fromPoint:boundaryTopLeft toPoint:boundaryTopRight];
	[collisionBehavior addBoundaryWithIdentifier:@"bottom" fromPoint:boundaryBottomLeft toPoint:boundaryBottomRight];

	[collisionBehavior addBoundaryWithIdentifier:@"left" fromPoint:boundaryTopLeft toPoint:boundaryBottomLeft];
	[collisionBehavior addBoundaryWithIdentifier:@"right" fromPoint:boundaryTopRight toPoint:boundaryBottomRight];

	[self.animator addBehavior:collisionBehavior];
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

	self.topOffset = self.topLayoutGuide.length;
	self.bottomOffset = self.frontViewController.view.frame.size.height - self.closedOffset;
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

		if (animated) {
			[self.animator removeBehavior:self.gravity];

			self.gravity.gravityDirection = CGVectorMake(0, open ? -1.0f : 1.0f);
			[self.animator addBehavior:self.gravity];
			[self.animator updateItemUsingCurrentState:self.frontViewController.view];
		} else {
			[self setViewPositionForCurrentState];
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
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		[self.animator removeBehavior:self.gravity];

	} else if (recognizer.state == UIGestureRecognizerStateChanged) {

		CGPoint translation = [recognizer translationInView:self.view];
		CGPoint center = CGPointMake(recognizer.view.center.x, recognizer.view.center.y + translation.y);

		self.goingUp = translation.y < 0;
		if (center.y >= self.maxCenter && center.y <= self.minCenter) {
			recognizer.view.center = center;
			[recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
		}

	} else if (recognizer.state == UIGestureRecognizerStateEnded) {

		if (self.goingUp) {
			self.gravity.gravityDirection = CGVectorMake(0, -1.0f);
		} else {
			self.gravity.gravityDirection = CGVectorMake(0, 1.0f);
		}

		[self.animator addBehavior:self.gravity];
		[self.animator updateItemUsingCurrentState:self.frontViewController.view];
	}
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier
{
	NSLog(@"Collision Detected");
}


- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
	[self.animator removeBehavior:self.gravity];
}


@end
