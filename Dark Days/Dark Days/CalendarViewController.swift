//
//  CalendarViewController.swift
//  Dark Days
//
//  Created by Andrew Harrison on 11/16/16.
//  Copyright © 2016 Lickability. All rights reserved.
//

import Foundation

final class CalendarViewController: UIPageViewController {
    
    fileprivate lazy var monthViewControllers: [MonthViewController] = {
        return Month.allMonths.flatMap {
            let monthViewController = UIStoryboard.monthViewController()
            monthViewController?.month = $0
            
            return monthViewController
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let currentMonthViewController = monthViewControllers.filter({ $0.month?.name == Month.currentMonthName }).first else { return }
        
        dataSource = self
        
        setViewControllers([currentMonthViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension CalendarViewController: UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MonthViewController else { return nil }
        guard let viewControllerIndex = monthViewControllers.index(of: viewController) else { return nil }
        
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        
        return monthViewControllers[previousIndex]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? MonthViewController else { return nil }
        guard let viewControllerIndex = monthViewControllers.index(of: viewController) else { return nil }
        
        let nextIndex = viewControllerIndex + 1
        guard monthViewControllers.count > nextIndex else { return nil }
        
        return monthViewControllers[nextIndex]
    }
}

extension Month {
    static var allMonths: [Month] {
        return ObjectProvider.objectsForJSON("Months")
    }
    
    static var monthInfo: [String: AnyObject] {
        return ObjectProvider.JSONDictionaryForName("CurrentMonthInfo") ?? [:]
    }
    
    static var currentMonthName: String {
        return monthInfo["name"] as? String ?? ""
    }
    
    static var currentMonthDay: Int {
        return monthInfo["day"] as? Int ?? 0
    }
}
