//
//  CoordinateItem.swift
//  E-nounce
//
//  Created by austin huang on 11/19/19.
//  Copyright © 2019 Yu WenLiao. All rights reserved.
//

import Foundation
import CoreLocation
import MessageKit

struct CoordinateItem:LocationItem {
    var location: CLLocation
    var size: CGSize
    
    init(location: CLLocation){
        self.location = location
        self.size = CGSize(width: 240, height: 240)
    }
}
