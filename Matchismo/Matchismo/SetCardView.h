//
//  SetCardView.h
//  SuperCard
//
//  Created by Dominic Heale on 14/02/2013.
//  Copyright (c) 2013 Arthur Mayes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (nonatomic) NSUInteger  number;
@property (nonatomic) NSString   *symbol;
@property (nonatomic) NSString   *shading;
@property (nonatomic) NSString   *color;

// to do: check for setting these to invalid values
//+(NSArray *)validSymbols;
//+(NSArray *)validShadings;
//+(NSArray *)validColors;

// to do:
// consider making an abstract class for these two view classes!
// or should it be a protocol?
@property (nonatomic, getter = isFaceUp) BOOL faceUp;


@end
