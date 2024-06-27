//
//  PaywallRouter.swift
//  Fancy Keys
//
//  Created by Bhartendu Vimal Joshi on 05/01/24.
//  Copyright © 2024 Zerovik Innovations Pvt. Ltd. All rights reserved.
//

import SwiftUI
import PostHog

struct PaywallRouter: View {
    
    @StateObject private var viewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
   
    
    var showLoadingIndicator : Bool = false
    
    init(viewModel: PaywallViewModel, routingViewModel: RoutingViewModel, showLoadingIndicator: Bool) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
       
        self.showLoadingIndicator = showLoadingIndicator
    }
    
    
    var body: some View {
        VStack{
            if let currentOffering = viewModel.viewState.currentOffering {

                TwoPaywallView(viewModel: viewModel, routingViewModel: routingViewModel, showLoadingIndicator: showLoadingIndicator)
                

                
            } else {
                if(showLoadingIndicator){
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                  
                } else {
                    SplashView()
                }
//#if DEBUG
//Button(action: {
//    
//    if let status = routingViewModel.viewState.firstRunStatus {
//        if(status){
//            print("Its THE FIRST RUNNN")
//            
//            routingViewModel.send(action: .updateUserFlow(userflow: .permission))
//
//        } else {
//            print("Its NOT THE FIRST RUNNN")
//            routingViewModel.send(action: .updateUserFlow(userflow: .home))
//
//        }
//    }
//    
//}, label: {
//    Text("Skip Paywall")
//})
//#endif
                
            }
        }
        .onAppear {
                        viewModel.send(action: .currentOfferingRequested)
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
           
                    }
        .onDisappear {
            
            routingViewModel.send(action: .getFirstRunStatus)
         
        }

            
    }
}

//#Preview {
//    PaywallRouter()
//}
