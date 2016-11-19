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
    
    @IBOutlet weak var clockView: ClockView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        clockView.addSubview(analogView)
        

    }


}

extension AnalogViewController: StopwatchModelDelegate {
    
}
