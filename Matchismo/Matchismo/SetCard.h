//
//  SetCard.h
//  Matchismo
//
//  Created by Dominic Heale on 07/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "Card.h"

// Each card in a game of Set has
//  Number  - 1, 2 or 3
//  Symbol  - Diamond, Squiggle or Oval
//  Shading - Solid, Striped or Open
//  Color   - Red, Green or Purple

@interface SetCard : Card

@property (nonatomic) NSUInteger  number;
@property (nonatomic) NSString   *symbol;
@property (nonatomic) NSString   *shading;
@property (nonatomic) NSString   *color;

+(NSArray *)validSymbols;
+(NSArray *)validShadings;
+(NSArray *)validColors;

// the controller can draw a fancy picture if it likes
// we're not going to store an attributed string here
//  i.e. NOT @property (strong, nonatomic) NSAttributedString *attributedContents;

@end