//
//  ContentView.swift
//  MathGame
//  This game presents 2 randomly generated numbers and asks the user to choose their correct sum from a range of 4 numbers.
//  The original code is from "Let's make a Math Game for iPhone in Xcode (SwiftUI)[Part 1]" by Indently 
//  Link to tutorial video: https://www.youtube.com/watch?v=MusVlGiVro8
//  File created by Anastasia Golev on 10/20/22.
//

import SwiftUI

struct ContentView: View {
    
    //create state variables
    @State private var correctAnswer = 0
    @State private var choiceArray : [Int] = [0, 1, 2, 3]
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    //limit to sum of numbers
    @State private var difficulty = 100 //ie this will be the maximum sum of any 2 numbers (upper bound)
    @State private var score = 0
    
    //implemeting timer into ContentView
    @StateObject private var vm = ViewModel()
    private let timer = Timer.publish(every: 1,  on: .main, in: .common).autoconnect()
    private let width: Double = 250
    
    var body: some View {
    
        VStack{
            //implementing a timer to the game
            HStack{
                Text("\(vm.time)")
                    .font(.system(size: 30, weight:.medium, design: .rounded))
                    .padding()
                    .alert("Time's Up!\nYour score is: "+String(score), isPresented: $vm.showingAlert){
                        Button("Want to play again?", role:.cancel){
                            //code
                            self.score = 0
                        }
                    }
            }.onReceive(timer){ _ in
                vm.updateCounter()
            }
            HStack(spacing: 50){
                Button("Start"){
                    vm.start(minutes: vm.minutes)
                }
                .disabled((vm.isActive)) //next update: reset score here too
                Button("Reset", action: vm.reset)
                    .tint(.red)
                    .padding()
            }
            Text("\(firstNumber) + \(secondNumber)")
                .font(.largeTitle)
                .bold()
            HStack{
                ForEach(0..<2){ index in
                    Button{
                        answerIsCorrect(answer: choiceArray[index])
                        generateAnswers()
                    }label:{
                        AnswerButton(number: choiceArray[index])
                    }
                }
            }
            HStack{
                ForEach(2..<4){ index in
                    Button{
                        answerIsCorrect(answer: choiceArray[index])
                        generateAnswers()
                    }label:{
                        AnswerButton(number: choiceArray[index])
                    }
                }
            }
            Text("Score: \(score)")
                //.font(.headline)
                .font(.system(size: 20))
                .bold()
        }.onAppear(perform: generateAnswers)
    }

    
    func answerIsCorrect(answer: Int){
        let isCorrect = answer == correctAnswer ? true : false
        
        if isCorrect{
            self.score = self.score + 1
        }else{
            self.score = self.score - 1
        }
    }
    func generateAnswers(){
        firstNumber = Int.random(in: 0...(difficulty)/2)
        secondNumber = Int.random(in: 0...(difficulty)/2)
        var answerList = [Int]()//empty initially
        
        correctAnswer = firstNumber+secondNumber
        
        for _ in 0...2{
            answerList.append(Int.random(in: 0...difficulty))
        }
        answerList.append(correctAnswer)
        choiceArray = answerList.shuffled()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
