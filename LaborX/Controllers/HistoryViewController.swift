//
//  hsitoryViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import FirebaseFirestore


class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var requests = [String]()
    private var requestsCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
    

        
                    requestsCollectionRef = Firestore.firestore().collection("Requests")
                    requestsCollectionRef.getDocuments() { ( QuerySnapshot, err) in
                    if let err = err {
                        print("we have an error: \(err)")
                    }
                    else {
                        guard let snap = QuerySnapshot else {return}
                        for document in snap.documents {
        //                    let data = document.data()
        //                    let requestorsEmail = data["requestorsEmail"] as? String ?? "Anoymous"
        //                    let requestorsName = data["requestorsName"] as? String ?? "Anoymous"
        //                    let shiftOneNumHours = data["shiftOneNumHours"] as? String ?? "None"
        //                    let shiftOneStartTime = data["shiftOneStartTime"] as? String ?? "Anoymous"
        //                    let shiftOneQuantityWorkers = data["shiftOneQuantityWorkers"] as? String ?? "Anoymous"
        //                    let shiftTwoNumHours = data["shiftTwoNumHours"] as? String ?? "None"
        //                    let shiftTwoStartTime = data["shiftTwoStartTime"] as? String ?? "Anoymous"
        //                    let shiftTwoQuantityWorkers = data["shiftTwoQuantityWorkers"] as? String ?? "Anoymous"
        //                    let shiftThreeNumHours = data["shiftThreeNumHours"] as? String ?? "None"
        //                    let shiftThreeStartTime = data["shiftThreeStartTime"] as? String ?? "Anoymous"
        //                    let shiftThreeQuantityWorkers = data["shiftThreeQuantityWorkers"] as? String ?? "Anoymous"
        //                    let startDate = data["startdate"] as? String ?? "Anoymous"
        //                    let twic = data["twic"] as? String ?? "Anonymous"
        //                    let piece = data["piece"] as? String ?? "Anonymous"
        //                    let endDate = data["endate"] as? String ?? "Anonymous"
        //                    let serviceType = data["serviceType"] as? String ?? "Anonymous"
                            
        //                    let newRequest = requests(requestorsEmail: "requestorsEmail", requestorsName: "requestorsName", shiftOneNumHours:"shiftOneNumHours",
        //                    shiftOneStartTime:"shiftOneStartTime",
        //                     shiftOneQuantityWorkers :"shiftOneQuantityWorkers",
        //                    shiftTwoNumHours :"shiftTwoNumHours",
        //                     shiftTwoStartTime :"shiftTwoStartTime",
        //                     shiftTwoQuantityWorkers:"shiftTwoQuantityWorkers",
        //                     shiftThreeNumHours:"shiftThreeNumHours",
        //                     shiftThreeStartTime:"shiftThreeStartTime",
        //                     shiftThreeQuantityWorkers:"shiftThreeQuantityWorkers",
        //                     startDate:"startdate",
        //                     twic:"twic",
        //                     piece:"piece",
        //                     endDate :"endate",
        //                     serviceType:"serviceType")
                            
                            self.requests.append(document.documentID)
                            print("\(document.documentID)")
                        }
                        self.tableView.reloadData()
                    }
                }
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of requests:\(requests.count)")
        return requests.count
    }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                  for: indexPath)
        cell.textLabel?.text = requests[indexPath.row]
        return cell
       }
    
}

