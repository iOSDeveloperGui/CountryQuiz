//
//  TravellerScoreComponent .swift
//  CountryQuiz
//
//  Created by iOS Developer on 28/08/25.
//

import Foundation
import SwiftUI

struct TravellerScoreComponent: View{
    
    let traveller: Traveller
    let score: Int
    let hearts: Int
    let timeRemaining: Int
    
    
    var body: some View{
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.4))
            
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blueEarth.opacity(0.8), lineWidth: 4)
            
            HStack(spacing: 16){
                Image(traveller.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.yellow, lineWidth: 4)
                    )
                    .shadow(radius: 4)
    
                VStack(alignment: .leading, spacing: 6){
                
                    HStack(alignment: .bottom){
                        Text(traveller.name)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 4){
                            ForEach(0..<hearts, id: \.self){ _ in
                                Image(systemName: "heart.fill")
                                    .font(.subheadline)
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                    
                    HStack{
                        Text("Score: \(score)")
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock.fill")
                                .foregroundStyle(timeRemaining <= 10 ? .yellow : .white.opacity(0.8))
                            Text("\(timeRemaining)")
                        }
                        .font(.subheadline)
                        .foregroundStyle(timeRemaining <= 10 ? .yellow : .white)
                    }
                }
                .padding(.vertical, 8)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10) 
        }
        .frame(width: 332)
    }
}
