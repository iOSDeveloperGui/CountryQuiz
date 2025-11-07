//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

struct SplashView: View{
    @EnvironmentObject private var appState: AppState
    
    @State private var animate = false
    
    var body: some View{
        ZStack{
            LinearGradient(colors: [.brownn], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            
            VStack{
                
                Image("countryQuizLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .opacity(animate ? 1.0 : 0.2)
                    .scaleEffect(animate ? 1.0 : 0.2)
                
                Text("Welcome!")
                    .font(.largeTitle)
                    .foregroundStyle(Color.white)
                    .opacity(animate ? 1.0 : 0.2)
                    .scaleEffect(animate ? 1.0 : 0.2)
                
                ProgressView()
                    .frame(width: 300)
                    .tint(Color.white)
                    .opacity(animate ? 1.0 : 0.2)
                    .scaleEffect(animate ? 1.0 : 0.4)
            }
        }
        .onAppear{
            withAnimation(.bouncy(duration: 1.5)){
                animate = true
            }
        }
        .task{
            do{
                try await Task.sleep(nanoseconds: 3_000_000_000)
                self.appState.showInfo()
            } catch{
                print("Error loading the sheet: \(error)")
            }
        }
        .sheet(isPresented: $appState.showingInfoSheet){
            GameInfoSheetView()
                .environmentObject(appState)
                .interactiveDismissDisabled(true)
                .presentationDetents([.medium, .large])
                
        }
        
    }
}

#Preview {
    SplashView()
        .environmentObject(AppState(context: PersistenceController.preview.container.viewContext))
}
