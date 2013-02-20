//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Arthur Mayes on 2/8/13.
//  Copyright (c) 2013 Arthur Mayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) NSString *suit;

@property (nonatomic) BOOL faceUp;

-(void)pinch: (UIPinchGestureRecognizer *)gesture;

@end
