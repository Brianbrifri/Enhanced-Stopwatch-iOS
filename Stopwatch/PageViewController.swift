//
//  PageViewController.swift
//  Stopwatch
//
//  Created by vm mac on 11/12/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

protocol StopwatchPageDelegate: class {
    func updatePageControlIndex(with index: Int)
}

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var timerPageControllers = [UIViewController]()
    weak var pageDelegate: StopwatchPageDelegate!
    var model: StopwatchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        let analogPage = storyboard?.instantiateViewController(withIdentifier: "Analog")
        let digitalPage = storyboard?.instantiateViewController(withIdentifier: "Digital")
        timerPageControllers.append(digitalPage!)
        timerPageControllers.append(analogPage!)
        setViewControllers([digitalPage!], direction: .forward, animated: false, completion: nil)
        for controller in timerPageControllers {
            model?.delegate.addDelegate(delegte: controller as! StopwatchModelDelegate)
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let selectedIndex = timerPageControllers.index(of: viewController)
        if selectedIndex == timerPageControllers.count - 1 {
            return timerPageControllers[selectedIndex! - 1]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let selectedIndex = timerPageControllers.index(of: viewController)
        if selectedIndex == 0 {
            return timerPageControllers[selectedIndex! + 1]
        } else {
            return nil
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageDelegate.updatePageControlIndex(with: timerPageControllers.index(of: pendingViewControllers.first!)!)
    }
}
