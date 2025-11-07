//
//  GameOverButton.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import Foundation
import SwiftUI

struct GameOverButton: View{
    let title: String
    let color: Color
    let action: () -> Void
    
    var body: some View{
        Button(action: action) {
            Text(title)
                .frame(maxWidth: 300)
                .font(.title2)
                .bold()
                .padding(.vertical, 16)
                .background(color)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.3), radius: 5, y: 3)
        }
    }
}
