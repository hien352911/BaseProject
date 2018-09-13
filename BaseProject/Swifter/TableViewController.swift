//
//  ViewController.swift
//  BaseProject
//
//  Created by MTQ on 4/28/18.
//  Copyright © 2018 MTQ. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    let viewModel = TableViewModel()
    var weathers: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        WindowManager.shared.showProgressView()
        viewModel.getWeathers { (response, error) in
            WindowManager.shared.hideProgressView()
            if let response = response as? [String] {
                self.weathers = response
                self.tableView.reloadData()
            }
        }
        
        print("27 Mar 2018 09:22".toDate()?.date.timeAgo())
    }
    
    func setupUI() {
        tableView.register(nibWithCellClass: TableViewCell.self)
        tableView.rowHeight = 60
    }
}

extension TableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weathers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self, for: indexPath)
        cell.label.text = weathers[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let tableHeaderView = UIView.loadFromNib(named: TableHeaderView.className)
        tableHeaderView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        return tableHeaderView
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = storyboard?.instantiateViewController(withClass: ViewControllerTest.self)
        presentTransperant(controller!, animated: true, completion: nil)
    }
}
