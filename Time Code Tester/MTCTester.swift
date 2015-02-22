//
//  MTCTester.swift
//  Time Code Tester
//
//  Created by Anders Bech Mellson on 22/02/15.
//  Copyright (c) 2015 dk.mellson. All rights reserved.
//

import Foundation
import CoreMIDI

class MTCTester {
    let textUpdater: (String, String) -> ()
    
    init(updateText: (String, String) -> ()) {
        textUpdater = updateText
        MIDI.setup { data -> Void in
            self.handleMidiData(data)
        }
    }
    
    func now() {
        return
    }
    
    var largestOffset = 0.0
    let expectedWait: UInt64 = 10000000 // the number of ns to wait for a quarter frame in 25 fps
    var lastTimeStamp: UInt64 = 0
    
    // example msg <f10f>
    func handleMidiData(data: NSData) {
        var msg: NSString = "\(data)"
        msg = msg.substringWithRange(NSMakeRange(1,4))
        
        // Only do something if we are receiving MTC
        if msg.hasPrefix("f1") {
            let currentTime = mach_absolute_time()
            if lastTimeStamp == 0 {
                lastTimeStamp = currentTime
            } else {
                let elapsedTime = currentTime - lastTimeStamp
                var behind = true
                var offset: UInt64 = 0
                if elapsedTime > expectedWait {
                    offset = elapsedTime - expectedWait
                } else {
                    offset = expectedWait - elapsedTime
                    behind = false
                }
                let offsetPercent = (Double(offset) / Double(expectedWait)) * 100.0
                let sign = behind ? "-" : "+" // - means we are behind, + ahead
                let offsetString = "\(sign)\(offsetPercent)%"
                largestOffset = offsetPercent > largestOffset ? offsetPercent : largestOffset
                lastTimeStamp = currentTime
                textUpdater(offsetString, "\(largestOffset)%")
            }
        }
    }
}