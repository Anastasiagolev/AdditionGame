//
//  ContentView.swift
//  MathGame
//
//  Created by Anastasia Golev on 10/20/22.
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
    
    
    var body: some View {
        VStack{
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
