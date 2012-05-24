//
//  DDD.m
//  testpath
//
//  Created by Peng Fu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DDD.h"

@implementation DDD

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *img = [UIImage imageNamed:@"big.jpeg"];
        imageView = [[UIImageView alloc] initWithImage:img];
        [self addSubview:imageView];
        
        shapes = [NSMutableArray array];
        
        Shape *s2=[Shape shapeWithCGPoint:CGPointMake(10, 10) p2:CGPointMake(100, 80)];
        [shapes addObject:s2];  

        drawView = [[DrawView alloc] initWithFrame:frame];
        [self addSubview:drawView];
        [drawView setUserInteractionEnabled:NO];
        [drawView setOpaque:NO];
        drawView.shapes = shapes;
        
    }
    return self;
}
- (Shape *)findShap:(CGPoint)point
{
    for (Shape *shape in shapes) {
        if ([shape containsViewPoint:point]) {
            return shape;
        }
    }
    return nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *t = [[touches allObjects] objectAtIndex:0];
    CGPoint p = [t locationInView:self];
    oldDragLocation = p;
    [currentShape deselect];
    currentShape = [self findShap:p];
    if (currentShape) {
        [currentShape select:p];
    } 
    [drawView setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *t = [[touches allObjects] objectAtIndex:0];
    CGPoint p = [t locationInView:self];
    
    if (oldDragLocation.x != p.x || oldDragLocation.y != p.y)
    {
        int xOffset = p.x - oldDragLocation.x;
        int yOffset = p.y - oldDragLocation.y;
        
        if (currentShape)
        {			
            [currentShape transformWithX:xOffset y:yOffset];
        }
        oldDragLocation = p;
        [drawView setNeedsDisplay];
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    //    if (currentShape) {
    //        [currentShape deselect];
    //        [self setNeedsDisplay];
    //        currentShape = nil;        
    //    }
}
@end
