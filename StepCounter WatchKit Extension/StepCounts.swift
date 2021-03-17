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
    
    var stepReset = true
//    var runReset = true
    
//    let walkThreshold = 0.06
//    let runThreshold = 0.25
    
    let noiseThreshold = 0.05
    let walkThreshold = 0.10
    let runThreshold = 0.80
    
    let motion = CMMotionManager()
    let queue = OperationQueue()
    
    let windowSize = 10
    var window : Array<Double>
    var windowIdx = 0
    
    var prevAccel: Double = 0
    
    init() {
        window = [Double](repeating: 0, count: windowSize)
        
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
//                                                        print("\(accelX), \(accelY), \(accelZ)")
                                                        
                                                        window[windowIdx] = accelX
                                                        windowIdx = (windowIdx + 1) % window.count

                                                        let avgAccelX = window.reduce(0.0, +) / Double(window.count)
                                                        
                                                        print(avgAccelX)
                                                        
                                                        if (abs(avgAccelX) < noiseThreshold) {
                                                            
                                                        } else if (avgAccelX > 0 && avgAccelX < prevAccel && stepReset) {
                                                            stepReset = false
                                                            
//                                                            print("Peak value at \(prevAccel). Steps: \(self.stepsWalked), \(self.stepsRan)")

                                                            if (prevAccel >= walkThreshold && prevAccel < runThreshold) {
                                                                DispatchQueue.main.async {
                                                                    self.stepsWalked += 1
                                                                }
//                                                                print("Walk step!")
                                                            } else if (prevAccel >= runThreshold) {
                                                                DispatchQueue.main.async {
                                                                    self.stepsRan += 1
                                                                }
//                                                                print("Run step!")
                                                            }
                                                        } else if (avgAccelX < 0 && avgAccelX > prevAccel && !stepReset) {
                                                            stepReset = true
                                                            
//                                                            print("Peak value at \(prevAccel). Steps: \(self.stepsWalked), \(self.stepsRan)")
                                                            
                                                            if (prevAccel <= -walkThreshold && prevAccel > -runThreshold) {
                                                                DispatchQueue.main.async {
                                                                    self.stepsWalked += 1
                                                                }
//                                                                print("Walk step!")
                                                            } else if (prevAccel <= -runThreshold) {
                                                                DispatchQueue.main.async {
                                                                    self.stepsRan += 1
                                                                }
//                                                                print("Run step!")
                                                            }
                                                        }

                                                        DispatchQueue.main.async {
                                                            self.accelX = accelX
                                                            self.accelY = accelY
                                                            self.accelZ = accelZ
                                                        }
                                                        
                                                        prevAccel = avgAccelX
                                                    }
                                                 })
        }
    }
    
    func reset() {
        self.stepsWalked = 0
        self.stepsRan = 0
        
        self.stepReset = true
        self.prevAccel = 0
        
//        self.runReset = true
    }
}
