//
//  AnalogViewController.swift
//  Stopwatch
//
//  Created by vm mac on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogViewController: UIViewController {

    let analogView = AnalogView()
    
    @IBOutlet weak var digitalTime: UILabel!
    @IBOutlet weak var clockView: ClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockView.addSubview(analogView)
      
        //Send analog view to back so the digital timer shows up
        clockView.sendSubview(toBack: analogView)

    }

}

//Mark: - StopwatchModelDelegate protocol functions
extension AnalogViewController: StopwatchModelDelegate {
    func timerUpdated(with timestamp: TimeInterval) {
        analogView.rotateMainHand(with: timestamp)
        let value = formatTimeIntervalToString(timestamp)

        digitalTime?.text = "\(value.minutes):\(value.seconds).\(value.milliseconds)"
    }
    
    func lapUpdated(with timestamp: TimeInterval) {
        analogView.rotateLapHand(with: timestamp)
    }
    
    func resetDefaults() {
        analogView.resetDefaults()

        digitalTime?.text = "00:00.00"
    }
}
