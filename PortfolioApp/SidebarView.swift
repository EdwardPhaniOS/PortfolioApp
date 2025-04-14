//
//  SidebarView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 15/3/25.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var dataController: DataController
    let smartFilter: [Filter] = [.all, .recent]
    
    @State private var tagToRename: Tag?
    @State private var renamingTag = false
    @State private var tagName = ""

    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)]) var tags: FetchedResults<Tag>
    
    var tagFilters: [Filter] {
        tags.map { tag in
            Filter(id: tag.tagID, name: tag.tagName, icon: "tag", tag: tag)
        }
    }
    
    var body: some View {
        List(selection: $dataController.selectedFilter) {
            Section("Smart Filters") {
                ForEach(smartFilter) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                    }
                }
            }
            
            Section("Tags") {
                ForEach(tagFilters) { filter in
                    NavigationLink(value: filter) {
                        Label(filter.name, systemImage: filter.icon)
                            .badge(filter.tag?.tagActiveIssues.count ?? 0)
                            .contextMenu {
                                Button {
                                    rename(filter)
                                } label: {
                                    Label("Rename", systemImage: "pencil")
                                }
                            }
                    }
                }.onDelete(perform: delete(_:))
            }
        }
        .toolbar {
            #if DEBUG
            Button {
                dataController.deleteAll()
                dataController.createSampleData()
            } label: {
                Label("Add Sample", systemImage: "flame")
            }
            #endif
            
            Button(action: dataController.newTag) {
                Label("Add Tag", systemImage: "plus")
            }
        }
        .alert("Rename tag", isPresented: $renamingTag) {
            TextField("New name", text: $tagName)
            Button("Cancel", role: .cancel) { }
            Button("OK", action: completeRename)
        }
    }
    
    func delete(_ offsets: IndexSet) {
        for offset in offsets {
            let item = tags[offset]
            dataController.delete(item)
        }
    }
    
    func rename(_ filter: Filter) {
        tagToRename = filter.tag
        tagName = filter.name
        renamingTag = true
    }
    
    func completeRename() {
        tagToRename?.name = tagName
        dataController.save()
    }
}

#Preview {
    NavigationView {
        SidebarView()
            .environmentObject(DataController.preview)
    }
}
