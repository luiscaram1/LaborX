//
//  hsitoryViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import Firebase


class HistoryViewController: UIViewController {
    
    @IBOutlet weak var printLastRequestlbl: UILabel!

    
    private let database = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        database.child("Requests").child("0").observeSingleEvent(of: .value, with: {snapshot in
//            guard let value = snapshot.value as? [String: Any] else {
//                return
//            }
//            self.printLastRequestlbl.text = "\(value)"
//            print("Value: \(value)")
//
//        })
        
        
       Database.database().reference().child("Requests").observeSingleEvent(of: .value, with: { (snapshot) in


           guard let dictionary = snapshot.value as? [String:Any] else {return}

           dictionary.forEach({ (key , value) in

               print("Key \(key), value \(value) ")


           })



       }) { (Error) in

           print("Failed to fetch: ", Error)

       }
    }
 
}

