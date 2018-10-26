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
        WindowManager.shared.showProgressView()
        addSideMenu()
        getStudents(isLoadmore: false)
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
    
    func addSideMenu() {
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
    
    func setupUI() {
        tableView.es.addPullToRefresh { [weak self] in
            self?.getStudents(isLoadmore: false)
            self?.tableView.es.stopPullToRefresh()
        }
        tableView.es.addInfiniteScrolling { [weak self] in
            self?.getStudents(isLoadmore: true)
            self?.tableView.es.stopLoadingMore()
        }
        tableView.register(nibWithCellClass: TableViewCell.self)
        tableView.rowHeight = 60
        tableView.tableFooterView = UIView()
    }
    
    func getStudents(isLoadmore: Bool) {
        viewModel.getWeathers(isLoadmore: isLoadmore) { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
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
}
