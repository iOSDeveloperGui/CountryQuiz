//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI
import CoreData

struct GameOverView: View{
    @State private var animate: Bool = false
    @State private var showingHighScoresSheet: Bool = false
    
    let score: Int
    let onRestart: () -> Void
    
    var body: some View{
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [.brownn, .brownn]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32){
                Text("Your journey ends")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .shadow(radius: 8)
                    .scaleEffect(animate ? 1 : 0.5)
                    .opacity(animate ? 1 : 0)
                    .rotationEffect(.degrees(animate ? 0 : -10))
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: animate)
                
                Text("Final score: \(score)")
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                    .shadow(radius: 3)
                
                VStack(spacing: 20){
                    GameOverButton(
                        title: "Start New Quiz",
                        color: Color.greenEarth,
                        action: onRestart
                    )
                    
                    GameOverButton(
                        title: "View High Scores",
                        color: Color.blueEarth,
                        action: {
                            showingHighScoresSheet = true
                        }
                    )
                }
                
            }
            .padding(.horizontal)
            
        }
        .onAppear{
            animate = true
        }
        .sheet(isPresented: $showingHighScoresSheet){
            CoreDataView()
        }
        .presentationDetents([.medium])
    }
}

