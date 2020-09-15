//
//  RequestDetailViewController.swift
//  LaborX
//
//  Created by Luis Caram on 9/15/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import FirebaseFirestore


class RequestDetailViewController: UIViewController {
    
    
    @IBOutlet weak var testRequestDetailLbl: UILabel!
    @IBOutlet weak var reqEmail: UILabel!
    @IBOutlet weak var reqName: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var location: UILabel!
    @IBOutlet weak var serviceType: UILabel!
    @IBOutlet weak var shiftOneHours: UILabel!
    @IBOutlet weak var shiftOneWorkers: UILabel!
    @IBOutlet weak var shiftOneStartTime: UILabel!
    @IBOutlet weak var shiftTwoHours: UILabel!
    @IBOutlet weak var shiftTwoWorkers: UILabel!
    @IBOutlet weak var shiftTwoStartTime: UILabel!
    @IBOutlet weak var shiftThreeHours: UILabel!
    @IBOutlet weak var shiftThreeWorkers: UILabel!
    @IBOutlet weak var shiftThreeStartTime: UILabel!
    @IBOutlet weak var twic: UILabel!
    @IBOutlet weak var piece: UILabel!
    
    
    var requests = [String]()
    private var requestsCollectionRef: CollectionReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
        
        testRequestDetailLbl.text = requestIdentifier
        print("\(requestIdentifier)")
        
        let docRef = Firestore.firestore().collection("Requests").document(requestIdentifier)
        docRef.getDocument { (document, error) in
            docRef.getDocument(source: .cache) { (document, error) in
                if let document = document {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    self.reqEmail.text = document["requestorEmail"] as? String ?? "Anoymous"
                    self.reqName.text = document["requestorName"] as? String ?? "Anoymous"
                    self.startDate.text = document["startdate"] as? String ?? "Anoymous"
                    self.endDate.text = document["enddate"] as? String ?? "Anoymous"
                    self.location.text = document["location"] as? String ?? "Anoymous"
                    self.serviceType.text = document["ServiceType"] as? String ?? "Anonymous"
                    self.shiftOneHours.text = document["shiftOneNumHours"] as? String ?? "Anonymous"
                    self.shiftOneWorkers.text = document["shiftOneWorkers"] as? String ?? "Anonymous"
                    self.shiftOneStartTime.text = document["shiftOneStartTime"] as? String ?? "Anonymous"
                    self.shiftTwoHours.text = document["shiftTwoHours"] as? String ?? "Anonymous"
                    self.shiftTwoWorkers.text = document["shiftTwoWorkers"] as? String ?? "Anonymous"
                    self.shiftTwoStartTime.text = document["shiftTwoStartTime"] as? String ?? "Anonymous"
                    self.shiftThreeHours.text = document["shiftThreeHours"] as? String ?? "Anonymous"
                    self.shiftThreeWorkers.text = document["shiftThreeWorkers"] as? String ?? "Anonymous"
                    self.shiftThreeStartTime.text = document["shiftThreeStartTime"] as? String ?? "Anonymous"
                    self.twic.text = document["twic"] as? String ?? "Anonymous"
                    self.piece.text = document["piece"] as? String ?? "Anonymous"
                
                
                
                
                print("Cached document data: \(dataDescription)")
              } else {
                print("Document does not exist in cache")
              }
            }
        }
//        Firestore.firestore().collection("Requests").whereField(requestIdentifier, isEqualTo: true).getDocuments() { (QuerySnapshot, err) in
//                        if let err = err {
//                            print("we have an error: \(err)")
//                        }
//                        else {
//                            guard let snap = QuerySnapshot else {return}
//                            for document in snap.documents {
//                                print("im in")
//                                let data = document.data()
//                                self.reqEmail.text = ["requestorEmail"] as? String ?? "Anoymous"
//            //                    let requestorsName = data["requestorsName"] as? String ?? "Anoymous"
//            //                    let shiftOneNumHours = data["shiftOneNumHours"] as? String ?? "None"
//            //                    let shiftOneStartTime = data["shiftOneStartTime"] as? String ?? "Anoymous"
//            //                    let shiftOneQuantityWorkers = data["shiftOneQuantityWorkers"] as? String ?? "Anoymous"
//            //                    let shiftTwoNumHours = data["shiftTwoNumHours"] as? String ?? "None"
//            //                    let shiftTwoStartTime = data["shiftTwoStartTime"] as? String ?? "Anoymous"
//            //                    let shiftTwoQuantityWorkers = data["shiftTwoQuantityWorkers"] as? String ?? "Anoymous"
//            //                    let shiftThreeNumHours = data["shiftThreeNumHours"] as? String ?? "None"
//            //                    let shiftThreeStartTime = data["shiftThreeStartTime"] as? String ?? "Anoymous"
//            //                    let shiftThreeQuantityWorkers = data["shiftThreeQuantityWorkers"] as? String ?? "Anoymous"
//            //                    let startDate = data["startdate"] as? String ?? "Anoymous"
//            //                    let twic = data["twic"] as? String ?? "Anonymous"
//            //                    let piece = data["piece"] as? String ?? "Anonymous"
//            //                    let endDate = data["endate"] as? String ?? "Anonymous"
//            //                    let serviceType = data["serviceType"] as? String ?? "Anonymous"
//
//                                self.requests.append(document.documentID)
//                                print("\(document.documentID)")
//                                print("\(document.data())")
//
//                            }
//                        }
//                    }
        }
}
