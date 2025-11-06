//
//  BannerView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 06/11/25.
//

import Foundation
import SwiftUI

struct BannerView: View {
    let message: String
    
    var body: some View {
        Text(message)
            .font(.system(size: 22, weight: .bold, design: .rounded))
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 25)
            .background(
                Capsule()
                    .fill(Color.brownn)
                    .shadow(radius: 5)
            )
            .offset(y: -UIScreen.main.bounds.height / 2 + 100) 
            .zIndex(1)
    }
}

