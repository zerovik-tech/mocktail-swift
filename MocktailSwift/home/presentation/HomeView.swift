//
//  HomeView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI
import PostHog

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
                            Image(systemName: "house")
                                .font(.title)
                            Text("Home")
                        }
                        .tag("mockup")
                    
                    
                    ThreeDMockupView()
                        .tabItem {
                            Image(systemName: "square.2.layers.3d")
                                .font(.title)
                            Text("3D")
                        }
                        .tag("3DMockup")
                    
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
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
        }
    }
}

//#Preview {
//    HomeView()
//}
