//
//  MIDI.m
//  MTC Prototype
//
//  Created by Anders Bech Mellson on 01/02/15.
//  Copyright (c) 2015 dk.mellson. All rights reserved.
//

#import "MIDI.h"

@implementation MIDI

MIDIClientRef midiClient;
MIDIEndpointRef midiIn;
OSStatus status;
void (^blockPrinter)(NSData *);

void midiInputCallback(const MIDIPacketList *list, void *procRef, void *srcRef) {
    for (UInt32 i = 0; i < list->numPackets; i++) {
        const MIDIPacket *packet = &list->packet[i];
        NSData *data = [NSData dataWithBytes:packet->data length:2];
        blockPrinter(data);
    }
}

+ (void)setup:(void (^)(NSData *))printer {
    status = MIDIClientCreate(CFSTR("MIDI client"), NULL, NULL, &midiClient);
    NSCAssert(status == noErr, @"Error creating MIDI client: %d", status);

    status = MIDIDestinationCreate(midiClient, CFSTR("Mellson Midi"), midiInputCallback, NULL, &midiIn);
    NSCAssert(status == noErr, @"Error creating MIDI destination: %d", status);
    blockPrinter = printer;
}


@end
