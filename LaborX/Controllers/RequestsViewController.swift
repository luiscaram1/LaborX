//
//  requestsViewController.swift
//  LaborX
//
//  Created by Luis Caram on 8/29/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import FirebaseDatabase

class RequestsViewController: UIViewController {
    
    @IBOutlet weak var requestorsName: UITextField!
    @IBOutlet weak var requestorsEmail: UITextField!    
    @IBOutlet weak var startField: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var shiftOneHoursField: UITextField!
    @IBOutlet weak var shiftOneStartField: UITextField!
    @IBOutlet weak var shiftOneWorkerQuantityField: UITextField!
    @IBOutlet weak var shiftTwoHoursField: UITextField!
    @IBOutlet weak var shiftTwoStartField: UITextField!
    @IBOutlet weak var shiftTwoWorkerQuantityField: UITextField!
    @IBOutlet weak var shiftThreeWorkerQuantityField: UITextField!
    @IBOutlet weak var shiftThreeHoursField: UITextField!
    @IBOutlet weak var shiftThreeStartField: UITextField!
    @IBOutlet weak var twicSwitch: UISwitch!
    @IBOutlet weak var twicLbl: UILabel!
    @IBOutlet weak var typeOfServiceField: UITextField!
    
    private var datePicker: UIDatePicker?
    private var datePickerEnd: UIDatePicker?
    private var shiftThreeTimePicker: UIDatePicker?
    private var shiftTwoTimePicker: UIDatePicker?
    private var shiftOneTimePicker: UIDatePicker?
    
    var ref:DatabaseReference!
    
    var valueSelected = String()
    
    var locationPickerView = UIPickerView()
    var serviceTypePicker = UIPickerView()
    var quantityPickerView = UIPickerView()
    var shiftOneWorkerQuantityPicker = UIPickerView()
    var shiftOneNumHoursPicker = UIPickerView()
    var shiftTwoWorkerQuantityPicker = UIPickerView()
    var shiftTwoNumHoursPicker = UIPickerView()
    var shiftThreeWorkerQuantityPicker = UIPickerView()
    var shiftThreeNumHoursPicker = UIPickerView()


    var location = ["Select Location", "Canton", "Chattanooga"]
    var serviceType = ["Select Service Type", "Accesory", "PDI", "Drivers", "Port Modifications"]
    var shiftOneWorkerQuantity = ["# Workers","1","2","3","4","5","6","7","8","9","10"]
    var shiftOneHoursQuantity = ["# Hours","1","2","3","4","5","6","7","8","9","10"]
    var shiftTwoWorkerQuantity = ["# Workers","1","2","3","4","5","6","7","8","9","10"]
    var shiftTwoHoursQuantity = ["# Hours","1","2","3","4","5","6","7","8","9","10"]
    var shiftThreeWorkerQuantity = ["# Workers","1","2","3","4","5","6","7","8","9","10"]
    var shiftThreeHoursQuantity = ["# Hours","1","2","3","4","5","6","7","8","9","10"]
    
