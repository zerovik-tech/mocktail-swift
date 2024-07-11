//
//  RoutingView.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import SwiftUI

import PostHog

struct RoutingView: View {
    
    
    @StateObject private var viewModel : RoutingViewModel
    @StateObject private var paywallViewModel : PaywallViewModel
    @StateObject private var moreViewModel : MoreViewModel

    
    init(viewModel: RoutingViewModel, paywallViewModel: PaywallViewModel,moreViewModel : MoreViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._moreViewModel = StateObject(wrappedValue: moreViewModel)
    }
    
    
    var body: some View {
        
        VStack {
            switch viewModel.viewState.userflow {
            
                
              
            case .onboarding:
                NavigationStack {
                    OnboardingView(paywallViewModel: paywallViewModel, routingViewModel: viewModel)
                        .preferredColorScheme(.light)
                }
            case .paywall:
                NavigationStack{
//                    PaywallView(viewModel: paywallViewModel, routingViewModel: viewModel)
                    PaywallRouter(viewModel: paywallViewModel, routingViewModel: viewModel, showLoadingIndicator: false)
                        .preferredColorScheme(.light)
                        
                }
            case .paywallWithLoading:
                NavigationStack{
//                    PaywallView(viewModel: paywallViewModel, routingViewModel: viewModel)
                    PaywallRouter(viewModel: paywallViewModel, routingViewModel: viewModel, showLoadingIndicator: true)
                        .preferredColorScheme(.light)
                }
                
            case .home:
                
                    HomeView(paywallViewModel: paywallViewModel, routingViewModel: viewModel, moreViewModel: moreViewModel)
                        .preferredColorScheme(.light)
                
            default:
                SplashView()
                    .onAppear {
                        //show the splash view until we get the userflow
                        paywallViewModel.send(action: .userSubscriptionStatusRequested)

                    }
                    .onChange(of: paywallViewModel.viewState.isUserSubscribed){ value in
                        if(value != nil){
                            viewModel.send(action: .initialUserFlowRequested)
                        }
                    }
                    .preferredColorScheme(.light)
            }
            
        }
        .onAppear {
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
        }
        
    }
}

//struct RoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoutingView()
//    }
//}
