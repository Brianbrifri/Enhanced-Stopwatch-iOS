//
//  ClockView.swift
//  Stopwatch
//
//  Created by vm mac on 11/16/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class ClockView: UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func addSubview(_ view: UIView) {
        super.addSubview(view)
        setupView(with: view)
    }
    
    //Set up constraints for subviews
    private func setupView(with view: UIView) {
        subviews.forEach { (subView) in
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
            subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        }
    }
}
