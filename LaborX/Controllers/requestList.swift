//
//  requestList.swift
//  LaborX
//
//  Created by Luis Caram on 9/16/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit

class requestList: UITableViewCell {

    @IBOutlet weak var requestsView: UIView!
    @IBOutlet weak var titleRequestView: UILabel!
    @IBOutlet weak var numRequestView: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
