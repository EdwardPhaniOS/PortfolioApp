//
//  StoreView.swift
//  PortfolioApp
//
//  Created by Vinh Phan on 24/12/25.
//

import StoreKit
import SwiftUI

struct StoreView: View {
  enum LoadState {
    case loading, loaded, error
  }

  @EnvironmentObject var dataController: DataController
  @Environment(\.dismiss) var dismiss
  @State private var loadState: LoadState = .loading
  @State private var appAlert: AppAlert?

  var body: some View {
    NavigationStack {
      VStack {
        headerView
        productsView
        footerView
      }
    }
    .onChange(of: dataController.fullVersionUnlocked, { _, _ in
      checkForPurchase()
    })
    .task {
      await load()
    }
    .showAlert(item: $appAlert)
  }
}

extension StoreView {

  var headerView: some View {
    VStack {
      Image(decorative: "unlock")
        .resizable()
        .scaledToFit()
      Text("Upgrade Today!")
        .font(.title.bold())
        .fontDesign(.rounded)
        .foregroundStyle(Color.appTheme.accentContrastText)
      Text("Get the most out of the app")
          .font(.headline)
          .foregroundStyle(Color.appTheme.accentContrastText)
    }
    .infinityFrame()
    .padding(20)
    .background(Color.appTheme.accent.gradient)
  }

  var productsView: some View {
    ScrollView {
      VStack {
        switch loadState {
        case .loading:
          loadingView
        case .loaded:
          ForEach(dataController.products) { product in
            createProductView(product: product)
          }
        case .error:
          Text("Sorry, there was an error loading our store.")
            .padding(.top, 50)
        }
      }
    }
  }
  
  var loadingView: some View {
    VStack {
      Text("Loading...")
        .font(.title2.bold())
        .padding(.top, 50)
      ProgressView()
    }
  }

  func createProductView(product: Product) -> some View {
    HStack {
      VStack(alignment: .leading) {
        Text(product.displayName)
          .font(.title)
        Text(product.description)
      }

      Spacer()
      
      Text(product.displayPrice)
        .font(.title)
        .fontDesign(.rounded)
    }
    .primaryButton()
    .button(.press) {
      purchase(product)
    }
    .padding(.horizontal)
  }

  var footerView: some View {
    VStack {
      Text("Restore Purchases")
        .secondaryButton()
        .button(.press) {
          restore()
        }

      Text("Cancel")
        .plainButton(tintColor: Color.appTheme.accent)
        .button {
          dismiss()
        }
    }
    .padding(.horizontal)
  }
}

extension StoreView {
  func checkForPurchase() {
    if dataController.fullVersionUnlocked {
      dismiss()
    }
  }

  func purchase(_ product: Product) {
    guard AppStore.canMakePayments else {
      appAlert = AppAlert(title: "In-app purchases are disabled", message: """
    You can't purchase the premium unlock because in-app purchases are disabled on this device.
    
    Please ask whomever manages your device for assistance.
    """)
      return
    }

    Task { @MainActor in
      try await dataController.purchase(product)
    }
  }

  func load() async {
    loadState = .loading

    do {
      try await dataController.loadProducts()

      if dataController.products.isEmpty {
        loadState = .error
      } else {
        loadState = .loaded
      }
    } catch {
      loadState = .error
    }
  }

  func restore() {
    Task {
      try await AppStore.sync()
    }
  }
}

#Preview {
  StoreView()
    .environmentObject(DataController(inMemory: true))
}
