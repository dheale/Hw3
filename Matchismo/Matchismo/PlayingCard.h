//
//  PlayingCard.h
//  Matchismo
//
//  Created by Dominic Heale on 30/01/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
