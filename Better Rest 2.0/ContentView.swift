//
//  ContentView.swift
//  Better Rest 2.0
//
//  Created by Santhosh Srinivas on 09/06/25.
//

import SwiftUI
import CoreML

struct ContentView: View {
    
    @State private var sleepAmount = 8.0
    @State private var wakeUp = defaultDateTime
    @State private var coffeeAmount = 0
    // here giving 0 as 0 corresponds to the 0th index with is 1 cup
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var showAlert = false
    
    // usually majority of the ppl will wakeup from 6-8 am sp we create a custom date property.
    static var defaultDateTime: Date {
        var component  = DateComponents()
        component.hour = 7
        component.minute = 0
        return Calendar.current.date(from: component) ?? .now
    }
    
    var bedTime: String? {
        let config = MLModelConfiguration()
        let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        
        let hour = (component.hour ?? 0) * 60 * 60
        let minute = (component.minute ?? 0) * 60
        // Using Optionals
        let sleepTime = try? wakeUp - (BetterRest(configuration: config).prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount)).actualSleep)
        return sleepTime?.formatted(date: .omitted, time: .shortened)
//        let sleepBy = wakeUp - prediction.actualSleep
    }
    var body: some View {
        NavigationStack{
            ZStack {
                // 🌈 Soft gradient background
                LinearGradient(
                    colors: [
                        Color(red: 0.94, green: 0.97, blue: 1.0), // soft blue
                        Color(red: 0.88, green: 0.93, blue: 1.0),
                        Color(red: 0.82, green: 0.92, blue: 0.96)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // ☁️ Ambient blur blobs
                Circle()
                    .fill(Color.purple.opacity(0.1))
                    .frame(width: 250)
                    .offset(x: -100, y: -150)
                    .blur(radius: 50)
                
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 180)
                    .offset(x: 120, y: 200)
                    .blur(radius: 40)
                Form{
                    Section("When do you want to wakeup"){
                        //                    VStack(alignment: .leading,spacing: 5){
                        //                    Text("When do you want to wakeup")
                        //                        .font(.headline)
                        DatePicker("Please select a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        //                        .labelsHidden()
                    }
                    Section("Desired Amount of Sleep"){
                        //                VStack(alignment: .leading){
                        //                    Text("Desired Amount of Sleep")
                        //                        .font(.headline)
                        Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                    }
                    Section("How many coffees do you drink a day?") {
                        //                VStack(alignment: .leading){
                        //                    Text("How many coffees do you drink a day?")
                        //                        .font(.headline)
                        //                    Stepper(coffeeAmount == 1 ? "1 cup a day" : "\(coffeeAmount) cups a day", value: $coffeeAmount, in: 1...20)
//                        Stepper("^[\(coffeeAmount) cup](inflect: true) a day", value: $coffeeAmount, in: 1...20)
                        Picker("Cups of coffee:", selection: $coffeeAmount){
                            ForEach(1..<21){
                                Text("^[\($0) cup](inflect: true) a day")
                                
                            }
                        }
                        // this is a way of pluralizing an word
                    }
                    //This Section updates data based on the variable
                    Section("Recommended Waking up Time1 is:"){
                        Text(bedTime ?? "\(Date.now)") // if bedtime is nil, then sleep now
                            .font(.largeTitle)
                    }
                    // This section uses the function
                    // onAppear calculates it first time the page is loaded.
                    // everytime there is a change it is tracked by onChange
                    Section("Recommended Waking up Time2 is:"){
                        Text(alertMsg)
                            .font(.largeTitle)
                            .onAppear(){
                                calcBedTime()
                            }
                    }
                    // When any of those values change, we performt the function in closure
                    .onChange(of: wakeUp){ _ in calcBedTime()}
                    .onChange(of: coffeeAmount){ _ in calcBedTime()}
                    .onChange(of: sleepAmount){ _ in calcBedTime()}
                }
            }
            .scrollContentBackground(.hidden) // iOS 16+
            .background(Color.clear)
//            .padding()
            .navigationTitle("Better Rest")
//            .toolbar{
//                Button("Calculate", action: calcBedTime)
//            }
//            .alert(alertTitle, isPresented: $showAlert){
//                Button("Okay!"){ print(coffeeAmount) }
//            } message: {
//                Text(alertMsg)
//            }
        }
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundColor(.accentColor)
//            Text("Hello, world!")
//            Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12,step: 0.25)
//            DatePicker("Please enter a date", selection: $wakeUp, in: Date.now...)
//            // Date.now... means i can only choose a value from the first index and end is infinite
//                .labelsHidden()
//            Text(Date.now.formatted(date: .long, time: .shortened))
//            Button {
//                exampleDates()
//            } label: {
//                Text("Click to run")
//            }
//        }
//        .padding()
    }
    func calcBedTime(){
        do{
            let config = MLModelConfiguration()
            let model = try BetterRest(configuration: config)
            
            // CoreML can throw 2 errors. Either while creating a model or while predicting. so we use Do Try Catch
            
            let component = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            // This is used to get the hour and minute components of wakeUp
            let hour = (component.hour ?? 0) * 60 * 60
            let minute = (component.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepBy = wakeUp - prediction.actualSleep
//            alertTitle = "Your ideal Bed Time is: "
            alertMsg = "\(sleepBy.formatted(date: .omitted, time: .shortened))"
        } catch{
//            alertTitle = "ERROR!"
            alertMsg = "There was an error calculating your Bed Time"
        }
//        showAlert = true
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
