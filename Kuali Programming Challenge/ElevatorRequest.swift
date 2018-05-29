//
//  ElevatorRequest.swift
//  Kuali Programming Challenge
//
//  Created by Todd Perkins on 5/29/18.
//  Copyright © 2018 Todd Perkins. All rights reserved.
//

import Foundation

class ElevatorRequest {
    var totalFloors:Int
    var originFloor:Int = -1 // initial value = not set yet
    var destinationFloor:Int = -1 // initial value = not set yet
    
    init(totalFloors:Int) {
        self.totalFloors = totalFloors
        setRandomFloors()
    }
    
    func setRandomFloors() {
        while originFloor == destinationFloor { // keep getting random values until we have two different values
            originFloor = getRandomFloor()
            destinationFloor = getRandomFloor()
        }
    }
    
    func getRandomFloor() -> Int {
        return Int(arc4random_uniform(UInt32(totalFloors + 1)))
    }
}
