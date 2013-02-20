#import "SetCardView.h"
#import <math.h>

#define SET_CARD_ROUNDED_RECT_CORNER_RADIUS_PERCENT 0.14f

#define SYMBOL_PERCENT_OF_CARD_HEIGHT (0.2)
#define SYMBOL_PERCENT_OF_CARD_WIDTH  (0.6)
#define SYMBOL_GAP (1.2)

#define STRIPE_WIDTH (1.0)
#define STRIPE_EVERY_N_PERCENT (0.04f)
#define SET_CARD_OPEN_LINE_WIDTH (1.2f)

#define SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES (0.9f)
#define SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES (0.66f)

#define SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT (0.05f)
// that's how much the squiggle's parallelogram is pushed over in the x direction
//    e.g. p3 is to the right of p1 by TWICE this pshift value

#define SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT (0.3f)


@implementation SetCardView

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                           cornerRadius:
                                 self.bounds.size.width*SET_CARD_ROUNDED_RECT_CORNER_RADIUS_PERCENT];
    [roundedRect addClip]; //prevents filling corners, i.e. sharp corners not included in roundedRect
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [self drawSymbols];
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
}


-(void)drawSymbols
{
    // work out where to put each symbol
    
    // if we have one symbol, then it's just at centre point
    // if we have two symbols, then it's centre point +/- some gap
    // if we have three symbols, then it's centre point, and then C.P +/- some gap
    
    NSMutableArray * symbolHeightDeltas = [[NSMutableArray alloc] init];
    
    if (self.number==1)
    {
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:0.0f]];
    } else if (self.number == 2)
    {
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:-[self halfSymbolHeight]*SYMBOL_GAP]];
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:+[self halfSymbolHeight]*SYMBOL_GAP]];
    } else // if (self.number == 3)
    {
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:-[self symbolHeight]*SYMBOL_GAP]];
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:0.0f]];
        [symbolHeightDeltas addObject:[NSNumber numberWithFloat:+[self symbolHeight]*SYMBOL_GAP]];
    }
    
    
    for (NSNumber *num in symbolHeightDeltas)
    {
        CGPoint centrePt = CGPointMake(self.bounds.size.width /2,
                                       self.bounds.size.height/2-[num floatValue]);
        
        if ([self.symbol isEqualToString:@"Diamond"])
        {
            [self drawOneDiamondAtPoint:centrePt];
        }
        else if ([self.symbol isEqualToString:@"Oval"])
        {
            [self drawOneOvalAtPoint:centrePt];
        }
        else // if ([self.symbol isEqualToString:@"Squiggle"])
        {
            [self drawOneSquiggleAtPoint:centrePt];
        }
    }
}

-(void) drawOneDiamondAtPoint:(CGPoint)centrePoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Move the origin so we are drawing with (0,0) in the centre of our shape
    CGContextTranslateCTM(context, centrePoint.x, centrePoint.y);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    [path    moveToPoint:CGPointMake(-[self halfSymbolWidth],        0)];
    [path addLineToPoint:CGPointMake(      0, -[self halfSymbolHeight])];
    [path addLineToPoint:CGPointMake( [self halfSymbolWidth],        0)];
    [path addLineToPoint:CGPointMake(      0,  [self halfSymbolHeight])];
    [path closePath];
    
    [self paintPath:path];
    
    CGContextRestoreGState(context);
}

-(void) paintPath:(UIBezierPath *)path
{
    if ([self.shading isEqualToString:@"Solid"])
    {
        [[self symbolUIColor] setFill];
        [path fill];
    }
    else if ([self.shading isEqualToString:@"Open"])
    {
        [path setLineWidth:SET_CARD_OPEN_LINE_WIDTH];
    }
    
    [[self symbolUIColor] setStroke];
    [path stroke];
    
    if ([self.shading isEqualToString:@"Striped"])
    {
        [path addClip];
        // we're going to draw a single dashed line from left to right, as wide as our height
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIBezierPath *stripes = [[UIBezierPath alloc] init];
        
        CGFloat dashes[] = {STRIPE_WIDTH, roundl(self.bounds.size.width*STRIPE_EVERY_N_PERCENT) };
        CGContextSetLineDash(context, 0.0, dashes, 2); // 0 is 'phase', 2 is num elements in dashes array
        
        [stripes setLineWidth:path.bounds.size.height];
        
        [stripes moveToPoint:CGPointMake(-path.bounds.size.width, 0)];
        [stripes addLineToPoint:CGPointMake(path.bounds.size.width, 0)];
        
        [stripes stroke];
    }
}

-(void) drawOneOvalAtPoint:(CGPoint)centrePoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centrePoint.x, centrePoint.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-[self halfSymbolWidth], -[self halfSymbolHeight],
                                                                            [self symbolWidth],      [self symbolHeight])
                                                    cornerRadius:[self halfSymbolHeight]];
    [self paintPath:path];
    
    CGContextRestoreGState(context);
}

