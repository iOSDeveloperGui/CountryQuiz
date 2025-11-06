//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//
import Foundation
import SwiftUI

struct QuizView: View{
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var viewModel: QuizViewModel
    
    var body: some View{
        ZStack{
            Image("brownbg")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 0){
                    if let character = appState.selectedCharacter {
                        TravellerScoreComponent(
                            traveller: character,
                            score: viewModel.score,
                            hearts: viewModel.hearts,
                            timeRemaining: viewModel.timeRemaining
                        )
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                    
                    
                    VStack(spacing: 8){
                        Text(viewModel.currentStage)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.white)
                            .shadow(radius: 2)
                        
                        Text("Difficulty: \(viewModel.difficultName)")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(Color.white.opacity(0.8))
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                    
                    Rectangle()
                        .fill(Color.white.opacity(0.4))
                        .frame(height: 1)
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    
                    if viewModel.isLoading{
                        ProgressView("Loading...")
                            .font(.title2)
                            .foregroundStyle(.white)
                        
                    } else if let question = viewModel.currentQuestion{
                        VStack(spacing: 16){
                            Text("Do you know this country?")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .multilineTextAlignment(.center)
                                .foregroundStyle(Color.white)
                                .padding(.horizontal)
                            
                            ZStack{
                                Rectangle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 332, height: 200)
                                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.white.opacity(0.4), lineWidth: 1)
                                    )
                                
                                AsyncImage(url: URL(string: question.imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 316, height: 180)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.gray, lineWidth: 0.5)
                                        )
                                        .animation(.easeInOut, value: viewModel.showAnswerFeedback)
                                    
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 316, height: 180)
                                }
                            }
                            .padding(.top, 16)
                            .padding(.bottom, 20)
                            
                            ForEach(question.options, id: \.self){ option in
                                Button(option){
                                    viewModel.checkAnswer(answer: option)
                                }
                                .frame(width: 332, height: 60)
                                .font(.system(size: 20, weight: .medium, design: .rounded))
                                .background(
                                    self.backgroundForOption(option: option, question: question)
                                )
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .disabled(viewModel.selectedAnswer != nil)
                            }
                        }
                        .padding([.horizontal, .vertical], 20)
                        
                    }
                    
                }
                .padding(.bottom, 20)
                
                if let bannerText = viewModel.bannerText{
                    BannerView(message: bannerText)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .animation(.spring(), value: viewModel.bannerText)
                }
                
            }
            
        }
        .task {
            if viewModel.countries.isEmpty{
                await viewModel.loadData()
            }
        }
        .animation(.default, value: viewModel.score)
        .animation(.default, value: viewModel.hearts)
        .animation(.default, value: viewModel.timeRemaining)
    }
}


extension QuizView{
    @ViewBuilder
    func backgroundForOption(option: String, question: QuizQuestion) -> some View{
        if let selectedAnwser = viewModel.selectedAnswer{
            if option == selectedAnwser{
                if viewModel.showAnswerFeedback == true{
                    Color.green
                } else{
                    Color.red
                }
            } else if option == question.correctAnswer {
                Color.green.opacity(0.7)
            } else{
                Color.gray.opacity(0.5)
            }
        } else{
            Color.gray
        }
    }
}


