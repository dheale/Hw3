//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Dominic Heale on 03/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "deck.h"
#import "CardGameMove.h"

@interface CardMatchingGame : NSObject

// this is a convenience initializer and you will get defaults
// of matchBonus 4
//    mismatchPenalty 2
//    flipCost 1
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards;

// this is another convenience initializer and you will get defaults
// above but also matching 2 cards
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck;



// this is the designated initializer
-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck
        matchingNCards:(int)matchNCards
            matchBonus:(int)matchBonus
       mismatchPenalty:(int)mismatchPenalty
              flipCost:(int)flipCost;

-(CardGameMove *)flipCardAtIndex:(NSUInteger)index;

-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic,readonly) int score;

@property (strong, nonatomic) NSMutableArray *moveHistory;



//Since cards can now be added to an existing game, your CardMatchingGame will have to
// ... have public API to cause more cards to be put in play from that deck,

-(BOOL)dealNMoreCards:(NSUInteger)N;

//and have public API to let anyone who’s interested know how many cards are currently in play.
// for "currently in play" we mean cards that are on the table - matched ones are taken out of play
// and don't count
-(NSUInteger)numberOfCardsCurrentlyInPlay;

// The Extra Credit to animate the removal of cards might also benefit from a reverse indexOfCard: method (not in all solutions, but in some)
-(NSUInteger)indexOfCard:(Card *)card;

// (having an API in your Model for deleting cards from the game and letting the Controller decide when to do this)
-(void)removeCardAtIndex:(NSUInteger)index;


@end
