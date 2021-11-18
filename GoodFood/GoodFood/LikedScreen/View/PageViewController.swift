//
//  PageViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import UIKit

protocol PageViewControllerProtocol {
    func setSegmentIndex(index: Int)
}

class PageViewController: UIPageViewController{
    
    var subViewControllers: [UIViewController]?
    
    var pageDelegate: PageViewControllerProtocol?
    
    private(set) var selectedIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        setViewControllersWithIndex(index: 0)
    }
    
    func setViewControllersWithIndex(index: Int) {
        guard let subViewController = subViewControllers?[index] else { return }
        self.setViewControllers([subViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension PageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers?.count ?? 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = subViewControllers?.firstIndex(of: viewController) ?? 0
        
        if currentIndex <= 0 {
            return nil
        }
        
        return subViewControllers?[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let count = subViewControllers?.count else { return UIViewController() }
        let currentIndex = subViewControllers?.firstIndex(of: viewController) ?? 0
        
        if currentIndex >= count - 1 {
            return nil
        }
        
        return subViewControllers?[currentIndex + 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        
        if (completed), let viewControllers = pageViewController.viewControllers {
            switch viewControllers[0] {
            case is LikedViewController:
                pageDelegate?.setSegmentIndex(index: 0)
            case is YourRecipesViewController:
                pageDelegate?.setSegmentIndex(index: 1)
            case is HistoryViewController:
                pageDelegate?.setSegmentIndex(index: 2)
            default:
                return
            }
        }
        
    }
}
