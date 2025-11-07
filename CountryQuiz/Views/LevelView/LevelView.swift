//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//

import Foundation
import SwiftUI

struct LevelView: View{
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: LevelViewModel
    @State private var selectedDifficult: String? = nil
    
    var body: some View{
        NavigationStack{
            Form{
                Section(header: Text("Select your traveller").font(.headline)){
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack{
                            ForEach(viewModel.travellers){ traveller in
                                CharacterCardComponent(traveller: traveller, isSelected: appState.selectedCharacter?.id == traveller.id, onSelect:{
                                    appState.selectedCharacter = traveller
                                })
                                .padding(.horizontal)
                            }
                        }
                        .padding(.all)
                        
                    }
                }
                .listRowInsets(EdgeInsets())
                .padding(.vertical)
                
                Section(header: Text("Choose a difficulty").font(.headline)){
                    Picker("Difficulty", selection: $selectedDifficult){
                        ForEach(viewModel.difficulties, id: \.self){ difficulty in
                            Text(difficulty)
                                .tag(difficulty as String?)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
            }
            .buttonBorderShape(.roundedRectangle)
            
            Button("Start Quiz") {
                guard let difficulty = selectedDifficult
                else { return }
                
                appState.startQuiz(difficulty: difficulty)
            }
            .frame(width: 300, height: 52)
            .background(appState.selectedCharacter == nil || self.selectedDifficult == nil ? Color.gray : Color.brownn)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal)
            .padding(.vertical, 16)
            .controlSize(.large)
            
        }
        
    }
}

#Preview{
    LevelView()
        .environmentObject(AppState(context: PersistenceController.shared.container.viewContext))
        .environmentObject(LevelViewModel())
}
