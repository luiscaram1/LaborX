//
//  activeUsersViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import Firebase

class ActiveUsersViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    var keyArray = [String]()
    
    var ref: DatabaseReference!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference(withPath: "labor-78e70")
        ref.observe(.value, with: { snapshot in
          // This is the snapshot of the data at the moment in the Firebase database
          // To get value from the snapshot, we user snapshot.value
          print(snapshot.value as Any)
            
            if snapshot.exists() {

              for snap in snapshot.children.allObjects {
                  if let snap = snap as? DataSnapshot {
                      let key = snap.key
                    self.keyArray.append(key)
                  }
              }
                

              }
            else{

                print("Liked data is not available")
            }
            
            
        })

        tableView.delegate = self
        tableView.dataSource = self
        
//        Database.database().reference().child("user-Requests").child("-MGSNb0qG_5f2LQVmprE").child("location")
//        .observeSingleEvent(of: .value) { datasnapshot in

      }
        
    }

extension ActiveUsersViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Testing tapped me")
    }
}

extension ActiveUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keyArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = keyArray[indexPath.row]
        return cell
    }
    
}
