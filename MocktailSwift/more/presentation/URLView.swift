//
//  URLView.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import SwiftUI

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
                AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_contact_support.rawValue)

            } else if(title == "Request Feature"){
                AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_request_feature.rawValue)

            } else if(title == "Feedback Form") {
                AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_give_feedback.rawValue)

            } 
        }
    }
        
}
