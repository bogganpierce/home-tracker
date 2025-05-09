//
//  AddChoreView.swift
//  HomeTracker
//
//  Created on 5/8/25.
//

import SwiftUI

struct AddChoreView: View {
    @ObservedObject var viewModel: ChoreViewModel
    @Binding var isPresented: Bool
    @State private var choreTitle: String = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Chore Details")) {
                    TextField("Enter chore title", text: $choreTitle)
                }
            }
            .navigationTitle("Add New Chore")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if !choreTitle.isEmpty {
                            viewModel.addChore(title: choreTitle)
                            isPresented = false
                        }
                    }
                    .disabled(choreTitle.isEmpty)
                }
            }
        }
    }
}
