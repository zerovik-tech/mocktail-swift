//
//  HomeView.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 24/06/24.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = "mockup"
//    init() {
//        UITabBar.appearance().backgroundColor = UIColor.black.withAlphaComponent(0.1)
//        }
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
                            Image(systemName: "gear")
                            Text("More")
                        }
                    
                        .tag("paywall")
                }
                
                .toolbarBackground(.black.opacity(0.1), for: .tabBar)
                .toolbarBackground(.visible, for: .tabBar)
                       }
            
            
                       
        }
    }
}

#Preview {
    HomeView()
}
