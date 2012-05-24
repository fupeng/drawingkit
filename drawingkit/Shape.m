
//
//  FaceDraw.h
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "Shape.h"

#define RADIUS 20
@implementation Shape

#define degreesToRadian(x) (M_PI * x / 180.0)
#define radiansToDegrees(x) (180.0 * x / M_PI)

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End);
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second);

CGFloat angleBetweenLines(CGPoint line1Start, CGPoint line1End, CGPoint line2Start, CGPoint line2End) {    
    CGFloat a = line1End.x - line1Start.x;
    CGFloat b = line1End.y - line1Start.y;
    CGFloat c = line2End.x - line2Start.x;
    CGFloat d = line2End.y - line2Start.y;
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));
    return radiansToDegrees(rads);
}
CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
    CGFloat deltaX = second.x - first.x;
    CGFloat deltaY = second.y - first.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY );
};

- (void) drawLineWithArrow:(CGContextRef)context from:(CGPoint)from to:(CGPoint)to 
{
    double slopy, cosy, siny;
    // Arrow size
    double length = 10.0;  
    double width = 10.0;
    
    slopy = atan2((from.y - to.y), (from.x - to.x));
    cosy = cos(slopy);
    siny = sin(slopy);
    
    //draw a line between the 2 endpoint
    CGContextMoveToPoint(context, from.x - length * cosy, from.y - length * siny );
    CGContextAddLineToPoint(context, to.x + length * cosy, to.y + length * siny);
    //paints a line along the current path
    CGContextStrokePath(context);
    
    //here is the tough part - actually drawing the arrows
    //a total of 6 lines drawn to make the arrow shape
    CGContextMoveToPoint(context, from.x, from.y);
    CGContextAddLineToPoint(context,
                            from.x + ( - length * cosy - ( width / 2.0 * siny )),
                            from.y + ( - length * siny + ( width / 2.0 * cosy )));
    CGContextAddLineToPoint(context,
                            from.x + (- length * cosy + ( width / 2.0 * siny )),
                            from.y - (width / 2.0 * cosy + length * siny ) );
    CGContextClosePath(context);
    CGContextStrokePath(context);
    
    /*/-------------similarly the the other end-------------/*/
    CGContextMoveToPoint(context, to.x, to.y);
    CGContextAddLineToPoint(context,
                            to.x +  (length * cosy - ( width / 2.0 * siny )),
                            to.y +  (length * siny + ( width / 2.0 * cosy )) );
    CGContextAddLineToPoint(context,
                            to.x +  (length * cosy + width / 2.0 * siny),
                            to.y -  (width / 2.0 * cosy - length * siny) );
    CGContextClosePath(context);
    CGContextStrokePath(context);
}

