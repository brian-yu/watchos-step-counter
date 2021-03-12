//
//  StepCounterApp.swift
//  StepCounter WatchKit Extension
//
//  Created by Brian Yu on 3/11/21.
//

import SwiftUI

@main
struct StepCounterApp: App {
    
    @ObservedObject var stepCounts = StepCounts();
    
    @SceneBuilder var body: some Scene {
        WindowGroup {
            TabView {
                StepCounterView(stepCounts: stepCounts)
                AccelerationView(stepCounts: stepCounts)
            }
            .tabViewStyle(PageTabViewStyle())
        }
        
        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
