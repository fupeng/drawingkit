//
//  ViewController.h
//  testpath
//
//  Created by Peng Fu on 12-4-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceDraw.h"
@interface ViewController : UIViewController <UIScrollViewDelegate>{
    FaceDraw *drawView;
}
@property (nonatomic,strong) FaceDraw *drawView;

@end
