//
//  ContentView.swift
//  TODO
//
//  Created by Samuel Šulka on 23/12/2024.
//

import SwiftUI

struct ContentView: View {
    @State private var todoItems: [String] = []
    @State private var newItem: String = ""

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.opacity(0.23))
                .frame(width: 400, height: 1000)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()

            VStack {
                Text("Debilníček")
                    .font(.largeTitle)
                    .foregroundColor(Color.white)
                    .padding(.top, 130)
                    .fontWeight(.bold)
                
                Text("Počet úloh: \(todoItems.count)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()

                VStack(spacing: 10) {
                    TextField(" Pridaj task", text: $newItem)
                        .frame(width: 360, height: 40)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .padding(.top, 10)

                    Button(action: {
                        addNewItem()
                    }) {
                        Text("Pridať")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green.opacity(0.5))
                            .cornerRadius(10)
                    }
                }
                .padding(.top, 20)

                List {
                    ForEach(todoItems, id: \.self) { item in
                        Text(item)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color.blue.opacity(0.23))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .listRowBackground(Color.clear)
                    }
                    .onDelete(perform: deleteItem)
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
        }
    }

    // Add a new task
    private func addNewItem() {
        guard !newItem.isEmpty else { return }
        todoItems.append(newItem)
        newItem = ""
    }

    // Delete a task
    private func deleteItem(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}

#Preview {
    ContentView()
}
