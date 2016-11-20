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
    }
    
    func setupDefaults() {
        minutesLabel.text = "00"
        secondsLabel.text = "00"
        millisecondsLabel.text = "00"
    }
}

// Mark: - StopwatchModelDelegate functions
extension DigitalViewController: StopwatchModelDelegate {
    
    func timerUpdated(with timestamp: TimeInterval) {
        let value = formatTimeIntervalToString(timestamp)
        minutesLabel.text = value.minutes
        secondsLabel.text = value.seconds
        millisecondsLabel.text = value.milliseconds
    }
    
    func resetDefaults() {
        setupDefaults()
    }
}
