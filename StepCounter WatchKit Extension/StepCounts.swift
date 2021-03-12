//
//  MotionUpdater.swift
//  StepCounter WatchKit Extension
//
//  Created by Brian Yu on 3/12/21.
//

import Foundation
import CoreMotion

class StepCounts: ObservableObject {
    @Published var accelX = Double()
    @Published var accelY = Double()
    @Published var accelZ = Double()
    
    @Published var stepsWalked = Int()
    @Published var stepsRan = Int()
    
    var walkReset = true
    var runReset = true
    
    let walkThreshold = 0.2
    let runThreshold = 0.4
    
    let motion = CMMotionManager()
    let queue = OperationQueue()
    
    init() {
        if motion.isDeviceMotionAvailable {
            print("Motion available")
            print(motion.isGyroAvailable ? "Gyro available" : "Gyro NOT available")
            print(motion.isAccelerometerAvailable ? "Accel available" : "Accel NOT available")
            print(motion.isMagnetometerAvailable ? "Mag available" : "Mag NOT available")
            
            self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
            self.motion.showsDeviceMovementDisplay = true
            self.motion.startDeviceMotionUpdates(using: .xArbitraryZVertical,
                                                 to: self.queue, withHandler: { [self] (data, error) in
                                                    // Make sure the data is valid before accessing it.
                                                    if let validData = data {
                                                        // Get the attitude relative to the magnetic north reference frame.
                                                        let accelX = validData.userAcceleration.x
                                                        let accelY = validData.userAcceleration.y
                                                        let accelZ = validData.userAcceleration.z
                                                        print("\(accelX), \(accelY), \(accelZ)")
                                                        
                                                        
                                                        
                                                        DispatchQueue.main.async {
                                                            if (accelX >= walkThreshold && walkReset) {
                                                                self.stepsWalked += 1
                                                                walkReset = false
                                                            } else if (accelX <= -walkThreshold && !walkReset) {
                                                                self.stepsWalked += 1
                                                                walkReset = true
                                                            }
                                                            
                                                            if (accelX >= runThreshold && runReset) {
                                                                self.stepsRan += 1
                                                                runReset = false
                                                            } else if (accelX <= -runThreshold && !runReset) {
                                                                self.stepsRan += 1
                                                                runReset = true
                                                            }
                                                            
                                                            self.accelX = accelX
                                                            self.accelY = accelY
                                                            self.accelZ = accelZ
                                                        }
                                                        
                                                        // Use the motion data in your app.
                                                    }
                                                 })
        }
    }
    
    func reset() {
        self.stepsWalked = 0
        self.stepsRan = 0
        
        self.walkReset = true
        self.runReset = true
    }
}
