//
//  PageViewController.swift
//  Stopwatch
//
//  Created by vm mac on 11/12/16.
//  Copyright © 2016 David Vaughn. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    var timerPageControllers = [UIViewController]()
    var model: StopwatchModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        setViewControllers([timerPageControllers.first!], direction: .forward, animated: false, completion: nil)
    }
    
    func addChildViewControllers(_ childController: UIViewController) {
        timerPageControllers.append(childController)
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

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return timerPageControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
