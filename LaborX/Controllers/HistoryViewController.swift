//
//  hsitoryViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import FirebaseFirestore



var requestIdentifier = ""
    

class HistoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var tableView: UITableView!
    var requests = [String]()
    private var requestsCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        
    
        //get requests first document
        
                    requestsCollectionRef = Firestore.firestore().collection("Requests")
                    requestsCollectionRef.getDocuments() { ( QuerySnapshot, err) in
                    if let err = err {
                        print("we have an error: \(err)")
                    }
                    else {
                        guard let snap = QuerySnapshot else {return}
                        for document in snap.documents {
                            
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "reqDetailsSegue", sender: self)
            requestIdentifier = requests[indexPath.row]
        }
        
    }


