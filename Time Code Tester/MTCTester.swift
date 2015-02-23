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
    
    var counter = 0 // We want to update the display every second, each iteration is 10 ms so the counter needs to go to 100 and then reset
    var accumulatedOffset = 0.0
    var largestOffset = 0.0
    let expectedWait: UInt64 = 10000000 // the number of ns to wait for a quarter frame in 25 fps
    var lastTimeStamp: UInt64 = 0
    
    func nsToMs(ns: UInt64) -> Double {
        return Double(ns) / 1000000.0
    }
    
    func doubleToString(value: Double) -> String {
        return String(format: "%.5f", value)
    }
    
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
                            9961724
                if offset > 1000000 {
                    println("\(msg) - \(offset)")
                }
                
                
                let offsetPercent = nsToMs(offset)
                let decimalOffset = behind ? -1 * offsetPercent : offsetPercent
                largestOffset = offsetPercent > largestOffset ? offsetPercent : largestOffset
                lastTimeStamp = currentTime
                accumulatedOffset += decimalOffset
                if counter++ == 100 {
                    let averageOffset = accumulatedOffset / 100
                    let sign = averageOffset < 0 ? "" : "+"
                    let offsetString = doubleToString(averageOffset)
                    let offsetText = "\(sign)\(offsetString) ms"
                    textUpdater(offsetText, "\(largestOffset) ms")
                    counter = 0
                    accumulatedOffset = 0
                }
            }
        }
    }
}