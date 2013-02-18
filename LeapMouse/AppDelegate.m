/******************************************************************************\
* Copyright (C) 2012-2013 Leap Motion, Inc. All rights reserved.               *
* Leap Motion proprietary and confidential. Not for distribution.              *
* Use subject to the terms of the Leap Motion SDK Agreement available at       *
* https://developer.leapmotion.com/sdk_agreement, or another agreement         *
* between Leap Motion and you, your company or other organization.             *
\******************************************************************************/

#import "AppDelegate.h"
#import "Sample.h"
#import "MainViewController.h"

@implementation AppDelegate
@synthesize viewController;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
  
      
    viewController=[[MainViewController alloc] initWithNibName:@"Mainview" bundle:[NSBundle mainBundle]];

    [self.window.contentView addSubview:viewController.view];
    
    
    Sample *sample = [[Sample alloc]init];
    [sample run];
    
    [sample setDelegate:viewController];
    
}

@end
