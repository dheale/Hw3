//
//  SetCard.m
//  Matchismo
//
//  Created by Dominic Heale on 07/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//
#import "SetCard.h"

@implementation SetCard

+(NSArray *)validSymbols
{
    static NSArray *validSymbols = nil;
    
    if (!validSymbols) {
        validSymbols = @[@"Diamond", @"Squiggle", @"Oval"];
    }
    return validSymbols;
}

+(NSArray *)validShadings
{
    static NSArray *validShadings = nil;
    
    if (!validShadings) {
        validShadings = @[@"Solid", @"Striped", @"Open"];
    }
    return validShadings;
}

+(NSArray *)validColors
{
    static NSArray *validColors = nil;
    
    if (!validColors) {
        validColors = @[@"Red", @"Green", @"Purple"];
    }
    
    return validColors;
}

// match is either 1 or 0 - either we match or we don't
// set cards have no concept of a good/better/best match
-(int)match:(NSArray *)otherCards
{
    int score = 0;
    if (otherCards.count == 2) // in this game, only 3-cards match at a time
    {
        SetCard *c1 = self;
        SetCard *c2 = otherCards[0];
        SetCard *c3 = otherCards[1];
        
        // we have a set exactly if:
        if (
            (  // either there are three cards all of the same number:
             ((c1.number == c2.number) &&
              (c2.number == c3.number) &&
              (c1.number == c3.number))
             ||
             // or all three different numbers...
             ((c1.number != c2.number) &&
              (c2.number != c3.number) &&
              (c1.number != c3.number)
              )
             )
            &&   // AND as if that wasn't hard enough we must also have
            ( // either all three of the same symbol
             ([c1.symbol isEqualToString:c2.symbol] &&
              [c2.symbol isEqualToString:c3.symbol] &&
              [c1.symbol isEqualToString:c3.symbol])
             ||
             // or all three different symbols
             ((![c1.symbol isEqualToString:c2.symbol]) &&
              (![c2.symbol isEqualToString:c3.symbol]) &&
              (![c1.symbol isEqualToString:c3.symbol])
              )
             )
            &&  // AND ...
            ( // all same or all different shading
             ([c1.shading isEqualToString:c2.shading] &&
              [c2.shading isEqualToString:c3.shading] &&
              [c1.shading isEqualToString:c3.shading])
             ||
             ((![c1.shading isEqualToString:c2.shading]) &&
              (![c2.shading isEqualToString:c3.shading]) &&
              (![c1.shading isEqualToString:c3.shading])
              )
             )
            &&
            ( // AND all same or all different color!
             ([c1.color isEqualToString:c2.color] &&
              [c2.color isEqualToString:c3.color] &&
              [c1.color isEqualToString:c3.color])
             ||
             ((![c1.color isEqualToString:c2.color]) &&
              (![c2.color isEqualToString:c3.color]) &&
              (![c1.color isEqualToString:c3.color])
              )
             )
            ) score = 1;
    }
    return score;
}


-(void)setSymbol:(NSString *)symbol
{
    if ([[SetCard validSymbols] containsObject:symbol]) _symbol = symbol;
}

-(void)setShading:(NSString *)shading
{
    if ([[SetCard validShadings] containsObject:shading]) _shading = shading;
}

-(void)setColor:(NSString *)color
{
    if ([[SetCard validColors] containsObject:color]) _color = color;
}

// for NSLog purposes:
-(NSString *)description
{
    return [NSString stringWithFormat:@"(%d-%@-%@-%@%@)", self.number, self.color, self.shading, self.symbol, (self.number==1?@"":@"s")];
    
}

- (NSString *)contents
{
    return self.description;
}

@end
