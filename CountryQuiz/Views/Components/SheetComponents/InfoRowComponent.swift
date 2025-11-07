//
//  LevelView.swift
//  CountryQuiz
//
//  Created by iOS Developer on 25/08/25.
//
import Foundation
import SwiftUI

struct InfoRowComponent: View{
  
    let icon: String
    let title: String
    let subTitle: String
    
    var body: some View{
        HStack(alignment: .top, spacing: 12){
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.brownn)
            
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(subTitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(4)
            }
            
        }
    }
}
