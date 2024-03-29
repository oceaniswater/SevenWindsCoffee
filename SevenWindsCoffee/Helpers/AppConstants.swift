//
//  AppConstants.swift
//  SevenWindsCoffee
//
//  Created by Mark Golubev on 07/02/2024.
//

import Foundation
import UIKit
import YandexMapsMobile

struct K {
    struct Design {
        static let primaryBackroundColor = UIColor(named: "primaryBackroundColor")
        static let secondBackroundColor = UIColor(named: "secondBackroundColor")
        
        static let secondTextColor = UIColor(named: "secondTextColor")
        static let primaryTextColor = UIColor(named: "primaryTextColor")
        
        static let cellColor = UIColor(named: "cellColor")
        
        static let buttonTextColor = UIColor(named: "buttonTextColor")
        static let buttonColor = UIColor(named: "buttonColor")
        static let buttonBorderColor = UIColor(named: "buttonBorderColor")
        
        static let separatorLineColor = UIColor(named: "separatorLineColor")
    }
    
    struct Network {
        static let server = "http://147.78.66.203:3210"
    }
    
    struct Coordinates {
        static let cameraPosition = YMKCameraPosition(target: YMKPoint(latitude: 44.83, longitude: 44.82), zoom: 9.0, azimuth: 150.0, tilt: 30.0)
    }
}
