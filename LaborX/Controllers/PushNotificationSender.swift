//
//  PushNotificationSender.swift
//  LaborX
//
//  Created by Luis Caram on 9/20/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import Foundation
import UIKit

class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]

        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=AAAAhb_AHU0:APA91bG9ruMzfFOL7Cw9DzdRQGKHKzjR38caDYzd5hjSAYyBe0AVd8kiV214j9owTxWh4Cpg72q-_US7j0uRnVEHQx8WbC66OJpIbYNyCNHUf0VYn4MuwIC00xctpKnW4J6IrPpM_C2l", forHTTPHeaderField: "Authorization")

        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print("We have an error here")
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
