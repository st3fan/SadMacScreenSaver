// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@import SpriteKit;

#import "SadMacScene.h"

@implementation SadMacScene

- (id) initWithSize:(CGSize)size isPreview: (BOOL) isPreview {
    if (self = [super initWithSize: size]) {
        _isPreview = isPreview;
    }
    return self;
}

- (SKNode*) createFloor {
    SKSpriteNode *floor = [SKSpriteNode spriteNodeWithColor: [NSColor blackColor] size: CGSizeMake(CGRectGetWidth(self.frame), 2)];
    floor.anchorPoint = CGPointZero;
    floor.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: floor.frame];
    floor.physicsBody.dynamic = YES;
    floor.physicsBody.density = 100.0;
    return floor;
}

CGFloat RandomScaleFactor() {
    int r = random() % 1000;
    if (r > 900) {
        return 0.5;
    } else if (r > 450) {
        return 0.125;
    } else {
        return 0.25;
    }
}

CGFloat RandomAngularVelocity() {
    CGFloat v = -35.0 + (random() % 70);
    return v / 100.0;
}

CGVector RandomVelocity() {
    return CGVectorMake(-250 + (random() % 500), -50 + (random() % 100));
}

- (SKNode*) createSadMacAtPosition: (CGPoint) position {
    NSString *path = [[NSBundle bundleForClass: [self class]] pathForImageResource: @"SadMac"];
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed: path];
    if (node != nil) {
        CGFloat scaleFactor = RandomScaleFactor(_isPreview);
        [node scaleToSize: CGSizeMake(node.size.width * scaleFactor, node.size.height * scaleFactor)];
        node.position = position;
        node.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize: node.size];
        node.physicsBody.dynamic = YES;
        node.physicsBody.restitution = 0.33;
        node.physicsBody.angularDamping = 0.5;
        node.physicsBody.friction = 0.5;
        node.physicsBody.density = 0.5;
        node.physicsBody.angularVelocity = RandomAngularVelocity();
        node.physicsBody.velocity = RandomVelocity();
        node.physicsBody.categoryBitMask = 2;
        node.physicsBody.contactTestBitMask = 1;
    }

    return node;
}

- (void)sceneDidLoad {
    self.backgroundColor = [NSColor blackColor];

    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect: NSInsetRect(self.frame, -400, -400)];
    self.physicsBody.categoryBitMask = 1;
    self.physicsBody.contactTestBitMask =  2;
    self.physicsWorld.contactDelegate = self;

    SKNode *floor = [self createFloor];
    [self addChild: floor];

    NSString *path = [[NSBundle bundleForClass: [self class]] pathForImageResource: @"SadMac"];
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed: path];
    [node scaleToSize: CGSizeMake(node.size.width * 0.25, node.size.height * 0.25)];
    node.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    node.alpha = 0.0;
    [self addChild: node];

    SKAction *fadeInAction = [SKAction fadeAlphaTo: 1.0 duration: 1.5];
    fadeInAction.timingMode = SKActionTimingEaseIn;

    SKAction *scaleUpAction = [SKAction scaleTo: 1.125 duration: 0.25];
    scaleUpAction.timingMode = SKActionTimingEaseOut;

    SKAction *scaleDownAction = [SKAction scaleTo: 0.0 duration: 0.5];
    scaleUpAction.timingMode = SKActionTimingEaseIn;

    SKAction *createSadMacAction = [SKAction runBlock:^{
        CGFloat x = random() % (u_int32_t) CGRectGetWidth(self.frame);
        SKNode *node = [self createSadMacAtPosition: CGPointMake(x, self.size.height + 100)];
        [self addChild: node];
    }];
    SKAction *loopAction = [SKAction sequence: @[[SKAction waitForDuration: 1.0], createSadMacAction]];

    NSArray *actions = @[fadeInAction, [SKAction waitForDuration: 1.0], scaleUpAction, scaleDownAction,
         [SKAction repeatActionForever: loopAction]];
    [node runAction: [SKAction sequence: actions]];
}

- (void)didBeginContact:(SKPhysicsContact *)contact {
    if (contact.bodyA.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 1) {
        [contact.bodyA.node removeFromParent];
    }
    if (contact.bodyB.categoryBitMask == 2 && contact.bodyA.categoryBitMask == 1) {
        [contact.bodyB.node removeFromParent];
    }
}

@end
