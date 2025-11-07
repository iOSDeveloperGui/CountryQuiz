//
//  CardCharacter.swift
//  CountryQuiz
//
//  Created by iOS Developer on 26/08/25.
//

import Foundation
import SwiftUI

struct CharacterCardComponent: View{
    
    let traveller: Traveller
    let isSelected: Bool
    let onSelect: () -> Void
    
    private let cardWidth: CGFloat = 180
    
    var body: some View{
        Button(action: { onSelect() }){
            ZStack{
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? Color.green.opacity(0.8) : Color.clear.opacity(0.8))
                    .stroke(isSelected ? Color.greenEarth : Color.brownn , lineWidth: 4)
                    .background(.ultraThinMaterial)
                
                VStack(spacing: 4){
                    Text(traveller.name)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                        .foregroundStyle(isSelected ? Color.white : Color.black)
                        .padding(.vertical)
                    
                    Image(traveller.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 152)
                    
                    VStack{
                        Text(traveller.description)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.white.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .lineLimit(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.all, 16)
                    .frame(height: 100, alignment: .top)
                    .background( Color.brownn.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white)
                    )
                }
                
                .frame(width: cardWidth)
                .padding(8)
            }
        }
        .frame(width: cardWidth)
        .buttonStyle(.plain)
    }
}

