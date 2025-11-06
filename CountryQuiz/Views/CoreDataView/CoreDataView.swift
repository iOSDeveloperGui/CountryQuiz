//
//  CoreDataView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import SwiftUI

struct CoreDataView: View {
    @EnvironmentObject private var viewModel: CoreDataViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color.brown.ignoresSafeArea()
                
                VStack(spacing: 0){
                    Text("🏆 Global High Scores ")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.vertical)
                    
                    List{
                        ForEach(Array(viewModel.scores.enumerated()), id: \.element.objectID) { index, score in
                            HStack{
                                Image(score.travellerImage ?? "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading){
                                    Text("\(score.travellerName ?? "Unknown") - \(score.score) Points")
                                        .font(.headline)
                                    
                                    Text(score.date ?? Date(), style: .date)
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Text("#\(index + 1)")
                                    .font(.title3)
                                    .bold()
                            }
                            .listRowBackground(Color.white.opacity(0.8))
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.insetGrouped)
                }
            }
            .toolbar{
                ToolbarItem(placement: .topBarLeading){
                    Button("Back to Game Over"){
                        dismiss()
                    }
                    .foregroundStyle(Color.white)
                }
            }
        }
        .onAppear{
            viewModel.fetchHighScores()
        }
    }
}

#Preview {
    let mockContext = PersistenceController.preview.container.viewContext
    let mockViewModel = CoreDataViewModel(viewContext: mockContext)
    
    return CoreDataView()
        .environmentObject(mockViewModel)
        .environment(\.managedObjectContext, mockContext)
}

