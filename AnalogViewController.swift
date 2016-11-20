//
//  AnalogViewController.swift
//  Stopwatch
//
//  Created by vm mac on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class AnalogViewController: UIViewController {

    @IBOutlet weak var milliseconds: UILabel!
    @IBOutlet weak var seconds: UILabel!
    @IBOutlet weak var minutes: UILabel!
    let analogView = AnalogView()
    
    @IBOutlet weak var clockView: ClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockView.addSubview(analogView)
        

    }


}

extension AnalogViewController: StopwatchModelDelegate {
    func timerUpdated(with timestamp: TimeInterval) {
        analogView.rotateMainHand(with: timestamp)
//        let value = formatTimeIntervalToString(timestamp)
//        minutes.text = value.minutes
//        seconds.text = value.seconds
//        milliseconds.text = value.milliseconds
    }
    
    func lapUpdated(with timestamp: TimeInterval) {
        analogView.rotateLapHand(with: timestamp)
    }
    
    func resetDefaults() {
        analogView.resetDefaults()
    }
}
