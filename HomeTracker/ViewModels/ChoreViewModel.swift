//
//  ChoreViewModel.swift
//  HomeTracker
//
//  Created on 5/8/25.
//

import Foundation
import SwiftUI

class ChoreViewModel: ObservableObject {
    @Published var chores: [Chore] = []
    private let choreSaveKey = "savedChores"
    
    init() {
        loadChores()
    }
    
    func addChore(title: String) {
        let newChore = Chore(title: title)
        chores.append(newChore)
        saveChores()
    }
    
    func deleteChore(at indices: IndexSet) {
        chores.remove(atOffsets: indices)
        saveChores()
    }
    
    func toggleCompleted(for chore: Chore) {
        if let index = chores.firstIndex(where: { $0.id == chore.id }) {
            chores[index].isCompleted.toggle()
            saveChores()
        }
    }
    
    func deleteCompletedChores() {
        chores.removeAll(where: { $0.isCompleted })
        saveChores()
    }
    
    private func saveChores() {
        if let encoded = try? JSONEncoder().encode(chores) {
            UserDefaults.standard.set(encoded, forKey: choreSaveKey)
        }
    }
    
    private func loadChores() {
        if let savedChores = UserDefaults.standard.data(forKey: choreSaveKey) {
            if let decodedChores = try? JSONDecoder().decode([Chore].self, from: savedChores) {
                chores = decodedChores
                return
            }
        }
        
        // Default empty chores array
        chores = []
    }
}
