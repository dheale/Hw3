//
//  PlayingCard.m
//  Matchismo
//
//  Created by Dominic Heale on 30/01/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;

+(NSArray *)validSuits
{
    static NSArray *validSuits =nil;
    if (!validSuits) validSuits=@[@"♥",@"♦",@"♠",@"♣"];
    return validSuits;
}

-(void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit])
    {
        _suit=suit;
    }
}

-(NSString *)suit
{
    return _suit ? _suit: @"?";
}

+(NSArray *)rankStrings
{
    static NSArray *rankStrings=nil;
    if (!rankStrings) rankStrings=@[@"?",@"A",@"2",@"3",
                                    @"4",@"5",@"6",@"7",
                                    @"8",@"9",@"10",@"J",
                                    @"Q",@"K"];
    return rankStrings;
}

+(NSUInteger) maxRank
{
    return [self rankStrings].count-1;
}

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 0) return 0;
    
    if ([otherCards count] == 1) {
        PlayingCard *otherCard = [otherCards lastObject];
        
        if ([otherCard.suit isEqualToString:self.suit]) {
            score = 1;
        } else if (otherCard.rank == self.rank) {
            score = 4;
        }
    }
    else if (otherCards.count == 2) {
        PlayingCard *c2 = [otherCards objectAtIndex:0];
        PlayingCard *c3 = [otherCards objectAtIndex:1];
        
        if (c2.rank == self.rank && c3.rank == self.rank)
        {
            score = 10;
        } else if ([c2.suit isEqualToString:self.suit] &&
                   [c3.suit isEqualToString:self.suit])
        {
            score = 3;
        } else if (  // 2 rank matches and 2 suit matches
                   ( self.rank == c2.rank ||
                     self.rank == c3.rank ||
                       c2.rank == c3.rank)
                   &&
                   ([c2.suit isEqualToString:self.suit] ||
                    [c3.suit isEqualToString:self.suit] ||
                    [c3.suit isEqualToString:c2.suit]))
        {
            score = 5;
        }
    }
    return score;
}

@end
