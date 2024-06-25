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
    
    
    
    
    @State private var selectedTab = "mockup"
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        }
    
    init(paywallViewModel: PaywallViewModel, routingViewModel: RoutingViewModel) {
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
    }
    
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                Group {
                    MockupView()
                        .tabItem {
                            Image(systemName: "apps.iphone")
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            Text("Mockups")
                        }
                        .tag("mockup")
                    
                    Text("this is paywall view")
                        .tabItem {
                            Image(systemName: "crown.fill")
                            Text("Premium")
                        }
                    
                        .tag("paywall")
                }
                
                .toolbarBackground(.black.opacity(0.1), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                       }
            
            
                       
        }
    }
}

//#Preview {
//    HomeView()
//}
