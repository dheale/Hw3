//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Dominic Heale on 13/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCount; // abstract
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate; // abstract
-(void)updateStatus:(UIView *)view withMove:(CardGameMove *)move; // abstract
-(void)clearStatus:(UIView *)view;
@property (weak, nonatomic) IBOutlet UIView *statusView;

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;

@end
