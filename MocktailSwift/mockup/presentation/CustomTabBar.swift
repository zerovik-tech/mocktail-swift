//
//  CustomTabBar.swift
//  MocktailSwift
//
//  Created by Sachin Pandey on 28/06/24.
//

import SwiftUI

import SwiftUI

enum Tab: String, CaseIterable {
    case iphone
    case ipad
    case macbook
    case applewatch
  
}

struct CustomTabBar: View {
    @Binding var selectedTab: Tab
//    private var fillImage: String {
//        selectedTab.rawValue + ".fill"
//    }
//    private var tabColor: Color {
//        switch selectedTab {
//        case .iphone:
//            <#code#>
//        case .ipad:
//            <#code#>
//        case .macbook:
//            <#code#>
//        case .applewatch:
//            <#code#>
//        }
//    }
    
    
    var body: some View {
        VStack {
            HStack {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    Spacer()
                    HStack {
                        Image(systemName: tab.rawValue)
                            .scaleEffect(tab == selectedTab ? 1.25 : 1.0)
                            .foregroundColor(tab == selectedTab ? .blue : .gray)
                            .font(.system(size: 20))
                        
                        switch tab {
                        case .iphone:
                            Text("iPhone")
                                .font(.caption)
                                .bold()
                        case .ipad:
                            Text("iPad")
                                .font(.caption)
                                .bold()
                        case .macbook:
                            Text("Mac")
                                .font(.caption)
                                .bold()
                        case .applewatch:
                            Text("Watch")
                                .font(.caption)
                                .bold()
                        }
                        
                        
                        
                    }
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.1)) {
                                selectedTab = tab
                            }
                        }
                    Spacer()
                }
            }
            .padding(.vertical, 6)
            .background(.thinMaterial)
            .cornerRadius(10)
            
        }
    }
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(.ipad))
    }
}
