//
//  StepCounterView.swift
//  StepCounter WatchKit Extension
//
//  Created by Brian Yu on 3/11/21.
//

import SwiftUI

struct StepCounterView: View {
    @ObservedObject var stepCounts : StepCounts
    
    var body: some View {
        VStack {
            Text("EIT Step Counter")
                .fontWeight(.bold)
                .padding(.bottom)
            //            VStack(alignment: .leading) {
            Text("Walk: \(stepCounts.stepsWalked)").padding()
            Text("Run: \(stepCounts.stepsRan)").padding()
            //            }
            Button(action: { stepCounts.reset() }) {
                Text("Reset")
            }
            .frame(minWidth:0, maxWidth: 100)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding()
            //                Divider().padding()
            //                Text("Acceleration")
            //                    .fontWeight(.bold)
            //                    .padding()
            //                VStack(alignment: .leading) {
            //                    Text("X: \(updater.accelX)").padding()
            //                    Text("Y: \(updater.accelY)").padding()
            //                    Text("Z: \(updater.accelZ)").padding()
            //                }
            
        }
    }
}

struct StepCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StepCounterView(stepCounts: StepCounts())
    }
}
