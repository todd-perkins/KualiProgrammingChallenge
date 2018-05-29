//
//  ViewController.swift
//  Kuali Programming Challenge
//
//  Created by Todd Perkins on 5/29/18.
//  Copyright © 2018 Todd Perkins. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let numOfElevators:Int = 5 // total number of elevators. change it here as it is a constant
    let maxFloorOfBuilding:Int = 30 // highest floor of building
    
    var elevators:[Elevator] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        createElevators()
        createRequests()
    }
    
    func createElevators() {
        for i in 1...numOfElevators { // loop to create all the elevators
            let elevator:Elevator = Elevator(num: i)
            elevators.append(elevator)
        }
    }
    
    func createRequests() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { (timer:Timer) in
            // make sure there's an available elevator
            
            
            // if there's an available elevator, pick the closest one
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

