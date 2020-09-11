//
//  LocationPickerViewController.swift
//  LaborX
//
//  Created by Luis Caram on 9/11/20.
//  Copyright © 2020 Luis Caram. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationPickerViewController: UIViewController {
    
    public var completion: ((CLLocationCoordinate2D) -> Void)?
    private var coordinates: CLLocationCoordinate2D?
    
    private var map: MKMapView = {
        let map = MKMapView()
        return map
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pick Location"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(sendButtonTapped))
        view.addSubview(map)
        map.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTappedMap))
        gesture.numberOfTouchesRequired = 1
        gesture.numberOfTapsRequired = 1
        map.addGestureRecognizer(gesture)
    }
    
    @objc func sendButtonTapped() {
        guard let coordinates = coordinates else {
            return
        }
        completion?(coordinates)
    }
    
    @objc func didTappedMap(_ gesture: UITapGestureRecognizer) {
        let locaionInView = gesture.location(in: map)
        let coordinates = map.convert(locaionInView, toCoordinateFrom: map)
        self.coordinates = coordinates
        
        for annotation in map.annotations {
            map.removeAnnotation(annotation)
        }
        
        // drop a pin on that location
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        map.addAnnotation(pin)
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        map.frame = view.bounds
    }
    

}
