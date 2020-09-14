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
    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        database.child("Requests").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [String: Any] else {
                return
            }
            print("Value: \(value)")
            
        })
}
}

