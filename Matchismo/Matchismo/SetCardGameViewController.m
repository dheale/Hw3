//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 18/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardCollectionViewCell.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetCardGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@end


@implementation SetCardGameViewController
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
    
}

@synthesize game=_game; // fixme maybe XCode has sorted its life out today

-(CardMatchingGame *)game
{
    if (!_game)
    {   _game = [[CardMatchingGame alloc] initWithCardCount:[self startingCardCount]
                                                  usingDeck:[[SetCardDeck alloc] init]
                                             matchingNCards:3
                                                 matchBonus:10
                                            mismatchPenalty:3
                                                   flipCost:0];
    }
    return _game;
}

-(NSUInteger) startingCardCount
{
    return 12;
}


- (IBAction)deal3MoreCards:(UIButton *)sender
{
    if ([self.game dealNMoreCards:3] == NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No more cards!"
                                                        message:@"No cards left!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    // we might have been able to add one or two more cards, though...
    [self.cardCollectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];  // fixme reload items at index paths might be better
    
    NSIndexPath *path = [NSIndexPath indexPathForItem:[self.cardCollectionView numberOfItemsInSection:0]-1 inSection:0];
    
    [self.cardCollectionView scrollToItemAtIndexPath:path atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
}


-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL) animate
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]])
    {
        SetCardView *setCardView = ((SetCardCollectionViewCell  *)cell).setCardView;
        if ([card isKindOfClass:[SetCard class]])
        {
            SetCard *setCard    = (SetCard *)card;
            setCardView.number  = setCard.number;
            setCardView.symbol  = setCard.symbol;
            setCardView.shading = setCard.shading;
            setCardView.color   = setCard.color;
            
            setCardView.faceUp = setCard.isFaceUp;
            
            for (UIView * subview in [setCardView subviews])
            {
                if (animate)
                {
                    [UIView animateWithDuration:0.2
                                     animations:^{subview.alpha = 0.0;}
                                     completion:^(BOOL finished){ [subview removeFromSuperview]; }];
                }
                else
                {
                    [subview removeFromSuperview];
                }
            }
            
            if (setCard.isFaceUp) // && !setCardView.subviews)
            {
                // we want to mark it somehow, so we know it is selected
                NSString *pushPin = @"📌";
                UILabel *pushPinView = [[UILabel alloc] initWithFrame:CGRectMake(setCardView.bounds.size.width *0.47f,
                                                                                 setCardView.bounds.size.height*0.00f,
                                                                                 setCardView.bounds.size.width *0.3f,
                                                                                 setCardView.bounds.size.height*0.3f)];
                pushPinView.adjustsFontSizeToFitWidth=YES;
                pushPinView.font = [UIFont systemFontOfSize:18.0];
                
                pushPinView.backgroundColor=[UIColor clearColor];
                pushPinView.text = pushPin;
                
               [setCardView addSubview:pushPinView];
            }
        }
    }
}


-(void)updateStatus:(UIView *)view withMove:(CardGameMove *)move
{
    CGFloat xOffset = 0;
    
    [self clearStatus:view];
    CGFloat miniCardWidth = view.bounds.size.width *0.15f;
    
    // now add a text description of the move
    if (move.moveKind == MoveKindFlipUp)
    {
        NSString *flippedUp = @"Flipped up: ";
        CGFloat widthOfLabel = 75.0f; // FIXME magic number for width
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, widthOfLabel,
                                                                       view.bounds.size.height)];
        labelView.adjustsFontSizeToFitWidth=YES;
        
        labelView.backgroundColor=[UIColor clearColor];
        
        labelView.text = flippedUp;
        [view addSubview:labelView];
        
        xOffset += labelView.bounds.size.width;
    }
    for (SetCard *card in [move cardsThatWereFlipped])
    {
        if ([card isKindOfClass:[SetCard class]])
        {
            CGFloat miniCardHeight = miniCardWidth * 110/70;
            SetCardView *setCardView = [[SetCardView alloc] initWithFrame:CGRectMake(xOffset, 0, miniCardWidth, miniCardHeight)];
            
            setCardView.opaque = NO;
            setCardView.faceUp = YES;
            [setCardView setBackgroundColor:[UIColor clearColor]];
            setCardView.number = card.number;
            setCardView.symbol = card.symbol;
            setCardView.shading = card.shading;
            setCardView.color = card.color;
            setCardView.faceUp = NO;
            
            [view addSubview:setCardView];
            xOffset += setCardView.bounds.size.width + 10;
        }
    }
    // now add a text description of the move
    if (move.moveKind == MoveKindMatchForPoints || move.moveKind == MoveKindMismatchForPenalty)
    {
        UILabel *labelView = [[UILabel alloc] initWithFrame:CGRectMake(xOffset, 0, view.bounds.size.width-xOffset,view.bounds.size.height)];
        labelView.backgroundColor=[UIColor clearColor];
        labelView.adjustsFontSizeToFitWidth=YES;
        labelView.numberOfLines=3;
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
