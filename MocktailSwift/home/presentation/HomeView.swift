//
//  HomeView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var paywallViewModel: PaywallViewModel
    
    @StateObject private var routingViewModel: RoutingViewModel
    
    @StateObject private var moreViewModel : MoreViewModel
    
    
    @State private var selectedTab = "mockup"
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        }
    
    init(paywallViewModel: PaywallViewModel, routingViewModel: RoutingViewModel,moreViewModel : MoreViewModel) {
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        self._moreViewModel = StateObject(wrappedValue: moreViewModel)
    }
    
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                Group {
                    MockupView(paywallViewModel: paywallViewModel, routingViewModel: routingViewModel, moreViewModel: moreViewModel)
                        .tabItem {
                            Image(systemName: "apps.iphone")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Text("Mockups")
                        }
                        .tag("mockup")
                    
                    MoreView(viewModel : moreViewModel,routingViewModel: routingViewModel, paywallViewModel: paywallViewModel)
                        .tabItem {
                            Image(systemName: "gear")
                            Text("More")
                        }
                    
                        .tag("paywall")
                }
                
                .toolbarBackground(.black.opacity(0.1), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                       }
            
            
                       
        }
        .onAppear {
            moreViewModel.send(action: .getMore)
        }
    }
}

//#Preview {
//    HomeView()
//}
