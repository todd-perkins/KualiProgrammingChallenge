//
//  Elevator.swift
//  Kuali Programming Challenge
//
//  Created by Todd Perkins on 5/29/18.
//  Copyright © 2018 Todd Perkins. All rights reserved.
//

import Foundation

class Elevator : NSObject {
    let maxFloor:Int = 100 // the top floor
    
    var elevatorNum:Int // each elevator has its own id (1,2, etc.)
    
    var currentFloor:Int = 1 // the current floor of the elevator
    var floorToStop:Int = 0 // if not zero, this is a floor to stop on
    
    init(num:Int){ // when we init, we only need the index since all elevators start at floor 1
        self.elevatorNum = num
        super.init()
        
        nextFloor()
    }
    
    @objc func move(){
        if(currentFloor >= maxFloor) {
            print("elevator \(elevatorNum) has reached the top")
            return
        }
        currentFloor += 1
        print("elevator \(elevatorNum) is now at floor \(currentFloor)")
        nextFloor()
    }
    
    func nextFloor(){
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer:Timer) in
            self.move()
        }
    }
}
