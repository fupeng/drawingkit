//
//  FaceDraw.m
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FaceDraw.h"

@implementation FaceDraw
@synthesize shapes, imageView;

CGFloat lastScale = 1.0;
CGPoint oldDragLocation;

-(void)scale:(UIPinchGestureRecognizer*)sender {  
    
    //当手指离开屏幕时,将lastscale设置为1.0  
    if([sender state] == UIGestureRecognizerStateEnded) {  
        lastScale = 1.0;  
        return;  
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);    
    CGAffineTransform currentTransform = imageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    CGPoint origin1 = imageView.frame.origin;
    [imageView setTransform:newTransform];    
    CGPoint origin2 = imageView.frame.origin;
        
    for (Shape *shape in self.shapes) {
        [shape transformWithScale:scale point1:origin1 point2:origin2];
    }
    [drawView setNeedsDisplay];
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
} 

-(void)initData{
    currentShape = nil;
    self.shapes = [NSMutableArray array];
    
    Shape *s2=[Shape shapeWithCGPoint:CGPointMake(10, 10) p2:CGPointMake(100, 80)];
    [self.shapes addObject:s2];    
    Shape *s3=[Shape shapeWithCGPoint:CGPointMake(310, 310) p2:CGPointMake(300, 180) p3:CGPointMake(500, 200)];
    [self.shapes addObject:s3];  
    
    Shape *text=[Shape shapeWithString:@"中文aaa" CGPoint:CGPointMake(70,30)];
    [self.shapes addObject:text];  
    
    NSValue *p1=[NSValue valueWithCGPoint:CGPointMake(400, 400)];
    NSValue *p2=[NSValue valueWithCGPoint:CGPointMake(420, 500)];
    NSValue *p3=[NSValue valueWithCGPoint:CGPointMake(500, 410)];
    NSValue *p4=[NSValue valueWithCGPoint:CGPointMake(600, 600)];
    NSValue *p5=[NSValue valueWithCGPoint:CGPointMake(400, 490)];
    
    NSArray *array = [NSArray arrayWithObjects:p1,p2,p3,p4,p5, nil];
    Shape *ploy=[Shape shapeWithArray:array];
    [self.shapes addObject:ploy];  
}

-(void)awakeFromNib{
    [self initData];
}
- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self initData];
        
        self.backgroundColor = [UIColor blackColor];
        
        imageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:imageView];

        drawView = [[DrawView alloc] initWithFrame:frame];
        drawView.shapes = self.shapes;
        [self addSubview:drawView];
        
        UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];  
        [pinchRecognizer setDelegate:self];  
        [self addGestureRecognizer:pinchRecognizer];
    }
    return self;
}

- (void)setImage:(UIImage *)newImage 
{
    [imageView setImage:newImage];
    CGFloat x= (self.frame.size.width-newImage.size.width)/2;
    CGFloat y= (self.frame.size.height-newImage.size.height)/2;
    imageView.frame = CGRectMake( x , y , newImage.size.width, newImage.size.height);
}

- (Shape *)findShap:(CGPoint)point
{
    for (Shape *shape in self.shapes) {
        if ([shape containsViewPoint:point]) {
            return shape;
        }
    }
    return nil;
}
//- (void)layoutSubviews{
//}

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
        }else{
            CGRect rect=imageView.frame;
            imageView.frame = CGRectMake(rect.origin.x+xOffset, rect.origin.y+yOffset, rect.size.width, rect.size.height);
//            CGAffineTransform currentTransform = imageView.transform;
//            CGAffineTransform newTransform = CGAffineTransformTranslate(currentTransform, xOffset, yOffset);
//            [imageView setTransform:newTransform];
            for (Shape *shape in self.shapes) {
                [shape transformWithX:xOffset y:yOffset];
            }
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
