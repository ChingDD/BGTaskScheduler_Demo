//
//  ViewController.swift
//  BGTaskScheduler_Demo
//
//  Created by 林仲景 on 2024/7/21.
//

import UIKit
import BackgroundTasks

class ViewController: UIViewController {
    
    @IBOutlet var dateTableView: UITableView!
    
    var dateStrArray: [String] = []
    var label: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        addLabel()
        setTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("viewWillAppear")
        
    }

    private func addLabel() {
        label = {
            let label = UILabel()
            self.view.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.widthAnchor.constraint(equalToConstant: 200).isActive = true
            label.heightAnchor.constraint(equalToConstant: 100).isActive = true
            label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
            label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
            label.backgroundColor = .orange
            label.textColor = .black
            label.text = "\(UserDefaults.standard.integer(forKey: "bgNumber"))"
            label.textAlignment = .center
            return label
        }()
    }
    
    private func getDate() {
        dateStrArray = UserDefaults.standard.stringArray(forKey: "dateStr") ?? []
    }
    
    private func setTableView() {
        dateTableView.dataSource = self
        dateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        dateTableView.backgroundColor = .green
    }

    private func updateNumber() {
        label?.text = "\(UserDefaults.standard.integer(forKey: "bgNumber"))"
    }
    
    func updateUI() {
        updateNumber()
        getDate()
        dateTableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dateStrArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        cell.textLabel?.text = dateStrArray[indexPath.row]
        return cell
    }
}
