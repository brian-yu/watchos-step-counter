//
//  StepCounterView.swift
//  StepCounter WatchKit Extension
//
//  Created by Brian Yu on 3/12/21.
//

import SwiftUI

struct AccelerationView: View {
    @ObservedObject var stepCounts : StepCounts
    
    var body: some View {
        
        VStack {
            Text("Acceleration")
                .fontWeight(.bold)
                .padding()
            VStack(alignment: .leading) {
                Text("X: \(stepCounts.accelX)").padding()
                Text("Y: \(stepCounts.accelY)").padding()
                Text("Z: \(stepCounts.accelZ)").padding()
            }
        }
    }
}

struct AccelerationView_Previews: PreviewProvider {
    static var previews: some View {
        AccelerationView(stepCounts: StepCounts())
    }
}
