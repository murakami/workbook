//
//  AppDelegate.m
//  TextToSpeech
//
//  Created by 村上 幸雄 on 12/02/25.
//  Copyright (c) 2012年 ビッツ有限会社. All rights reserved.
//

#import <AudioUnit/AudioUnit.h>
#import <AudioUnit/AUCocoaUIView.h>
#import <AudioToolbox/AudioToolbox.h>
#import	<CoreAudioKit/CoreAudioKit.h>
#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize auGraph = _auGraph;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    AUNode	inputNode, effectNode, outputNode;
	
	NewAUGraph(&_auGraph);
    
	AudioComponentDescription	cd;
	cd.componentType = kAudioUnitType_Generator;
	cd.componentSubType = kAudioUnitSubType_SpeechSynthesis;
	cd.componentManufacturer = kAudioUnitManufacturer_Apple;
	cd.componentFlags = 0;
	cd.componentFlagsMask = 0;
	
	AUGraphAddNode(_auGraph, &cd, &inputNode);
	
	cd.componentType = kAudioUnitType_Effect;
	cd.componentSubType = kAudioUnitSubType_Delay;
	AUGraphAddNode(_auGraph, &cd, &effectNode);
	
	cd.componentType = kAudioUnitType_Output;
	cd.componentSubType = kAudioUnitSubType_DefaultOutput;
	AUGraphAddNode(_auGraph, &cd, &outputNode);
	
	AUGraphConnectNodeInput(_auGraph, inputNode, 0, effectNode, 0);
	AUGraphConnectNodeInput(_auGraph, effectNode, 0, outputNode, 0);
	
	AUGraphOpen(_auGraph);
	AUGraphInitialize(_auGraph);
    
	AudioUnit	generateAudioUnit;
	AUGraphNodeInfo(_auGraph, inputNode, NULL, &generateAudioUnit);
	SpeechChannel	channel;
	UInt32	sz = sizeof(SpeechChannel);
	AudioUnitGetProperty(generateAudioUnit, kAudioUnitProperty_SpeechChannel,
						 kAudioUnitScope_Global, 0, &channel, &sz);
	
	AUGraphStart(_auGraph);
	
	SpeakCFString(channel, CFSTR("Nice to meet you. It's nice to see you! Nice meeting you. I'm pleased to meet you. Please say hello to your family. I look forward to seeing you again. Yes. Let's get together soon."), NULL);
}

- (void)dealloc
{
    AUGraphStop(_auGraph);
    AUGraphUninitialize(_auGraph);
    AUGraphClose(_auGraph);
    DisposeAUGraph(_auGraph);
}

@end
