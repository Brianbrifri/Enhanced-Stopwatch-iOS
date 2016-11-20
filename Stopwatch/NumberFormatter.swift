//
//  NumberFormatter.swift
//  Stopwatch
//
//  Created by vm mac on 11/18/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import Foundation

//Put the number formatter here because multiple files need this function
func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
    let minutes = (Int(time) / 60) % 60
    let seconds = Int(time) % 60
    let milliSeconds = Int(time * 100) % 100
    return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
}
