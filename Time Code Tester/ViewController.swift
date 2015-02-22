//
//  ViewController.swift
//  Time Code Tester
//
//  Created by Anders Bech Mellson on 22/02/15.
//  Copyright (c) 2015 dk.mellson. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    @IBOutlet var offsetLabel: NSTextField!
    @IBOutlet var largestOffsetField: NSTextField!
    var mtcTester: MTCTester?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtcTester = MTCTester(updateText: updateUI)
        // Do any additional setup after loading the view.
    }
    
    func updateUI(s1: String, s2: String) {
        offsetLabel.stringValue = s1
        largestOffsetField.stringValue = s2
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

