//
//  ChoreRowView.swift
//  HomeTracker
//
//  Created on 5/8/25.
//

import SwiftUI

struct ChoreRowView: View {
    let chore: Chore
    let onToggle: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onToggle) {
                Image(systemName: chore.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(chore.isCompleted ? .green : .gray)
                    .font(.title2)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(chore.title)
                .strikethrough(chore.isCompleted, color: .gray)
                .foregroundStyle(chore.isCompleted ? .gray : .primary)
                .font(.body)
                .padding(.leading, 8)
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}
