//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Dominic Heale on 07/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

-(id) init
{
    self = [super init];
    
    if (self)
    {
        // the deck in "Set" consists of 81 cards varying in four features
        // each combination of features appears precisely once in the deck
        for (int i=1; i<=3; i++)
        {
            for (id symbol in [[SetCard class] validSymbols])
            {
                for (id shading in [[SetCard class] validShadings])
                {
                    for (id color in [[SetCard class] validColors])
                    {
                        SetCard *card = [[SetCard alloc] init];
                        card.number = i;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card atTop:YES];
                    }
                }
            }
        }
    }
    
    return self;
}


@end