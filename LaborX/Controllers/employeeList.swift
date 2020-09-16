//
//  employeeList.swift
//  LaborX
//
//  Created by Luis Caram on 9/16/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit

class employeeList: UITableViewCell {

    @IBOutlet weak var employeeView: UIView!
    @IBOutlet weak var employeeFirstName: UILabel!
    @IBOutlet weak var employeeLastName: UILabel!
    @IBOutlet weak var employeeLocation: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
