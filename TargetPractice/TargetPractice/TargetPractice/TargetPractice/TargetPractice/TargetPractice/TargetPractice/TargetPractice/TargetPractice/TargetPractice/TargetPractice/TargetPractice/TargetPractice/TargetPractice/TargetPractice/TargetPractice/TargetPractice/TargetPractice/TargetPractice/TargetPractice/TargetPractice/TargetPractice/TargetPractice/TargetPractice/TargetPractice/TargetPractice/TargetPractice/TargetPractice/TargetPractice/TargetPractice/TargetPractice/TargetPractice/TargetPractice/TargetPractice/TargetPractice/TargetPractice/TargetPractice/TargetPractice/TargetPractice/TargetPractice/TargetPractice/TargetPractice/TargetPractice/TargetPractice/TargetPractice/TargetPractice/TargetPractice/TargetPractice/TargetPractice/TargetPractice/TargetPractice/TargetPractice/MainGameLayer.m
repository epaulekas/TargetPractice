//
//  MainGame.m
//  TargetPeactice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "MainGameLayer.h"

@implementation MainGameLayer
// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MainGameLayer *layer = [MainGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
        self.isTouchEnabled = true;
        
        moveVar = 3;
        
        sae = [SimpleAudioEngine sharedEngine];
        
        screenWidth = [[CCDirector sharedDirector] winSize].width;
        screenHeight = [[CCDirector sharedDirector] winSize].height;
        
        theBackground = [CCSprite spriteWithFile:@"background.png"];
        theBackground.position = ccp(screenWidth/2, screenHeight/2);
        [self addChild:theBackground z:-10];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"pxl.fnt"];
        scoreLabel.position = ccp(screenWidth *.9, 20);
        [self addChild:scoreLabel z:100];
        
        thePlayer = [Player createPlayer:@"dude"];
        [self addChild:thePlayer z:10];
        thePlayer.position = ccp(screenWidth / 2, thePlayer.height);
        
        theTarget = [CCSprite spriteWithFile:@"target.png"];
        [self addChild:theTarget];
        theTarget.position = ccp( screenWidth/2, screenHeight - (theTarget.contentSize.height /2));
        
        [self schedule:@selector(automaticFire:) interval:60.0f / 60.0f];
        [self schedule:@selector(mainGameLoop:) interval:1.0f / 60.0f];
	}
	return self;
}

-(void) mainGameLoop:(ccTime)delta    {
    // positioning / moving the target
    theTarget.position = ccp(theTarget.position.x + moveVar, theTarget.position.y);
    
    if(theTarget.position.x > screenWidth)  {
        theTarget.position = ccp(screenWidth, theTarget.position.y);
        moveVar *= -1;
    }
    else if(theTarget.position.x < 0)  {
        theTarget.position = ccp(0, theTarget.position.y);
        moveVar *= -1;
    }
    
    // collision detection for the bullet and the target
    // we are going to cycle through every child and find out who is a bullet
    
    for(Bullet *someBullet in self.children)    {
        if([someBullet isKindOfClass:[Bullet class]]) {
            
            if(!someBullet.bouncing)    {
                CGPoint bulletPoint = ccp (someBullet.position.x, someBullet.position.y);
                
                if([self checkCollisionWithBullsEye:bulletPoint])   {
                    thePoints = [CCSprite spriteWithFile:@"points.png"];
                    [self addChild:thePoints z:30];
                    thePoints.position = ccp(someBullet.position.x, screenHeight - (thePoints.contentSize.height));
                    
                    [self schedule:@selector(getRidOfPointsSign:) interval:0.4f];
                    
                    
                    [self removeChild:someBullet cleanup:YES];
                    [self addToScore:10];
                }
                else if([self checkCollisionWithEntireTarget:bulletPoint])   {
                    [someBullet startToMoveBulletDownWithBounceRatio:bulletRatio];
                    [self addToScore:1];
                }
            }
        }
    }
}


-(void) getRidOfPointsSign:(ccTime)delta    {
    [self removeChild:thePoints cleanup:NO];
    [self unschedule:_cmd];
}


-(void) addToScore:(int) amountToAdd    {
    score += amountToAdd;
    
    NSString *scoreString = [NSString stringWithFormat:@"%i", score];
    [scoreLabel setString:scoreString];
}


-(BOOL) checkCollisionWithEntireTarget:(CGPoint)bulletPointToCheck {
    
    float maxCollisionDistance  = theTarget.contentSize.width/2;
    
    CGPoint checkPoint = ccp(theTarget.position.x, theTarget.position.y);
    
    if(bulletPointToCheck.x > (checkPoint.x - maxCollisionDistance) &&
       bulletPointToCheck.x < (checkPoint.x + maxCollisionDistance) &&
       bulletPointToCheck.y > checkPoint.y &&
       bulletPointToCheck.y < (checkPoint.y + (maxCollisionDistance/2)))    {
        
        bulletRatio = (bulletPointToCheck.x - checkPoint.x)/maxCollisionDistance;
        
        return YES;
    }
    else    {
        return NO;
    }
}


-(BOOL) checkCollisionWithBullsEye:(CGPoint)bulletPointToCheck {
    
    float maxCollisionDistance  = 20;
    CGPoint checkPoint = ccp(theTarget.position.x, theTarget.position.y);
    
    float distanceBetween = ccpDistance(bulletPointToCheck, checkPoint);
    
    if(distanceBetween <= maxCollisionDistance) {
        return YES;
    }
    else    {
        return NO;
    }
}


-(void) automaticFire:(ccTime)delta      {

    [thePlayer setupFireAnimation];
    Bullet *theBullet = [Bullet createBullet:@"round"];
    [self addChild:theBullet z:1];
    theBullet.position = ccp(thePlayer.position.x, thePlayer.position.y + thePlayer.height);
    [sae playEffect:@"gunshot.caf"];
    [self schedule:@selector(playShellSound:) interval:0.2];
    
}


-(void) playShellSound:(ccTime) delta   {
    [sae playEffect:@"shell_drop.caf"];
    [self unschedule:_cmd];
}


-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    thePlayer.position = ccp(location.x, thePlayer.position.y);
}

-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event  {
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    thePlayer.position = ccp(location.x, thePlayer.position.y);
    
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
