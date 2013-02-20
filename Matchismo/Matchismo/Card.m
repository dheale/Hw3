//
//  Card.m
//  Matchismo
//
//  Created by Dominic Heale on 30/01/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "Card.h"

@implementation Card

-(int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card * card in otherCards)
    {
        if ([card.contents isEqualToString:self.contents])
        {
            score=1;
        }
    }
    
    return score;
}


-(NSString*) contents
{
    return @"?";
}


@end
