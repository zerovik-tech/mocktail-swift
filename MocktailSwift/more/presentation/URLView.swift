//
//  URLView.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import SwiftUI
import PostHog

struct URLView: View {
    
    var url: URL
    var title: String
    
    @State private var shouldRefresh = false
    
    var body: some View {
        VStack{
            URLWebView(url: url, reload: $shouldRefresh)
//            EmptyView()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if(title == "Customer Support"){
                PostHogSDK.shared.capture(PostHogEvents.more_customer_support.rawValue)

            } else if(title == "Request Feature"){
                PostHogSDK.shared.capture(PostHogEvents.more_request_feature.rawValue)

            } else if(title == "Feedback Form") {
                PostHogSDK.shared.capture(PostHogEvents.more_give_feedback.rawValue)

            } 
        }
    }
        
}
