//
//  Player.m
//  TargetPractice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

+(id) createPlayer:(NSString*)baseImage {
    return [[[self alloc] initWithOurOwnProperties:(NSString*)baseImage] autorelease];
}

-(id) initWithOurOwnProperties:(NSString*)baseImage {
    if(self = [super init]) {
        
        theBaseImage = baseImage;
        playerSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@.png", theBaseImage]];
        [self addChild:playerSprite];
        
        playerSprite.position = ccp(0, 0);
        
        [self setupDefaultAnimation];
        [self schedule:@selector(runPlayerAnimationSequence:) interval:1.0f/60.0f];
    }
    return self;
}

-(int)width {
    return playerSprite.contentSize.height;
}

-(int)height    {
    return playerSprite.contentSize.width;
}

-(void) setupDefaultAnimation   {
    currentFrame = 0;
    framesToAnimate = 20;
    theAction = @"default";
}

-(void) setupFireAnimation   {
    currentFrame = 0;
    framesToAnimate = 11;
    theAction = @"fire";
}

-(void) runPlayerAnimationSequence:(ccTime) delta   {
    // increment frame
    currentFrame++;
    
    // add leading zeros
    NSString *frameString = [NSString stringWithFormat:@"%i", currentFrame];
    
    while(frameString.length < 4)   {
        frameString = [NSString stringWithFormat:@"0%@",frameString];
    }
    
    // retexture the sprite
    [playerSprite setTexture:[[CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@%@.png", theBaseImage, theAction, frameString]] texture]];
    
    // at end of sequence reset to default action
    if(currentFrame == framesToAnimate) {
        [self setupDefaultAnimation];
    }
}

@end