//
//  FaceDraw.h
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DrawView.h"
#import "Shape.h"

@implementation DrawView
@synthesize shapes;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setOpaque:NO];
        [self setUserInteractionEnabled:NO];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    for (Shape *shape in self.shapes) {
        [shape drawInContext:UIGraphicsGetCurrentContext()];
    }
}

@end