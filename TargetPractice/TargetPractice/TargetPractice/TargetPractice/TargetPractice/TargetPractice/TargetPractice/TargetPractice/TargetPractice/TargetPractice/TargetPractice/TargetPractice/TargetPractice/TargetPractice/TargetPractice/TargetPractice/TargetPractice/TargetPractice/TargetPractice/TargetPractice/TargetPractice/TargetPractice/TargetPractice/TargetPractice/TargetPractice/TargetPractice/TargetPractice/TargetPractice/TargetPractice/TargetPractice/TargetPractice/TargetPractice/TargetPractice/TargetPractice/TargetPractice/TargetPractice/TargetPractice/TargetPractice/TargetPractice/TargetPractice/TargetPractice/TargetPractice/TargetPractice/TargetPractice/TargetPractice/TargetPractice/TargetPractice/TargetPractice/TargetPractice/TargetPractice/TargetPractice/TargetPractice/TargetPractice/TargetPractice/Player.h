//
//  Player.h
//  TargetPractice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCNode {
    
    NSString *theBaseImage;
    CCSprite *playerSprite;
    int currentFrame;
    int framesToAnimate;
    NSString *theAction;
}

+(id) createPlayer:(NSString*)baseImage;
-(id) initWithOurOwnProperties:(NSString*)baseImage;
-(void)setupDefaultAnimation;
-(void)setupFireAnimation;

-(int)width;
-(int)height;


@end
