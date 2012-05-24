//
//  FaceDraw.h
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Shape.h"
#import "DrawView.h"

@interface FaceDraw : UIView <UIGestureRecognizerDelegate>{
    Shape *currentShape;
    UIImageView *imageView;
    DrawView *drawView;
}
@property (strong,nonatomic) NSMutableArray *shapes;
@property (strong,nonatomic) UIImageView *imageView;

- (void)setImage:(UIImage *)newImage;
@end
