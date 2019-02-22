//
//  ViewController.swift
//  BaseProject
//
//  Created by MTQ on 4/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit
import SideMenu

class TableViewController: BaseTableViewController {
    
    // MARK: - Properties
    private let viewModel = TableViewModel()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        addSideMenu()
        getStudents(isLoadmore: false, completion: { [unowned self] in
            print("Dealloc")
            self.reloadTableView()
        })
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Current Location", style: .plain, target: self, action: #selector(getCurrentLocation))
    }
    
    // MARK: - Override Methods
    override func leftAction() {
        if let sideMenuController = SideMenuManager.default.menuLeftNavigationController {
            self.present(sideMenuController, animated: true, completion: nil)
        }
    }
    
    @objc private func getCurrentLocation() {
        LocationManager.shared.startSingleLocationRequest()
    }
    
    // MARK: - Private Methods
    private func addSideMenu() {
        if let img = UIImage.init(named: "menu") {
            addLeftBarButtonWithImage(buttonImage: img, tintColor: UIColor.blue)
        }
        
        let controller = storyboard?.instantiateViewController(withClass: LeftMenuTableViewController.self)
        let menuLeftNavigationController = UISideMenuNavigationController(rootViewController: controller!)
        SideMenuManager.default.menuLeftNavigationController = menuLeftNavigationController
        
        //config
        SideMenuManager.default.menuFadeStatusBar = false
        if let navi = self.navigationController {
            SideMenuManager.default.menuAddPanGestureToPresent(toView: navi.navigationBar)
            SideMenuManager.default.menuAddScreenEdgePanGesturesToPresent(toView: navi.view)
        }
    }
    
    // MARK: - Base setup tableView
    override func setupUI() {
        setupRefreshControl()
        setupLoadMore()
        
        tableView.register(nibWithCellClass: TableViewCell.self)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    private func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.tintColor = UIColor.blue
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        getStudents(isLoadmore: false) { [weak self] in
            sender.endRefreshing()
            self?.reloadTableView()
        }
    }
    
    private func setupLoadMore() {
        tableView.estimatedRowHeight = 0
        let footer = ESRefreshFooterAnimator(frame: .zero)
//        footer.loadingMoreDescription = ""
        tableView.es.addInfiniteScrolling(animator: footer) { [weak self] in
            self?.getStudents(isLoadmore: true, completion: {
                self?.tableView.es.stopLoadingMore()
                self?.reloadTableView()
            })
        }
    }
    
    private func reloadTableView() {
        let lastOffset = tableView?.contentOffset ?? .zero
        tableView?.reloadData()
        tableView?.contentOffset = lastOffset
    }
    
    private func getStudents(isLoadmore: Bool, completion: @escaping (() -> Void)) {
//        WindowManager.shared.showProgressView()
        viewModel.getWeathers(isLoadmore: isLoadmore) {
//            WindowManager.shared.hideProgressView()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                completion()
            }
//            DispatchQueue.main.async {
//                completion()
//            }
        }
    }
    
    // MARK: - Configure Cell
    private func scoopCellAtIndexPath(indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self, for: indexPath)
        
        configureScoopCell(cell: cell, atIndexPath: indexPath)
        return cell
    }
    
    private func configureScoopCell(cell: TableViewCell, atIndexPath indexPath: IndexPath) {
        let weather = viewModel.students[indexPath.row].name
        cell.updateWithWeather(weather)
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return scoopCellAtIndexPath(indexPath: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tableHeaderView = UIView.loadFromNib(named: TableHeaderView.className)
        tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        return tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = StudentViewController.make()
        navigationController?.pushViewController(vc)
    }
}
