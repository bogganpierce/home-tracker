//
//  ContentView.swift
//  HomeTracker
//
//  Created by Pierce Boggan on 5/8/25.
//

import SwiftUI
import Foundation

// MARK: - Model
struct Chore: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdDate: Date = Date()
    
    static func ==(lhs: Chore, rhs: Chore) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - ViewModel
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

// MARK: - ChoreRowView
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

// MARK: - AddChoreView
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

// MARK: - ContentView
struct ContentView: View {
    @StateObject private var viewModel = ChoreViewModel()
    @State private var showingAddChore = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.chores.isEmpty {
                    VStack {
                        Image(systemName: "house")
                            .font(.system(size: 60))
                            .foregroundStyle(.gray.opacity(0.3))
                        
                        Text("No chores yet")
                            .font(.title2)
                            .foregroundStyle(.gray)
                        
                        Text("Tap + to add a new chore")
                            .font(.caption)
                            .foregroundStyle(.gray)
                            .padding(.top, 1)
                    }
                } else {
                    List {
                        ForEach(viewModel.chores) { chore in
                            ChoreRowView(chore: chore) {
                                viewModel.toggleCompleted(for: chore)
                            }
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    // Find index and delete
                                    if let index = viewModel.chores.firstIndex(of: chore) {
                                        viewModel.deleteChore(at: IndexSet(integer: index))
                                    }
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Home Chores")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddChore = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
                
                if !viewModel.chores.isEmpty {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Clear Completed") {
                            viewModel.deleteCompletedChores()
                        }
                        .disabled(!viewModel.chores.contains(where: { $0.isCompleted }))
                    }
                }
            }
            .sheet(isPresented: $showingAddChore) {
                AddChoreView(viewModel: viewModel, isPresented: $showingAddChore)
                    .presentationDetents([.medium])
            }
        }
    }
}

#Preview {
    ContentView()
}