- (id)init{
	self = [super init];
	if (self != nil)
	{
        path = [UIBezierPath bezierPath];
        font = [UIFont boldSystemFontOfSize:24];
        [self deselect];
        dots = [NSMutableArray array];
	}
	return self;
}
+ (Shape*)shapeWithArray:(NSArray *)array
{
    Shape *shape=[[Shape alloc] init];
    shape->type = array.count;
    for (int i=0;i<array.count;i++) {
        NSValue *value = [array objectAtIndex:i];
        shape->points[i] = value.CGPointValue;
    }
	return shape;
}
+ (Shape*)shapeWithString:(NSString *)text CGPoint:(CGPoint)point
{
    Shape *shape=[[Shape alloc] init];
    shape->type = 1;
    shape->title = [NSString stringWithString:text];
    shape->points[0]=point;
	return shape;
}
+ (Shape*)shapeWithCGPoint:(CGPoint)p1 p2:(CGPoint)p2
{
    Shape *shape=[[Shape alloc] init];
    shape->type = 2;
    shape->points[0]=p1;
    shape->points[1]=p2;
    shape->title = @"20.11";
	return shape;
}
+ (Shape*)shapeWithCGPoint:(CGPoint)p1 p2:(CGPoint)p2 p3:(CGPoint)p3
{
    Shape *shape=[[Shape alloc] init];
    shape->type = 3;
    shape->points[0]=p1;
    shape->points[1]=p2;
    shape->points[2]=p3;
    shape->title = @"20.11";
	return shape;
}
- (void)drawInContext:(CGContextRef)context{  
    [path removeAllPoints];
    if (type ==1) {
        CGSize size = [title sizeWithFont:font];
        path = [UIBezierPath bezierPathWithRect:CGRectMake(points[0].x, points[0].y, size.width, size.height)];
    }
    
    if (type == 2) {
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
    }
    
    if (type == 3) {
        [path moveToPoint:points[0]];
        [path addLineToPoint:points[1]];
        [path addLineToPoint:points[2]];  
    }
    if (type > 3) {
        [path moveToPoint:points[0]];
        for (int i=1 ; i<type ; i++) {
            [path addLineToPoint:points[i]];
        }
        [path closePath];
    }
    [path setLineWidth:5]; 
    
    [[UIColor blueColor] set];
    if (type>1) {
        [path stroke];        
    }
    
    [[[UIColor redColor] colorWithAlphaComponent:0.5] set];
    if (isSelected) {
        [path setLineWidth:RADIUS];                
        [path stroke];
    }
    if (selPoint>=0) {
        UIBezierPath *temp =[UIBezierPath bezierPathWithArcCenter:points[selPoint] radius:RADIUS startAngle:0 endAngle:M_PI*2 clockwise:YES];
        [temp fill];
    }

    if (type == 3) {
        CGFloat dis = angleBetweenLines(points[1],points[0],points[1],points[2]);
        NSString *text=[NSString stringWithFormat:@"角度%.1f",dis];
        [text drawAtPoint:points[1] withFont:font];    
    }else if (type == 2){
        CGFloat dis = distanceBetweenPoints(points[0],points[1]);
        NSString *text=[NSString stringWithFormat:@"距离%.2f",dis];
        [text drawAtPoint:CGPointMake((points[0].x+points[1].x)/2,(points[0].y+points[1].y)/2) withFont:font];    
    }else if (type == 1){
        [title drawAtPoint:CGPointMake(points[0].x,points[0].y) withFont:font];    
    }
}
- (BOOL)containsViewPoint:(CGPoint)point{
    BOOL res = NO;

    CGPathRef tapTargetPath;
    if (CGPathCreateCopyByStrokingPath) {
        tapTargetPath = CGPathCreateCopyByStrokingPath(path.CGPath, NULL, fmaxf(35.0f, path.lineWidth), path.lineCapStyle, path.lineJoinStyle, path.miterLimit);        
    }else{
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(1.0, 1.0),YES,1.0);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextAddPath(ctx, path.CGPath);
        CGContextSetLineWidth(ctx, fmaxf(35.0f, path.lineWidth));
        CGContextSetLineJoin(ctx, kCGLineJoinMiter);
        CGContextReplacePathWithStrokedPath(ctx);
        tapTargetPath =  CGContextCopyPath(ctx);
        UIGraphicsEndImageContext();   
    }
    
    UIBezierPath *tapTarget = [UIBezierPath bezierPathWithCGPath:tapTargetPath];
    CGPathRelease(tapTargetPath);
    res = [tapTarget containsPoint:point];
    return res;
}
- (void) deselect{
    selPoint = -1;
    isSelected = NO;
}
- (void) select:(CGPoint)point{
    for(int i=0 ; i<type ; i++)
	{
        int dx= point.x-points[i].x;
        int dy= point.y-points[i].y;
        if ( dx*dx+dy*dy < RADIUS*RADIUS ) {
            selPoint = i;
            return;
        }
	}
    isSelected = YES;
}
- (void)transformWithScale:(CGFloat)scale point1:(CGPoint)point1 point2:(CGPoint)point2
{
    for(int i=0 ; i<type ; i++)
    {
        points[i].x = (points[i].x - point1.x) * scale + point2.x;
        points[i].y = (points[i].y - point1.y) * scale + point2.y;
    }  
}
- (void)transformWithX:(int)x y:(int)y
{
    if (selPoint>=0) {
        points[selPoint].x += x;
		points[selPoint].y += y;
    }else{
        for(int i=0 ; i<type ; i++)
        {
            points[i].x += x;
            points[i].y += y;
        }    
    }
}
@end
