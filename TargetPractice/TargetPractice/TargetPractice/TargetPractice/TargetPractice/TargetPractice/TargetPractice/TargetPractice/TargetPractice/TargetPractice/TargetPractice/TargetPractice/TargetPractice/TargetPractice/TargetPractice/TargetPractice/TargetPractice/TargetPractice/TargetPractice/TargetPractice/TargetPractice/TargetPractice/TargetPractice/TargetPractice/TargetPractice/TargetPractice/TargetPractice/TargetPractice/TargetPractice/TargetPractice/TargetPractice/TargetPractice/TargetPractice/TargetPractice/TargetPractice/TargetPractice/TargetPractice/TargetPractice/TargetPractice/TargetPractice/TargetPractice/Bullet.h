//
//  Bullet.h
//  TargetPractice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Bullet : CCNode {
    NSString *theBaseImage;
    CCSprite *bulletSprite;
    int counter;
    int bounceAddX;
    int bounceAddY;
    BOOL bouncing;
}

@property (readonly, nonatomic) CCSprite* bulletSprite;
@property (readonly, nonatomic) BOOL bouncing;

+(id) createBullet:(NSString*)baseImage;
-(id) initWithOurOwnProperties:(NSString*)baseImage;
-(void) startToMoveBulletDown;
-(void) startToMoveBulletDownWithBounceRatio:(float)bounceRatio;

@end
