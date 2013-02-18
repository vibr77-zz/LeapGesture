//
//  MainViewController.h
//  SampleObjectiveC
//
//  Created by Vincent Besson on 13/02/13.
//  Copyright (c) 2013 Leap Motion. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sample.h"
#import "LeapObjectiveC.h"

@interface MainViewController : NSViewController<LeapWrapperDelegate>{
    
    IBOutlet NSTextField *textField;
    IBOutlet NSTextField *txt1;
    IBOutlet NSImageView *imgdraw;
}

-(void) GetNewFingerPosition:(LeapVector*)Pos;
-(void)SetImg:(NSImage*)Img;
@property (retain) IBOutlet NSTextField *txt1;
@property (retain) IBOutlet NSImageView *imgdraw;
@end
