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
    var currentRequests:[ElevatorRequest] = [] // requests being handled by this elevator
    var doorIsOpened:Bool = false
    
    init(num:Int){ // when we init, we only need the index since all elevators start at floor 1
        self.elevatorNum = num
        super.init()
        
        nextFloor()
    }
    
    func canHandleRequest(req:ElevatorRequest) -> Bool { // called to see if a request can be handled
        if(!containsPassengers) { // elevator can always handle a request if it's empty
            return true
        }
        let onTheWayUp:Bool = (req.destinationFloor > currentFloor && req.destinationFloor < floorToStop && direction == 1) // passenger is on the way when elevator is going that direction, and between current floor and where the elevator is going to stop anyway
        let onTheWayDown:Bool = (req.destinationFloor < currentFloor && req.destinationFloor > floorToStop && direction == -1)
        let passengerIsOnTheWay:Bool =  onTheWayUp || onTheWayDown
        
        if(containsPassengers && passengerIsOnTheWay) {
            return true
        }
        return false
    }
    
    func didReceiveRequest(req:ElevatorRequest){ // once this elevator has been selected to handle a request, it's handled here
        currentRequests.append(req)
    }
    
    @objc func move(){
        if let req = needsToPickupPassengerAtCurrentFloor() { // we have a request at the current floor
            // stop at this floor and open doors
            doorIsOpened = true
            // pickup passenger
            print("picked up passenger \(req.passengerID)")
            return
        }
        if let req = hasRequestAtCurrentFloor() { // passenger needs to get off at this floor
            // stop here and open doors
            doorIsOpened = true
            
            // remove request
            
        }
        if(currentFloor >= maxFloor) {
            currentFloor = maxFloor
            print("elevator \(elevatorNum) has reached the top")
        }
        if(currentFloor <= 1) {
            currentFloor = 1
            print("elevator \(elevatorNum) has reached the bottom")
        }
        currentFloor += direction
        print("elevator \(elevatorNum) is now at floor \(currentFloor)")
        if(currentRequests.count > 0) {
            nextFloor()
        }
    }
    
    func needsToPickupPassengerAtCurrentFloor() -> ElevatorRequest? {
        for request in currentRequests {
            if(request.originFloor == currentFloor) {
                return request
            }
        }
        return nil
    }
    
    func hasRequestAtCurrentFloor() -> ElevatorRequest? {
        for request in currentRequests {
            if(request.destinationFloor == currentFloor) {
                return request
            }
        }
        return nil
    }
    
    func closeDoor() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer:Timer) in
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
