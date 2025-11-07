//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

struct GameInfoSheetView: View{
    
    @EnvironmentObject private var appState: AppState

    var body: some View{
        VStack(spacing: 24){
            Text("Are you ready for your journey? ")
                .padding(.horizontal, 32)
                .padding(.vertical, 16)
                .multilineTextAlignment(.center)
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 20){
                
                InfoRowComponent(icon: "flag", title: "Guess the country", subTitle: "Look at the flag and pick the correct country name.")
                
                InfoRowComponent(icon: "heart", title: "Keep your hearts", subTitle: "A wrong answer costs 1 heart. Same flag stays until you get it right.")
                
                InfoRowComponent(icon: "timer", title: "Beat the timer", subTitle: "Answer before timer runs out or you lose a heart.")
                
            }
            .padding(.horizontal, 36)
            
            
            Button(action: {
                
                appState.startLevelSelect()
            }, label: {
                VStack{
                    Text("Let's play")
                        .font(.title3)
                        .foregroundStyle(Color.white)
                }
                .padding([.horizontal, .vertical], 20)
                .frame(width: 332, height: 52)
                .background(Color.brownn)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            })
            
        }
        
    }
}

#Preview {
    let mockContext = PersistenceController.preview.container.viewContext
    
    return GameInfoSheetView()
        .environmentObject(AppState(context: mockContext))
}
