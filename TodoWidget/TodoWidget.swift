//
//  TodoWidget.swift
//  TodoWidget
//
//  Created by Samuel Šulka on 04/04/2025.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), tasks: ["Ukážková úloha"])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: fetchTasks())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), tasks: fetchTasks())
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date())!
        completion(Timeline(entries: [entry], policy: .after(nextUpdate)))
    }

    private func fetchTasks() -> [String] {
        let defaults = UserDefaults(suiteName: "group.com.samuelsulka.todo")
        var taskTitles: [String] = []

        if let tasksData = defaults?.data(forKey: "tasksList") {
            if let decodedTasks = try? JSONDecoder().decode([TaskEntry].self, from: tasksData) {
                taskTitles = decodedTasks.prefix(3).map { $0.title }
            } else {
                print("Nepodarilo sa dekódovať TaskEntry zo 'tasksList'")
            }
        } else {
            print("Žiadne dáta v UserDefaults pre 'tasksList'")
        }

        return taskTitles
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let tasks: [String]
}
struct TaskEntry: Identifiable, Codable {
    let id: UUID
    let title: String
    let deadline: Date?
}

struct TodoWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("EASYTODO")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                Text(entry.date, style: .time)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if entry.tasks.isEmpty {
                Text("Žiadne úlohy")
                    .font(.system(.body))
                    .foregroundColor(.secondary)
                    .padding(.vertical, 4)
            } else {
                ForEach(entry.tasks, id: \.self) { task in
                                    HStack(alignment: .center) {
                                        Image(systemName: "circle")
                                            .font(.system(size: 12))
                                        Text(task)
                                            .font(.system(.body))
                                            .lineLimit(1)
                                        Spacer()
                                    }
                                    .padding(.vertical, 2)
                                }
                            }
                            Spacer()
                        }
                        .padding()
    }
}

struct TodoWidget: Widget {
    let kind: String = "TodoWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TodoWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Posledné úlohy")
        .description("Zobrazuje vaše posledné 3 úlohy.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview {
    TodoWidgetEntryView(entry: SimpleEntry(
        date: Date(),
        tasks: ["Nakúpiť potraviny", "Zavolať mame", "Dokončiť projekt"]
    ))
    .containerBackground(.fill.tertiary, for: .widget)
}
