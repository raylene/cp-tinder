//
//  CardsViewController.m
//  tinder
//
//  Created by Raylene Yung on 11/13/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "CardsViewController.h"
#import "ProfileViewController.h"

@interface CardsViewController () <UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (nonatomic, assign) BOOL isPresenting;

@end

@implementation CardsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cardImageView.image = [UIImage imageNamed:@"ryan"];

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapGesture:)];
    [self.cardImageView addGestureRecognizer:tgr];
    
    NSLog(@"CardVC dims: %@, %@", NSStringFromCGRect(self.view.frame), NSStringFromCGRect(self.cardImageView.frame));
}

- (void)onTapGesture:(UITapGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.view];
    NSLog(@"onTapGesture: %@", NSStringFromCGPoint(location));
    
    ProfileViewController *vc = [[ProfileViewController alloc] init];
    vc.image = self.cardImageView.image;

    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - Transition delegate methods

- (id)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.isPresenting = YES;
    return self;
}

- (id)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.isPresenting = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.8;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIImageView *movingImageView = [[UIImageView alloc] initWithFrame:self.cardImageView.frame];
    movingImageView.image = self.cardImageView.image;
    movingImageView.contentMode = self.cardImageView.contentMode;
    movingImageView.clipsToBounds = self.cardImageView.clipsToBounds;
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:movingImageView];
    
    if (self.isPresenting) {
        NSLog(@"I'm presenting");
        [containerView addSubview:toViewController.view];
        
        ProfileViewController *pvc = (ProfileViewController *)toViewController;
        self.cardImageView.hidden = YES;
        
        toViewController.view.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
            toViewController.view.alpha = 1;
            movingImageView.frame = pvc.imageView.frame;
            pvc.imageView.hidden = YES;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [movingImageView removeFromSuperview];
            pvc.imageView.hidden = NO;
            self.cardImageView.hidden = NO;
        }];
    } else {
        NSLog(@"I'm dismissing");
        [UIView animateWithDuration:0.4 animations:^{
            fromViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [fromViewController.view removeFromSuperview];
        }];
    }
}

@end
