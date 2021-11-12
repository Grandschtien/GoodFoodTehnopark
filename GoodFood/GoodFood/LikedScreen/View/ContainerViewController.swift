//
//  ContainerViewController.swift
//  GoodFood
//
//  Created by Егор Шкарин on 12.11.2021.
//

import UIKit


class ContainerViewController: UIViewController, UIPageViewControllerDelegate {
    private let segmentControl = UISegmentedControl(items: ["Избранное",
                                                            "Ваши рецепты",
                                                            "История"])
    
    private var pageVC: PageViewController = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
    
    private var subViewControllers: [UIViewController]?
    
    
    init(subViewControllers: [UIViewController]) {
        self.subViewControllers = subViewControllers
        self.pageVC.subViewControllers = self.subViewControllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

extension ContainerViewController {
    private func setupUI() {
        navigationItem.titleView = segmentControl
        segmentControl.selectedSegmentIndex = pageVC.selectedIndex
        view.backgroundColor = UIColor(named: "BackgroundColor")
        pageVC.pageDelegate = self
        //segmentControl.selectedSegmentIndex = 0
        segmentControl.addTarget(self,
                                 action: #selector(segmentIndexChenged(_:)),
                                 for: .valueChanged)
        self.addChild(pageVC)
        view.addSubview(pageVC.view)
    }
}

extension ContainerViewController {
    @objc
    private func segmentIndexChenged(_ segmntedControl: UISegmentedControl) {
        pageVC.setViewControllersWithIndex(index: segmntedControl.selectedSegmentIndex)
    }
}

extension ContainerViewController: PageViewControllerProtocol {
    func setSegmentIndex(index: Int) {
        print(index)
        segmentControl.selectedSegmentIndex = index
    }
}