-(void) drawOneSquiggleAtPoint:(CGPoint)centrePoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    // Move the origin so we are drawing with (0,0) in the centre of our shape
    CGContextTranslateCTM(context, centrePoint.x, centrePoint.y);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    // for a squiggle, we have four points, arranged in a parallelogram
    // clockwise, from top left, top right, bottom right, bottom left, they're called p1 p2 p3 p4
    // the parallelogram has a width and a height, but because our origin is in the centre
    // we often need half these values: let's call these half values pwidth and pheight
    
    CGFloat pwidth  = [self halfSymbolWidth] * SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES;
    CGFloat pheight = [self halfSymbolHeight]* SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES;
    
    // the parallelogram has another value - pshift - which is how much it is slanted
    // i.e. how much it is pushed over in the x direction
    //    e.g. p3 is to the right of p1 by TWICE this pshift value
    
    CGFloat pshift = self.halfSymbolWidth * SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT;
    
    CGPoint p1, p2, p3, p4;
    p1 = CGPointMake(-pwidth-pshift, -pheight);
    p2 = CGPointMake( pwidth-pshift, -pheight);
    
    p3 = CGPointMake( pwidth+pshift,  pheight);
    p4 = CGPointMake(-pwidth+pshift,  pheight);
    
    // then we have the control points for the curves
    // there are two kinds of curves: the horizontal waves
    //    and the vertical ends
    
    // horizontal wave: the control points for p1 is 45 degrees up   and right of p1
    // horizontal wave: the control points for p2 is 45 degrees down and left  of p2
    
    // vertical end: the control points for p2 is 45 degrees right and up of p2
    // vertical end: the control points for p3 is 45 degrees right and up of p3
    
    // the length of the control point vector (between p1 and cp1) is proportional to the height/width
    // this is the same value for both x and the y because we're using 45 degrees
    CGFloat controlPointOffset = [self halfSymbolWidth]*SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT;
    
    [path moveToPoint:p1];
    // top
    [path addCurveToPoint:p2
            controlPoint1:CGPointMake(p1.x+controlPointOffset, p1.y-controlPointOffset)
            controlPoint2:CGPointMake(p2.x-controlPointOffset, p2.y+controlPointOffset)];
    // rhs
    [path addCurveToPoint:p3
            controlPoint1:CGPointMake(p2.x+controlPointOffset, p2.y-controlPointOffset)
            controlPoint2:CGPointMake(p3.x+controlPointOffset, p3.y-controlPointOffset)];
    // bottom
    [path addCurveToPoint:p4
            controlPoint1:CGPointMake(p3.x-controlPointOffset, p3.y+controlPointOffset)
            controlPoint2:CGPointMake(p4.x+controlPointOffset, p4.y-controlPointOffset)];
    // lhs
    [path addCurveToPoint:p1
            controlPoint1:CGPointMake(p4.x-controlPointOffset, p4.y+controlPointOffset)
            controlPoint2:CGPointMake(p1.x-controlPointOffset, p1.y+controlPointOffset)];
    [path closePath];
    
    [self paintPath:path];
    
    CGContextRestoreGState(context);
}

-(UIColor *)symbolUIColor
{
    if ([self.color isEqualToString:@"Red"])
        return [UIColor colorWithRed:1.0   green:0.0  blue:0.23 alpha:1.0];
    else if ([self.color isEqualToString:@"Purple"])
        return [UIColor colorWithRed:0.6   green:0.1  blue:0.6  alpha:1.0];
    else if ([self.color isEqualToString:@"Green"])
        return [UIColor colorWithRed:0.262 green:0.83 blue:0.3  alpha:1.0];
    
    else assert(false);
}


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

-(void)setNumber:(NSUInteger)number
{
    assert(number > 0 && number < 4);
    
    _number = number;
    [self setNeedsDisplay];
}

-(void)setSymbol:(NSString *)symbol
{
    assert([[SetCardView validSymbols] containsObject:symbol]);
    
    _symbol = symbol;
    [self setNeedsDisplay];
}

-(void)setShading:(NSString *)shading
{
    assert([[SetCardView validShadings] containsObject:shading]);
    
    _shading = shading;
    [self setNeedsDisplay];
}

-(void)setColor:(NSString *)color
{
    assert([[SetCardView validColors] containsObject:color]);
    
    _color = color;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(CGFloat) symbolHeight
{
    return self.bounds.size.height * SYMBOL_PERCENT_OF_CARD_HEIGHT;
}

-(CGFloat) halfSymbolHeight
{
    return (self.symbolHeight)/2;
}

-(CGFloat) symbolWidth
{
    return self.bounds.size.width * SYMBOL_PERCENT_OF_CARD_WIDTH;
}

-(CGFloat) halfSymbolWidth
{
    return (self.symbolWidth)/2;
}

@end