/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import <Foundation/Foundation.h>
#import "LeapObjectiveC.h"
#import "GLGestureRecognizer.h"
#import "GLGestureRecognizer+JSONTemplates.h"
@protocol LeapWrapperDelegate <NSObject>

-(void) GetNewFingerPosition:(LeapVector*)Pos;
-(void)SetImg:(NSImage*)Img;
@end

@interface Sample : NSObject<LeapDelegate>{
    id <LeapWrapperDelegate> delegate;
    LeapController *controller;
    CGFloat screenWidth;
    CGFloat screenHeight;
    Boolean clicflag;
    Boolean flagGestureBegin;
    Boolean flagGestureEnd;
    int ii;
    
    float p_xx,p_yy,p_zz; // Previous finger position;
    float pp_xx,pp_yy,pp_zz;
    float xx,yy,zz;
    float kMinDist; // Min distance in
    
    float  delta_x;
    float  delta_y;
    float  delta_z;
    NSDate *ptoday;
    int no_move_count_trigger;
    
    //const LeapVector * avgPos;
    
    /* GL Gesture */
    GLGestureRecognizer *recognizer;
	CGPoint center;
	float score, angle;
    
}


@property (nonatomic,strong) id<LeapWrapperDelegate> delegate;

-(void)run;
-(void )doubleClick:(int)clickCount point:(CGPoint) point;
@end
