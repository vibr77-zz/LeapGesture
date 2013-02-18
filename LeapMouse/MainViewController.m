//
//  MainViewController.m
//  SampleObjectiveC
//
//  Created by Vincent Besson on 13/02/13.
//  Copyright (c) 2013 Leap Motion. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
@interface MainViewController ()

@end

@implementation MainViewController
@synthesize txt1;
@synthesize imgdraw;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}
- (void)awakeFromNib{
    NSDate *now;
    now = [NSDate date];
   // [txt1 setObjectValue:now];
    AppDelegate *ad = (AppDelegate*)[NSApplication sharedApplication].delegate;
    ad.viewController=self;
 
    NSString * tmp=[[NSString alloc] initWithFormat:@"Coordinates :"];
     [txt1 setObjectValue:tmp];
	
}

-(void)SetImg:(NSImage*)Img{
    
    [imgdraw setImage:Img];

    
}
-(void) GetNewFingerPosition:(LeapVector*)Pos{
    
    //NSLog(@"hey hey hey");
    NSString * tmp=[[NSString alloc] initWithFormat:@"Coordinates :\nx: %.2f\ny: %.2f\nz:%.2f",Pos.x,Pos.y,Pos.z];
    [txt1 setObjectValue:tmp];
   // [tmp release];
    
}
@end
