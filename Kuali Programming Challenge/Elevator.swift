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
    var doorIsOpened:Bool = true
    var totalTripsMade:Int = 0
    var needsService:Bool = false
    
    init(num:Int){ // when we init, we only need the index since all elevators start at floor 1
        self.elevatorNum = num
        super.init()
    }
    
    func canHandleRequest(req:ElevatorRequest) -> Bool { // called to see if a request can be handled
        if(needsService) {
            print("can't run the elevator. elevator needs to be serviced.")
            return false
        }
        
        if(!containsPassengers) { // elevator can always handle a request if it's empty
            return true
        }
        let onTheWayUp:Bool = (req.originFloor > currentFloor && req.originFloor < floorToStop && direction == 1) // passenger is on the way when elevator is going that direction, and between current floor and where the elevator is going to stop anyway
        let onTheWayDown:Bool = (req.originFloor < currentFloor && req.originFloor > floorToStop && direction == -1)
        let passengerIsOnTheWay:Bool =  onTheWayUp || onTheWayDown
        
        if(containsPassengers && passengerIsOnTheWay) {
            return true
        }
        
        let onTheSameFloorAndDoorIsOpen = (currentFloor == req.originFloor && doorIsOpened)
        if(onTheSameFloorAndDoorIsOpen) {
            return true
        }
        
        return false
    }
    
    func didReceiveRequest(req:ElevatorRequest){ // once this elevator has been selected to handle a request, it's handled here
        currentRequests.append(req)
        
        // if not moving, head to the origin floor to pickup request
        if(currentRequests.count == 1) { // this is our first/only passenger, so elevator is stopped
            floorToStop = req.originFloor
            closeDoor()
        }
    }
    
    @objc func move(){
        if let req = needsToPickupPassengerAtCurrentFloor() { // we have a request at the current floor
            // stop at this floor and open doors
            openDoor()
            // pickup passenger
            print("picked up passenger \(req.passengerID)")
            return
        }
        if let req = hasRequestAtCurrentFloor() { // passenger needs to get off at this floor
            // stop here and open doors
            openDoor()
            
            // remove request
            if let index:Int = currentRequests.index(where: {$0 === req}) {
                print("dropping off passenger \(req.passengerID)")
                totalTripsMade += 1
                if(totalTripsMade >= 100) {
                    serviceElevator()
                }
                currentRequests.remove(at: index)
            }
            return
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
        if(currentRequests.count > 0) { // if we don't have any passengers, then the elevator stays here
            nextFloor()
        }
    }
    
    func distanceToRequest(req:ElevatorRequest) -> Int {
        let o:Int = req.originFloor
        let distance = abs(currentFloor - o)
        return distance
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
    
    func openDoor() {
        doorIsOpened = true
        
        // wait a little bit before closing the door
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { (timer:Timer) in
            if(self.currentRequests.count > 0) { // if we have requests, close the door
                self.closeDoor()
            }
            
        }
    }
    
    func closeDoor() { // closes door and moves elevator
        doorIsOpened = false
        print("elevator \(self.elevatorNum) closed its door")
        self.nextFloor()
    }
    
    func nextFloor(){
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { (timer:Timer) in
            self.move()
        }
    }
    
    func serviceElevator() { // simple service method
        needsService = true
        Timer.scheduledTimer(withTimeInterval: 10, repeats: false) { (timer:Timer) in
            self.needsService = false
            self.totalTripsMade = 0
        }
        
    }
}
