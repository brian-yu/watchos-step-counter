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
            Text("Walk: \(stepCounts.stepsWalked)").padding()
            Text("Run: \(stepCounts.stepsRan)").padding()
            Button(action: { stepCounts.reset() }) {
                Text("Reset")
            }
            .frame(minWidth:0, maxWidth: 100)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(40)
            .padding()
        }
    }
}

struct StepCounterView_Previews: PreviewProvider {
    static var previews: some View {
        StepCounterView(stepCounts: StepCounts())
    }
}
