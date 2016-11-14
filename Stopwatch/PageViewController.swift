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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        let analogPage = storyboard?.instantiateViewController(withIdentifier: "Analog")
        let digitalPage = storyboard?.instantiateViewController(withIdentifier: "Digital")
        timerPageControllers.append(digitalPage!)
        timerPageControllers.append(analogPage!)
        setViewControllers([digitalPage!], direction: .forward, animated: false, completion: nil)
    }

    func update() {
        
    }
   
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let selectedIndex = timerPageControllers.index(of: viewController)
        let previousIndex = abs(selectedIndex! - 1) % timerPageControllers.count
        return timerPageControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let selectedIndex = timerPageControllers.index(of: viewController)
        let nextIndex = abs(selectedIndex! + 1) % timerPageControllers.count        
        return timerPageControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let prevIndex = timerPageControllers.index(of: previousViewControllers.first!)
        
        var index : Int = -1
        
        if prevIndex == 0 {
            index = 1
        } else if prevIndex == 1 {
            index = 0
        }
        _ = ["index" : index]
        //NSNotificationCenter.defaultCenter().postNotificationName(Key.pageChange.rawValue, object: nil, userInfo: indexDict)
        
    }
    
    private func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return timerPageControllers.count
    }
    
    private func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }

}
