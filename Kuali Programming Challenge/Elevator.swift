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
    var direction:Int = 1 // 1 = up, -1 = down
    var containsPassengers:Bool = false // whether the elevator currently contains passengers
    
    init(num:Int){ // when we init, we only need the index since all elevators start at floor 1
        self.elevatorNum = num
        super.init()
        
        nextFloor()
    }
    
    func didReceiveRequest(req:ElevatorRequest){
        
    }
    
    @objc func move(){
        if(currentFloor >= maxFloor) {
            currentFloor = maxFloor
            //print("elevator \(elevatorNum) has reached the top")
            return
        }
        if(currentFloor <= 1) {
            currentFloor = 1
            //print("elevator \(elevatorNum) has reached the bottom")
        }
        currentFloor += direction
        print("elevator \(elevatorNum) is now at floor \(currentFloor)")
        nextFloor()
    }
    
    func closeDoor() {
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer:Timer) in
            print("elevator \(self.elevatorNum) closed its door")
            self.nextFloor()
        }
    }
    
    func nextFloor(){
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer:Timer) in
            self.move()
        }
    }
}