    var defaultLocation = "Select Location"
    var defaultServiceType = "Select Service Type"
    var defaultShiftTwoWorkerQuantity = "0"
    var defaultShiftTwoNumHours = "0"
    var defaultShiftThreeWorkerQuantity = "0"
    var defaultShiftThreeNumHours = "0"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(addTapped))

        
        ref = Database.database().reference()
        
        
        //Set through another ViewController
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(RequestsViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        datePickerEnd = UIDatePicker()
        datePickerEnd?.datePickerMode = .date
        datePickerEnd?.addTarget(self, action: #selector(RequestsViewController.dateChanged(datePickerEnd:)), for: .valueChanged)
        
        shiftOneTimePicker = UIDatePicker()
        shiftOneTimePicker?.datePickerMode = .time
        shiftOneTimePicker?.addTarget(self, action: #selector(RequestsViewController.timeChanged(timePickerOne:)), for: .valueChanged)
        
        shiftTwoTimePicker = UIDatePicker()
        shiftTwoTimePicker?.datePickerMode = .time
        shiftTwoTimePicker?.addTarget(self, action: #selector(RequestsViewController.timeChanged(timePickerTwo:)), for: .valueChanged)
        
        shiftThreeTimePicker = UIDatePicker()
        shiftThreeTimePicker?.datePickerMode = .time
        shiftThreeTimePicker?.addTarget(self, action: #selector(RequestsViewController.timeChanged(timePickerThree:)), for: .valueChanged)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(RequestsViewController.viewTapped(gestureRecognizer:)))
       
            view.addGestureRecognizer(tapGesture)
        
            startField.inputView = datePicker
            endDate.inputView = datePickerEnd
            shiftOneStartField.inputView = shiftOneTimePicker
            shiftTwoStartField.inputView = shiftTwoTimePicker
            shiftThreeStartField.inputView = shiftThreeTimePicker
            
            locationField.inputView = locationPickerView
            typeOfServiceField.inputView = serviceTypePicker
            shiftOneWorkerQuantityField.inputView = shiftOneWorkerQuantityPicker
            shiftOneHoursField.inputView = shiftOneNumHoursPicker
            shiftTwoWorkerQuantityField.inputView = shiftTwoWorkerQuantityPicker
            shiftTwoHoursField.inputView = shiftTwoNumHoursPicker
            shiftThreeWorkerQuantityField.inputView = shiftThreeWorkerQuantityPicker
            shiftThreeHoursField.inputView = shiftThreeNumHoursPicker
        
            locationField.text = defaultLocation
            typeOfServiceField.text = defaultServiceType
        
            locationPickerView.delegate = self
            locationPickerView.dataSource = self
            serviceTypePicker.delegate = self
            serviceTypePicker.dataSource = self
            quantityPickerView.delegate = self
            quantityPickerView.dataSource = self
            shiftOneWorkerQuantityPicker.dataSource = self
            shiftOneWorkerQuantityPicker.delegate = self
            shiftOneNumHoursPicker.dataSource = self
            shiftOneNumHoursPicker.delegate = self
            shiftTwoWorkerQuantityPicker.dataSource = self
            shiftTwoWorkerQuantityPicker.delegate = self
            shiftTwoNumHoursPicker.dataSource = self
            shiftTwoNumHoursPicker.delegate = self
            shiftThreeNumHoursPicker.dataSource = self
            shiftThreeNumHoursPicker.delegate = self
            shiftThreeWorkerQuantityPicker.dataSource = self
            shiftThreeWorkerQuantityPicker.delegate = self
            
                
            locationPickerView.tag = 1
            shiftOneWorkerQuantityPicker.tag = 2
            shiftOneNumHoursPicker.tag = 3
            shiftTwoWorkerQuantityPicker.tag = 4
            shiftTwoNumHoursPicker.tag = 5
            shiftThreeWorkerQuantityPicker.tag = 6
            shiftThreeNumHoursPicker.tag = 7
            serviceTypePicker.tag = 8
            
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
        startField.text = dateFormatter.string(from: Date())
        view.endEditing(true)
        

        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
        endDate.text = dateFormatter.string(from: Calendar.current.date(byAdding: .day, value: 2, to: Date())!)
        view.endEditing(true)


    }
    
    @IBAction func actionTwicTriggered(_ sender: Any) {
        
        let onState = twicSwitch.isOn
        
        if onState {
                twicLbl.text = "YES"
            }
            else {
                twicLbl.text = "NO"
            }
        }

    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
        startField.text = dateFormatter.string(from: datePicker.date)
        
    }
    
    @objc func dateChanged(datePickerEnd: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy'T'HH:mm:ss"
        endDate.text = dateFormatter.string(from: datePickerEnd.date)
        
    }
    
    @objc func timeChanged(timePickerOne: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        shiftOneStartField.text = timeFormatter.string(from: timePickerOne.date)
    }
    
    @objc func timeChanged(timePickerTwo: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        shiftTwoStartField.text = timeFormatter.string(from: timePickerTwo.date)
    }
    
    @objc func timeChanged(timePickerThree: UIDatePicker) {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        shiftThreeStartField.text = timeFormatter.string(from: timePickerThree.date)
    }
    
    @objc func addTapped(gestureRecognizer: UITapGestureRecognizer) {
        //Upload Files
    }
    
    @IBAction func submitRequest(_ sender: Any) {
        print("tapped")
        
        if(locationField.text == "Select Location" && requestorsName.text == "" || requestorsEmail.text == "") {
            let alert = UIAlertController(title: "Some Fields are missing", message: "Click OK to go back", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if(locationField.text == "Select Location") {
            let alert = UIAlertController(title: "Please Select Location", message: "Click OK to go back", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
            else if(typeOfServiceField.text == "Select Service Type") {
                let alert = UIAlertController(title: "Please Select Service", message: "Click OK to go back", preferredStyle: UIAlertController.Style.alert)
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                // show the alert
                self.present(alert, animated: true, completion: nil)
            }
        else if(requestorsName.text == "") {
            let alert = UIAlertController(title: "Missing Requestors Name", message: "Click OK to go back", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else if(requestorsEmail.text == "") {
            let alert = UIAlertController(title: "Missing Requestors Email", message: "Click OK to go back", preferredStyle: UIAlertController.Style.alert)
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // show the alert
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            guard let key = ref.child("Requests").child("RequestID_\(startField.text!)").key else { return }
        let Request = ["name": requestorsName.text!,
                      "email": requestorsEmail.text!,
                      "startdate": startField.text!,
                      "enddate": endDate.text!,
                      "location": locationField.text!,
                      "ServiceType": typeOfServiceField.text!,
                      "shiftOneStartTime": shiftOneStartField.text!,
                      "shiftOneQuantityWorkers": shiftOneWorkerQuantityField.text!,
                      "shiftOneNumHours": shiftOneHoursField.text!,
                      "shiftTwoStartTime": shiftTwoStartField.text!,
                      "shiftTwoQuantityWorkers": shiftTwoWorkerQuantityField.text!,
                      "shiftTwoNumHours": shiftTwoHoursField.text!,
                      "shiftThreeStartTime": shiftThreeStartField.text!,
                      "shiftThreeQuantityWorkers": shiftThreeWorkerQuantityField.text!,
                      "shiftThreeNumHours": shiftThreeHoursField.text!,
                      "twic": twicLbl.text!]
        let childUpdates = ["/user-Requests/\(key)/": Request]
        ref.updateChildValues(childUpdates)
        
        requestorsName.text = ""
        requestorsEmail.text = ""
        startField.text = ""
        endDate.text = ""
        valueSelected = ""
        locationField.text = ""
        shiftOneHoursField.text = ""
        shiftOneWorkerQuantityField.text = ""
        shiftOneStartField.text = ""
        shiftTwoHoursField.text = ""
        shiftTwoWorkerQuantityField.text = ""
        shiftTwoStartField.text = ""
        shiftThreeHoursField.text = ""
        shiftThreeWorkerQuantityField.text = ""
        shiftThreeStartField.text = ""
        typeOfServiceField.text = ""
        }
    }
}

extension RequestsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        switch pickerView.tag {
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 1
        case 6:
            return 1
        case 7:
            return 1
        case 8:
            return 1
        default:
            return 1
}
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 1:
            return location.count
        case 2:
            return shiftOneWorkerQuantity.count
        case 3:
            return shiftOneHoursQuantity.count
        case 4:
            return shiftTwoWorkerQuantity.count
        case 5:
            return shiftTwoHoursQuantity.count
        case 6:
            return shiftThreeWorkerQuantity.count
        case 7:
            return shiftThreeHoursQuantity.count
        case 8:
            return serviceType.count
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return location[row]
        case 2:
            return shiftOneWorkerQuantity[row]
        case 3:
            return shiftOneHoursQuantity[row]
        case 4:
            return shiftTwoWorkerQuantity[row]
        case 5:
            return shiftTwoHoursQuantity[row]
        case 6:
            return shiftThreeWorkerQuantity[row]
        case 7:
            return shiftThreeHoursQuantity[row]
        case 8:
            return serviceType[row]
        default:
            return "No Data Found"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 1:
            locationField.text = location[row]
            locationField.resignFirstResponder()
        case 2:
            shiftOneWorkerQuantityField.text = shiftOneWorkerQuantity[row]
        case 3:
            shiftOneHoursField.text = shiftOneHoursQuantity[row]
        case 4:
            shiftTwoWorkerQuantityField.text = shiftTwoWorkerQuantity[row]
        case 5:
            shiftTwoHoursField.text = shiftTwoHoursQuantity[row]
        case 6:
            shiftThreeWorkerQuantityField.text = shiftThreeWorkerQuantity[row]
        case 7:
            shiftThreeHoursField.text = shiftThreeHoursQuantity[row]
        case 8:
            typeOfServiceField.text = serviceType[row]
            typeOfServiceField.resignFirstResponder()
        default:
            return
        }
    }
    
    
    func alertUserLoginError(message: String = "Please select location") {
           let alert = UIAlertController(title: "Error",
                                         message: message, preferredStyle: .alert)
           
           alert.addAction(UIAlertAction(title: "Dismiss",
                                         style: .cancel,
                                         handler: nil))
           present(alert, animated: true)
       }
}

