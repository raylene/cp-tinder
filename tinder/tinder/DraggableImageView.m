//
//  DraggableImageView.m
//  tinder
//
//  Created by Raylene Yung on 11/14/14.
//  Copyright (c) 2014 Facebook. All rights reserved.
//

#import "DraggableImageView.h"

@interface DraggableImageView () <UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGPoint initialCardLocation;
@property (nonatomic, assign) CGPoint initialOffset;

@end

@implementation DraggableImageView

- (void)setup {
    self.initialCardLocation = self.frame.origin;
    UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    pgr.delegate = self;
    [self addGestureRecognizer:pgr];
}

- (DraggableImageView *)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (DraggableImageView *)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    [self setup];
    return self;
}

- (IBAction)onPanGesture:(UIPanGestureRecognizer *)sender {
    CGPoint location = [sender locationInView:self.superview];
    NSLog(@"onPanGesture: %@", NSStringFromCGPoint(location));
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.initialOffset = [sender locationInView:sender.view];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGRect newFrame = sender.view.frame;
        newFrame.origin.x = location.x - self.initialOffset.x;
        newFrame.origin.y = location.y - self.initialOffset.y;
        sender.view.frame = newFrame;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
