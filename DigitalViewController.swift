//
//  DigitalViewController.swift
//  Stopwatch
//
//  Created by vm mac on 11/13/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class DigitalViewController: UIViewController {

    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var secondsLabel: UILabel!
    @IBOutlet weak var millisecondsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func setupDefaults() {
        minutesLabel.text = "00"
        secondsLabel.text = "00"
        millisecondsLabel.text = "00"
    }

    fileprivate func formatTimeIntervalToString(_ time: TimeInterval) -> (minutes: String, seconds: String, milliseconds: String) {
        let minutes = (Int(time) / 60) % 60
        let seconds = Int(time) % 60
        let milliSeconds = Int(time * 100) % 100
        return (String(format: "%02d", minutes), String(format: "%02d", seconds), String(format: "%02d", milliSeconds))
    }
}

extension DigitalViewController: StopwatchModelDelegate {
    func lapWasAdded() {
    }
    
    func timerUpdated(with timestamp: TimeInterval) {
        let value = formatTimeIntervalToString(timestamp)
        minutesLabel.text = value.minutes
        secondsLabel.text = value.seconds
        millisecondsLabel.text = value.milliseconds
    }
    
    func lapUpdated(with timestamp: TimeInterval) {

    }
    
    func updateLapResetButton(forState runningState: RunState) {

    }
    
    func updateStartStopButton(forState runningState: RunState) {

    }
    
    func resetDefaults() {
        setupDefaults()
    }
}
