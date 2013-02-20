//
//  PlayingCardCollectionViewCell.h
//  Matchismo
//
//  Created by Dominic Heale on 16/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayingCardView.h"

@interface PlayingCardCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end
