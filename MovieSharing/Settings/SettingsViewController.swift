//
//  SettingsViewController.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        settingTableView.register(UINib(nibName: String(describing: UserInfoTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: UserInfoTableViewCell.self))
        
        settingTableView.register(UINib(nibName: String(describing: SettingTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SettingTableViewCell.self))
        
        settingTableView.register(UINib(nibName: String(describing: SwitchOnOffTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SwitchOnOffTableViewCell.self))
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
    }
}

extension SettingsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 5
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserInfoTableViewCell.self), for: indexPath)
                return cell
            } else  {
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath)
                guard let cellSet = cell as? SettingTableViewCell else {return cell}
               
                cellSet.titleLabel?.text = "Apple ID Suggestions"
                cellSet.detailLabel.text = ""
                cellSet.tagImageWidth.constant = 0
                return cell
                
            }
        } else {
            if indexPath.row == 0 {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SwitchOnOffTableViewCell.self), for: indexPath)
                guard let cellSet = cell as? SwitchOnOffTableViewCell else {return cell}
                
                cellSet.titleLabel?.text = "Lorum Ipsum"
                cellSet.tagImage?.layer.cornerRadius = 4
                cellSet.tagImage?.backgroundColor = UIColor(red: 240.0/255.0, green: 137.0/255.0, blue: 0, alpha: 1)
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SettingTableViewCell.self), for: indexPath)
                guard let cellSet = cell as? SettingTableViewCell else {return cell}
                cellSet.titleLabel?.text = "Lorum Ipsum"
                cellSet.imageTag?.layer.cornerRadius = 4
                
                if indexPath.row == 1 {
                    cellSet.imageTag?.backgroundColor = UIColor.blue
                    cellSet.detailLabel.text = "Connected"
                } else if indexPath.row == 2 {
                    cellSet.imageTag?.backgroundColor = UIColor.blue
                    cellSet.detailLabel.text = "On"
                }else if indexPath.row == 3 {
                    cellSet.imageTag?.backgroundColor = UIColor.green
                    cellSet.detailLabel.text = ""
                } else {
                    cellSet.imageTag?.backgroundColor = UIColor.green
                    cellSet.detailLabel.text = "Off"
                }
                
                
                return cell
                
            }
            
        }
        
        
    }
    
}
