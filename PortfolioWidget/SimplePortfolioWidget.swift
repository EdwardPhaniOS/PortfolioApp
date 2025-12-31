//
//  SimplePortfolioWidget.swift
//  SimplePortfolioWidget
//
//  Created by Vinh Phan on 29/12/25.
//

import WidgetKit
import SwiftUI

struct SimpleProvider: TimelineProvider {
  func placeholder(in context: Context) -> SimpleEntry {
    SimpleEntry(date: .now, issues: [.example])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let entry = SimpleEntry(date: .now, issues: loadIssues())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let entry = SimpleEntry(date: .now, issues: loadIssues())
    
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
  
  func loadIssues() -> [Issue] {
    let dataController = DataController()
    let request = dataController.fetchRequestForTopIssue(count: 1)
    return dataController.result(for: request)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let issues: [Issue]
}

struct SimplePortfolioWidgetEntryView: View {
  var entry: SimpleProvider.Entry
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Up next…")
      
      if let issue = entry.issues.first {
        Link(destination: issue.objectID.uriRepresentation()) { 
          Text(issue.issueTitle)
            .font(.headline)
        }
      } else {
        Text("Nothing!")
          .foregroundStyle(Color.accentColor)
      }
    }
  }
}

struct SimplePortfolioWidget: Widget {
  let kind: String = "SimplePortfolioWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: SimpleProvider()) { entry in
      if #available(iOS 17.0, *) {
        SimplePortfolioWidgetEntryView(entry: entry)
          .containerBackground(.fill.opacity(0.1), for: .widget)
      } else {
        SimplePortfolioWidgetEntryView(entry: entry)
          .padding()
          .background(Color.appTheme.viewBackground)
      }
    }
    .configurationDisplayName("Up next…")
    .description("Your #1 top-priority issue")
    .supportedFamilies([.systemSmall])
  }
}

#Preview(as: .systemSmall) {
  SimplePortfolioWidget()
} timeline: {
  SimpleEntry(date: .now, issues: [.example])
  SimpleEntry(date: .now, issues: [.example])
}
