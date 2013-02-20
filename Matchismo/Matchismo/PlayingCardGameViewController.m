//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 13/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"
#import "CardGameMove.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
    
}

-(NSUInteger) startingCardCount
{
    return 20;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL) animate
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]])
    {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell  *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]])
        {
            PlayingCard *playingCard = (PlayingCard *)card;
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            if (animate && playingCardView.faceUp != playingCard.isFaceUp)
            {
            [UIView transitionWithView:playingCardView
                              duration:0.5
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                playingCardView.faceUp = playingCard.isFaceUp;

                                                            }
                            completion:NULL];
            } else
            {
                playingCardView.faceUp = playingCard.isFaceUp;
            }
            
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }

}


-(void)updateStatus:(UIView *)view withMove:(CardGameMove *)move
{
    CGFloat xOffset = 0;

    [self clearStatus:view];
    CGFloat miniCardWidth = view.bounds.size.width *0.25f;

    // now add a text description of the move
    if (move.moveKind == MoveKindFlipUp)
    {
        NSString *flippedUp = @"Flipped up: ";
        CGFloat widthOfLabel = 75.0f; // FIXME magic number for width
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, widthOfLabel,
            view.bounds.size.height)];
        labelView.adjustsFontSizeToFitWidth=YES;
        labelView.autoresizesSubviews = YES;
        labelView.backgroundColor=[UIColor clearColor];

        labelView.text = flippedUp;
        [view addSubview:labelView];
        
        xOffset += labelView.bounds.size.width;
    }
    for (PlayingCard *card in [move cardsThatWereFlipped])
    {
        if ([card isKindOfClass:[PlayingCard class]])
        {
            CGFloat miniCardHeight = miniCardWidth * 110/70;
            PlayingCardView *playingCardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(xOffset, 0, miniCardWidth, miniCardHeight)];
            
            playingCardView.opaque = NO;
            playingCardView.faceUp = YES;
            [playingCardView setBackgroundColor:[UIColor clearColor]];
            playingCardView.rank = card.rank;
            playingCardView.suit = card.suit;
            
            [view addSubview:playingCardView];
            xOffset += playingCardView.bounds.size.width + 10;
        }
    }
    // now add a text description of the move
    if (move.moveKind == MoveKindMatchForPoints || move.moveKind == MoveKindMismatchForPenalty)
    {
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, view.bounds.size.width-xOffset,view.bounds.size.height)];
        labelView.backgroundColor=[UIColor clearColor];
        labelView.adjustsFontSizeToFitWidth=YES;
        labelView.numberOfLines=3;
        labelView.autoresizesSubviews = YES;
        if (move.moveKind == MoveKindMatchForPoints)
        {
        labelView.text = [NSString stringWithFormat:@"✅ Match for %d points!",move.scoreDeltaForThisMove];
        } else
        {
            labelView.numberOfLines=5;
            labelView.text = [NSString stringWithFormat:@"❌ don't match! %d point penalty!", abs(move.scoreDeltaForThisMove)];
        }
        [view addSubview:labelView];
        xOffset += labelView.bounds.size.width;
    }
}

@end
