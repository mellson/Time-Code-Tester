//
//  MIDI.h
//  MTC Prototype
//
//  Created by Anders Bech Mellson on 01/02/15.
//  Copyright (c) 2015 dk.mellson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMIDI/CoreMIDI.h>

@interface MIDI : NSObject

+ (void)setup:(void (^)(NSData *))printer;

@end
