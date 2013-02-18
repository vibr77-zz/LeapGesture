/******************************************************************************\
 * Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
 * Leap Motion proprietary and confidential. Not for distribution.              *
 * Use subject to the terms of the Leap Motion SDK Agreement available at       *
 * https://developer.leapmotion.com/sdk_agreement, or another agreement         *
 * between Leap Motion and you, your company or other organization.             *
 \******************************************************************************/

#import "Sample.h"


#import "AppDelegate.h"

@implementation Sample
@synthesize delegate;


- (void)run
{
    controller = [[LeapController alloc] init];
    [controller addDelegate:self];
    NSLog(@"running");
    
    flagGestureBegin=false;
    flagGestureEnd=false;
    clicflag=false;
    
}

#pragma mark - SampleDelegate Callbacks

- (void)onInit:(LeapController *)aController
{
    NSLog(@"Initialized");
    NSRect screenBound = [[NSScreen mainScreen] frame];
    NSSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    ii=0;
    
    NSLog(@"Screen size (%f,%f)",screenWidth,screenHeight);
    
    recognizer = [[GLGestureRecognizer alloc] init];
	NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"gesture" ofType:@"json"]];
    
	BOOL ok;
	NSError *error;
	ok = [recognizer loadTemplatesFromJsonData:jsonData error:&error];
	if (!ok){
		NSLog(@"Error loading gestures: %@", error);
		
		return;
	}
    
    p_xx=0;
    p_yy=0;
    p_zz=0;
    pp_xx=0;
    pp_yy=0;
    pp_zz=0;
    
    kMinDist=1,2; // Under 1 not working
    flagGestureBegin=false;
    no_move_count_trigger=0;

}

- (void)onConnect:(LeapController *)aController
{
    NSLog(@"Connected");
}

- (void)onDisconnect:(LeapController *)aController
{
    NSLog(@"Disconnected");
}

- (void)onExit:(LeapController *)aController
{
    NSLog(@"Exited");
}

