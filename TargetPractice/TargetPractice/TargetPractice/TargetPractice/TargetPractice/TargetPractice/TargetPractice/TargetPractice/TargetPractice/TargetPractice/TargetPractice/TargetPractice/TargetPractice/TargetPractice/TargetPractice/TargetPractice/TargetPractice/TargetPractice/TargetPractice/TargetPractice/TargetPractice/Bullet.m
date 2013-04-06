//
//  Bullet.m
//  TargetPractice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Bullet.h"



@implementation Bullet

@synthesize bulletSprite;
@synthesize bouncing;

+(id) createBullet:(NSString*)baseImage {
    return [[[self alloc] initWithOurOwnProperties:(NSString*)baseImage] autorelease];
}

-(id) initWithOurOwnProperties:(NSString*)baseImage {
    if(self = [super init]) {
        
        counter = 10;
        bouncing = NO;
        theBaseImage = baseImage;
        bulletSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", theBaseImage]];
        [self addChild:bulletSprite];
        
        bulletSprite.position = ccp(0, 0);
        
        [self schedule:@selector(moveBulletUp:) interval:1.0f/60.0f];
    }
    return self;
}

-(void) moveBulletUp:(ccTime)Delta  {
    
    self.position = ccp(self.position.x, self.position.y + 20);

    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    if(self.position.y > screenSize.height + bulletSprite.contentSize.height/2)   {
        [self unschedule:_cmd];
        [self removeFromParentAndCleanup:YES];
    }
}

-(void) startToMoveBulletDown   {
    // randomize bounce movement
    [self startToMoveBulletDownWithBounceRatio:(CCRANDOM_0_1()*2)-1];
}

-(void) startToMoveBulletDownWithBounceRatio:(float)bounceRatio    {
    [self unschedule:@selector(moveBulletUp:)];
    [self schedule:@selector(moveBulletDown:) interval:1.0f / 60.0f];
    
    bounceAddX = (int)(bounceRatio*16);
    bounceAddY = (arc4random() % 16) + 16;
    
    bouncing = YES;
}

-(void) moveBulletDown:(ccTime)delta  {

    self.position = ccp(self.position.x + bounceAddX, self.position.y - (bounceAddY));
    
    counter--;
    
    if(counter <= 0)    {
        [self unschedule:_cmd];
        // probably do not need the cleanup, since it would only be cleaning up the above command
        // or I could remove the above command, but goot to show it both ways
        [self removeFromParentAndCleanup:YES];
    }
    
}

@end
