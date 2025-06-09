//
//  ContentView.swift
//  Better Rest 2.0
//
//  Created by Santhosh Srinivas on 09/06/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = Date.now
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12,step: 0.25)
            DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
            // Date.now... means i can only choose a value from the first index and end is infinite
                .labelsHidden()
            Text(Date.now.formatted(date: .long, time: .shortened))
            Button {
                exampleDates()
            } label: {
                Text("Click to run")
            }
        }
        .padding()
    }
    
    func exampleDates() {
        let now = Date.now
        let tomorrow = Date.now.addingTimeInterval(86400)
        let range = now...tomorrow
        print(range)
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
        print(components)
        let date = Calendar.current.date(from: components) ?? .now
        print(date)
        // current.date() is an optional
        let components1 = Calendar.current.dateComponents([.hour, .minute], from: .now)
        print(components1)
        let hour = components1.hour ?? 0
        let minute = components1.minute ?? 0
        print("\(hour) \(minute)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