- (void)onFrame:(LeapController *)aController
{
    
    // Get the most recent frame and report some basic information
    LeapFrame *frame = [aController frame:0];
    /*
     NSLog(@"Frame id: %lld, timestamp: %lld, hands: %ld, fingers: %ld, tools: %ld",
     [frame id], [frame timestamp], [[frame hands] count],
     [[frame fingers] count], [[frame tools] count]);
     */
    // NSLog(@"Here");
    NSArray *fingers=nil;
   
    if ([[frame hands] count] != 0) {
        
        LeapHand *hand = [[frame hands] objectAtIndex:0];
        fingers = [hand fingers];
        
        if (fingers!=nil && [fingers count] >= 1) {
            
            LeapVector *avgPos = [[LeapVector alloc] init];
            LeapVector *avgVelocity = [[LeapVector alloc] init];
            
           
            
            
            for (int i = 0; i < [fingers count]; i++) {
                LeapFinger *finger = [fingers objectAtIndex:i];
                
                avgPos = [avgPos plus:[finger tipPosition]];
                avgVelocity = [avgVelocity plus:[finger tipVelocity]];
            }
            
            avgPos = [avgPos divide:[fingers count]];
            avgVelocity = [avgVelocity divide:[fingers count]];
            
            xx=[avgPos x];
            yy=[avgPos y];
            zz=[avgPos z];
            
 
            
            // NSLog(@"Speed TE %.5f ",-( [ ptoday timeIntervalSinceNow]));
            
            if ((zz<=0) && (fabs(xx-p_xx)>kMinDist ||
                            fabs(yy-p_yy)>kMinDist ||
                            fabs(zz-p_zz)>kMinDist)){ // Remove Fuzzy
                
                no_move_count_trigger=0;
                
                if (flagGestureBegin==false){
                    [recognizer resetTouches];
                    flagGestureBegin=true;
                }
                
               
                
                 if (delegate && [delegate respondsToSelector:@selector(GetNewFingerPosition:)])
                  [delegate performSelector:@selector(GetNewFingerPosition:) withObject:avgPos];
                // else= [NSDate date];
                
                
                //ptoday = [NSDate date];         //  NSLog(@"FAILED TO ANSWER DELEGATE");
                
                p_xx=xx;
                p_yy=yy;
                p_zz=zz;
                
                if (xx<-90)
                    xx=-90;
                else if (xx>90)
                    xx=90;
                
                if (yy>240)
                    yy=240;
                else
                    yy=yy-80;
                
                if (yy<0)
                    yy=0;
                
                float x=(screenWidth/2)+(xx/90)*(screenWidth/2);
                float y=screenHeight-(yy/160)*(screenHeight);
                
                if (y<0)
                    y=0;
                
                
                [recognizer addTouchAtPoint:CGPointMake((int)x,-(int)y)] ;
                
                CGEventRef move1 = CGEventCreateMouseEvent(
                                                           NULL, kCGEventMouseMoved,
                                                           CGPointMake((int)x,(int)y),
                                                           kCGMouseButtonLeft // ignored
                                                           );
                /*
                 Click Management
                 if (clicflag==false && zz<0)
                 clicflag=true;
                 if (clicflag==true && zz>0){
                 [self doubleClick:2 point:CGPointMake((int)x,(int)y)];
                 clicflag=false;
                 
                 }
                */
                CGEventPost(kCGHIDEventTap, move1);
                
            }else{
                // NSLog(@"Bad Friend");
                no_move_count_trigger++;
                
                if (flagGestureBegin ==true && [recognizer CountTouchAtPoint]>50 && no_move_count_trigger>50){
                    
                    no_move_count_trigger=0;
                    flagGestureBegin=false;
                    [self processGestureData];
                    NSLog(@"End processing gesture %ld",[recognizer CountTouchAtPoint]);
                    NSLog(@"Finger Gesture =%ld",(unsigned long)[fingers count]);
                    // Now try to nicley output this to screen
                    NSImage * theImage = [[NSImage alloc] initWithSize:NSMakeSize(400, 400)];
                    [theImage lockFocus];
                    int iii;
                    for (iii=0;iii<([recognizer.resampledPoints count]-1);iii++){
                        CGPoint P1=[[recognizer.resampledPoints objectAtIndex:iii] pointValue];
                        CGPoint P2=[[recognizer.resampledPoints objectAtIndex:(iii+1)] pointValue];
                       
                        CGPoint P3;
                        CGPoint P4;
                        int scale=180;
                        
                        P3.x=200+P1.x*scale;
                        P3.y=200+P1.y*scale;
                        P4.x=200+P2.x*scale;
                        P4.y=200+P2.y*scale;
                        [NSBezierPath strokeLineFromPoint:P3 toPoint:P4];
                        //NSLog(@"%f %f %f %f",P3.x,P3.y,P4.x,P4.y);
                        
                    }


                    [theImage unlockFocus];
                    [delegate SetImg:theImage];
                    
                    [recognizer resetTouches];
                }else if ([recognizer CountTouchAtPoint]<50 && flagGestureBegin ==true && no_move_count_trigger>50){
                    flagGestureBegin=false;
                    no_move_count_trigger=0;
                    [recognizer resetTouches];
                    
                }
                
                // NSLog("No Relative Move");
                
                
                
            }
        }
        // Get the hand's sphere radius and palm position
        /*
         NSLog(@"Hand sphere radius: %f mm, palm position: %@",
         [hand sphereRadius], [hand palmPosition]);
         */
        
        // Get the hand's normal vector and direction
        //const LeapVector *normal = [hand palmNormal];
        //const LeapVector *direction = [hand direction];
        
        // Calculate the hand's pitch, roll, and yaw angles
        /*
         NSLog(@"Hand pitch: %f degrees, roll: %f degrees, yaw: %f degrees\n",
         [direction pitch] * LEAP_RAD_TO_DEG,
         [normal roll] * LEAP_RAD_TO_DEG,
         [direction yaw] * LEAP_RAD_TO_DEG);
         */
    }
}

- (void)processGestureData{
	NSString *gestureName = [recognizer findBestMatchCenter:&center angle:&angle score:&score];
	//self.caption = [NSString stringWithFormat:@"%@ (%0.2f, %d)", gestureName, score, (int)(360.0f*angle/(2.0f*M_PI))];
    NSLog(@"%@ (%0.2f, %d)", gestureName, score, (int)(360.0f*angle/(2.0f*M_PI)));
}



-(void )doubleClick:(int) clickCount point:(CGPoint) point {
    CGEventRef theEvent = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, point, kCGMouseButtonLeft);
    CGEventSetIntegerValueField(theEvent, kCGMouseEventClickState, clickCount);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseDown);
    CGEventPost(kCGHIDEventTap, theEvent);
    CGEventSetType(theEvent, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, theEvent);
    CFRelease(theEvent);
    
    
}
@end
