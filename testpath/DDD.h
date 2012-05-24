//
//  DDD.h
//  testpath
//
//  Created by Peng Fu on 12-5-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawView.h"
#import "Shape.h"

@interface DDD : UIView{
    UIImageView *imageView;
    DrawView *drawView;
    NSMutableArray *shapes;
    
    Shape *currentShape;
    CGPoint oldDragLocation;
}

@end
