//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Dominic Heale on 13/02/2013.
//  Copyright (c) 2013 Dominic Heale. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
#import "CardGameMove.h"

@interface CardGameViewController () <UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@end


@implementation CardGameViewController

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.game numberOfCardsCurrentlyInPlay];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Card" forIndexPath:indexPath];
    Card *card = [self.game cardAtIndex:indexPath.item];
    [self updateCell:cell usingCard:card animate:NO];
    return cell;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card animate:(BOOL)animate
{
    // abstract
}


- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (IBAction)deal {
    self.game = nil;
    [self.cardCollectionView reloadData];
    [self clearStatus:self.statusView];
    [self updateUI];
    
    [self.cardCollectionView reloadData];
}

-(void)clearStatus:(UIView *)view
{
    for (UIView *subview in [view subviews])
    {
        [subview removeFromSuperview];
    }
}

- (IBAction)flipCard:(UITapGestureRecognizer *)gesture
{
    CGPoint tapLocation = [gesture locationInView:self.cardCollectionView];
    NSIndexPath *indexPath = [self.cardCollectionView indexPathForItemAtPoint:tapLocation];
    
    if (indexPath)
    {
        CardGameMove *move = [self.game flipCardAtIndex:indexPath.item];
        [self clearStatus:self.statusView];
        
        if (move)
        {
            [self updateStatus:self.statusView withMove:move];
        }
        // if we have just matched, then we want to delete some cards from the game
        // n.b. was: CardGameMove *move = [self.game.moveHistory lastObject];
        if (move && move.moveKind==MoveKindMatchForPoints)
        {
            // need to remove the matched objects from the game
            NSMutableArray *indexPathsForDeletedCards = [[NSMutableArray alloc] init];
            
            for (Card * card in move.cardsThatWereFlipped)
            {
                [indexPathsForDeletedCards addObject:
                 [NSIndexPath indexPathForItem:[self.game indexOfCard:card] inSection:0]
                 ];
                
            }
            for (Card * card in move.cardsThatWereFlipped)
            {
                [self.game removeCardAtIndex:[self.game indexOfCard:card]];
            }
            
            [self.cardCollectionView deleteItemsAtIndexPaths:indexPathsForDeletedCards];
        }
        
        [self updateUI];
    }
    
}

-(Deck *)createDeck
{
    return nil; // abstract
}

-(void)updateStatus:(UIView *)view withMove:(CardGameMove *)move
{
    return; //abstract
}

-(void)updateUI
{
    for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells])
    {
        NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
        Card *card = [self.game cardAtIndex:indexPath.item];
        
        [self updateCell:cell usingCard:card animate:YES];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
