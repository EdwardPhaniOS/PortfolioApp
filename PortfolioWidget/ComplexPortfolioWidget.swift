//
//  ComplexPortfolioWidget.swift
//  PortfolioWidgetExtension
//
//  Created by Vinh Phan on 31/12/25.
//

import WidgetKit
import SwiftUI

struct ComplexProvider: TimelineProvider {
  func placeholder(in context: Context) -> ComplexEntry {
    ComplexEntry(date: .now, issues: [.example])
  }
  
  func getSnapshot(in context: Context, completion: @escaping (ComplexEntry) -> Void) {
    let entry = ComplexEntry(date: .now, issues: loadIssues())
    completion(entry)
  }
  
  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let entry = ComplexEntry(date: .now, issues: loadIssues())
    
    let timeline = Timeline(entries: [entry], policy: .never)
    completion(timeline)
  }
  
  func loadIssues() -> [Issue] {
    let dataController = DataController()
    let request = dataController.fetchRequestForTopIssue(count: 7)
    return dataController.result(for: request)
  }
}

struct ComplexEntry: TimelineEntry {
  let date: Date
  let issues: [Issue]
}

struct ComplexPortfolioWidgetEntryView: View {
  @Environment(\.widgetFamily) var widgetFamily
  @Environment(\.dynamicTypeSize) var dynamicTypeSize
  var entry: ComplexProvider.Entry
  
  var issues: ArraySlice<Issue> {
    let issueCount: Int
    
    switch widgetFamily {
    case .systemSmall:
      issueCount = 1
    case .systemLarge, .systemExtraLarge:
      if dynamicTypeSize < .xxLarge {
        issueCount = 4
      } else {
        issueCount = 5
      }
    default:
      if dynamicTypeSize < .xLarge {
        issueCount = 2
      } else {
        issueCount = 1
      }
    }
    
    return entry.issues.prefix(issueCount)
  }
  
  var body: some View {
    VStack(spacing: 4) {
      ForEach(issues) { issue in
        Link(destination: issue.objectID.uriRepresentation()) { 
          VStack(alignment: .leading) {
            Text(issue.issueTitle)
              .font(.headline)
              .layoutPriority(1)
            
            if issue.issueTags.isEmpty == false {
              Text(issue.issueTagsList)
                .font(.subheadline)
            }
          }
          .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        }
      }
    }
  }
}

struct ComplexPortfolioWidget: Widget {
  let kind: String = "ComplexPortfolioWidget"
  
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: ComplexProvider()) { entry in
      if #available(iOS 17.0, *) {
        ComplexPortfolioWidgetEntryView(entry: entry)
          .containerBackground(.fill.opacity(0.1), for: .widget)
      } else {
        ComplexPortfolioWidgetEntryView(entry: entry)
          .padding()
          .background(Color.appTheme.viewBackground)
      }
    }
    .configurationDisplayName("Up next…")
    .description("Your most important issues")
    .supportedFamilies(
      [.systemSmall, .systemMedium, .systemLarge, .systemExtraLarge]
    )
  }
}

#Preview(as: .systemMedium) {
  ComplexPortfolioWidget()
} timeline: {
  ComplexEntry(date: .now, issues: [.example, .example, .example, .example])
  ComplexEntry(date: .now, issues: [.example, .example, .example, .example])
}
