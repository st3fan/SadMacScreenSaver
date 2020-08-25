// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

@import ScreenSaver;
@import SpriteKit;

#import "SadMacScene.h"
#import "SadMacView.h"

@interface MySKView: SKView {
}
@end

@implementation MySKView
-(BOOL)acceptsFirstResponder {
    return NO;
}
@end

@implementation SadMacView

@synthesize sceneView;
@synthesize scene;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    if (self = [super initWithFrame:frame isPreview:isPreview]) {
        if (frame.size.width < 400) {
            // This is a bit hacky but it works ...
            NSTextField *textField = [[NSTextField alloc] initWithFrame: NSMakeRect(0, (self.bounds.size.height-70)/2, self.bounds.size.width, 70)];
            [textField setTextColor: NSColor.whiteColor];
            [textField setStringValue:@"Sad Mac 1.3\nStefan Arentz, August 2020\ngithub.com/st3fan/SadMacScreenSaver"];
            [textField setBezeled:NO];
            [textField setDrawsBackground:NO];
            [textField setEditable:NO];
            [textField setSelectable:NO];
            [textField setAlignment: NSTextAlignmentCenter];
            [textField setUsesSingleLineMode: NO];
            [self addSubview:textField];
        } else {
            self.sceneView = [[MySKView alloc] initWithFrame: self.bounds];
            self.sceneView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            [self addSubview: self.sceneView];
            self.scene = [[SadMacScene alloc] initWithSize: self.frame.size isPreview: isPreview];
            [self.sceneView presentScene: self.scene];
        }
    }
    return self;
}

- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

- (void)keyDown:(NSEvent *)event {
    // This is nice for running from Xcode - it is otherwise hard to kill the saver.
    if ([[event charactersIgnoringModifiers] isEqualToString: @"q"]) {
        exit(0);
    }
    [super keyDown: event];
}

@end
