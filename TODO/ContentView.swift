
import SwiftUI

struct TodoItem: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var isDone: Bool
}

struct ContentView: View {
    @State private var todoItems: [TodoItem] = []
    @State private var newItem: String = ""
    @State private var isMenuOpen = false  // 👈 NEW: Zobrazenie menu

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.blue.opacity(0.23))
                .frame(width: 400, height: 1000)
                .cornerRadius(10)
                .shadow(radius: 10)
                .padding()

            VStack {
                HStack{
                    Button(action: {
                        openMenu()
                    }) {
                        Text("≡")
                            .foregroundColor(.white)
                            .padding()
                            .font(.system(size: 48))
                            .bold()
                            .padding(.horizontal,10)
                                                        
                            .cornerRadius(10)
                    }
                    Spacer()
                    Text("Debilníček")
                        .font(.largeTitle)
                        .foregroundColor(Color.white)
                        
                        
                    
                    
                        .fontWeight(.bold)
                    Spacer()
                    Spacer()
                    Spacer()
                }
                .padding(.top, 150)
                
                    
                    

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
                    Section(header: Text("TODO").foregroundColor(.white).bold()) {
                        ForEach(todoItems.filter { !$0.isDone }) { item in
                            TaskRow(item: item, toggleDone: toggleDone)
                            .listRowBackground(Color.clear)                        }
                        .onDelete(perform: deleteItem)
                    }

                    Section(header: Text("DONE").foregroundColor(.white).bold()) {
                        ForEach(todoItems.filter { $0.isDone }) { item in
                            TaskRow(item: item, toggleDone: toggleDone)
                            .listRowBackground(Color.clear)                        }
                        .onDelete(perform: deleteItem)
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .cornerRadius(10)
                .padding()

                Spacer()
            }
        }
        .sheet(isPresented: $isMenuOpen) {
            MenuView()
        }
    }

    private func toggleDone(_ item: TodoItem) {
        if let index = todoItems.firstIndex(of: item) {
            todoItems[index].isDone.toggle()
        }
    }

    private func openMenu() {
        isMenuOpen = true   // 👈 Otvorí sheet
    }

    private func addNewItem() {
        guard !newItem.isEmpty else { return }
        todoItems.append(TodoItem(title: newItem, isDone: false))
        newItem = ""
    }

    private func deleteItem(at offsets: IndexSet) {
        todoItems.remove(atOffsets: offsets)
    }
}

struct TaskRow: View {
    let item: TodoItem
    let toggleDone: (TodoItem) -> Void

    var body: some View {
        HStack {
            Text(item.title)
            Spacer()
            Image(systemName: item.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(item.isDone ? .green : .gray)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            toggleDone(item)
        }
        .padding()
        .background(Color.blue.opacity(0.23))
        .cornerRadius(10)
        .foregroundColor(.white)
    }
}

struct MenuView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Menu")
                .font(.largeTitle)
                .fontWeight(.bold)
                
            

            Button("Nastavenia") {
                print("Klik na Nastavenia")
            }
            .foregroundColor(.blue)

            Button("O aplikácii") {
                print("Klik na O aplikácii")
            }
            .foregroundColor(.green)

            Button("Zavrieť") {
                dismiss()
            }
            .foregroundColor(.red)
        }
        .padding(.top, 100)
    }

    @Environment(\.dismiss) var dismiss
}

#Preview {
    ContentView()
}
