//
//  FaceDraw.h
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface Shape : NSObject {
    
@public    
    int type;
    CGPoint points[10];
    bool isSelected;
    int selPoint;
    NSString *title;
    UIBezierPath *path;
    UIFont *font;
    NSMutableArray *dots;
}
+ (Shape*)shapeWithArray:(NSArray *)array;
+ (Shape*)shapeWithString:(NSString *)text CGPoint:(CGPoint)point;
+ (Shape*)shapeWithCGPoint:(CGPoint)p1 p2:(CGPoint)p2;
+ (Shape*)shapeWithCGPoint:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3;
- (void)drawInContext:(CGContextRef)context;
- (BOOL)containsViewPoint:(CGPoint)point;

- (void)transformWithScale:(CGFloat)scale point1:(CGPoint)point1 point2:(CGPoint)point2;
- (void)transformWithX:(int)x y:(int)y;
- (void) select:(CGPoint)point;
- (void) deselect;
@end
