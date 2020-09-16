//
//  activeUsersViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import FirebaseFirestore



var employeeFullDetails = ""
    

class ActiveUsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    
    
    var employee = [String]()
    
    private var employeeCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        self.navigationItem.title = "Employee List"

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "employeeList")
        tableView.dataSource = self
        tableView.delegate = self
        
        Firestore.firestore().collection("employees").whereField("Current Location", isEqualTo: "WO11619 - GM")
            .getDocuments() { ( QuerySnapshot, err) in
            if let err = err {
                print("we have an error: \(err)")
            }
            else {
                guard let snap = QuerySnapshot else {return}
                for document in snap.documents {
                    
                    self.employee.append(document.documentID)
                    print("\(document.documentID)")
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        employee.removeAll()
    }
                   

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of requests:\(employee.count)")
        return employee.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "employeeCell") as! employeeList
        let employeeID = employee[indexPath.row]
        cell.employeeFirstName.text = employeeID
        cell.employeeLastName.text = "Location:"
        cell.employeeLocation.text = employeeLocation
        
        //format cell
        cell.employeeView.layer.cornerRadius = 12
        cell.employeeView.backgroundColor = .secondarySystemBackground
        return cell
       }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//            tableView.deselectRow(at: indexPath, animated: true)
//            performSegue(withIdentifier: "employeeList", sender: self)
//            requestIdentifier = employee[indexPath.row]
//        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
        

}
