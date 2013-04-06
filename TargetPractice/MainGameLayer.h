//
//  MainGame.h
//  TargetPractice
//
//  Created by Ezra Paulekas on 4/4/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Player.h"
#import "Bullet.h"
#import "SimpleAudioEngine.h"

@interface MainGameLayer : CCLayer {
    
    // custon classes
    Player *thePlayer;
    
    // CCSprites
//    CCSprite *theTarget;
//    CCSprite *thePoints;
    CCSprite *theBackground;
    
    // lebels
    CCLabelBMFont *scoreLabel;
    int score;
    
    // media
    SimpleAudioEngine *sae;
    
    // floats
    float bulletRatio;
    
    // bools
    
    // chars
    signed char moveVar;    // range of -128 to 128
//  unsigned char moveVar;  // range of 0 to 255
    
    // ints
    int screenWidth;
    int screenHeight;
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
-(BOOL) checkCollisionWithBullsEye:(CGPoint)bulletPointToCheck;
-(BOOL) checkCollisionWithEntireTarget:(CGPoint)bulletPointToCheck;
-(void) addToScore:(int) amountToAdd;

@end
