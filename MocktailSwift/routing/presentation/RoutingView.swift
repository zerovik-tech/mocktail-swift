//
//  RoutingView.swift
//  Hashtag Generator Pro
//
//  Created by Sachin Pandey on 01/02/24.
//


import SwiftUI

struct RoutingView: View {
    
//    @StateObject private var stateManager : StateManager
    @StateObject private var viewModel : RoutingViewModel
    
    @StateObject private var paywallViewModel : PaywallViewModel
    
    init(viewModel: RoutingViewModel, paywallViewModel: PaywallViewModel) {
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._viewModel = StateObject(wrappedValue: viewModel)
        
    }
    
    
    var body: some View {
        
        VStack {
            switch viewModel.viewState.userflow {
            case .home:
                HomeView(paywallViewModel: paywallViewModel, routingViewModel: viewModel)
                    .preferredColorScheme(.none)
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

                
            default:
                SplashView()
                    .onAppear {
                        //show the splash view until we get the userflow
                        paywallViewModel.send(action: .userSubscriptionStatusRequested)
                        viewModel.send(action: .initialUserFlowRequested)
                    }
            }
            
        }
        .onAppear {
            let structName = String(describing: type(of: self))
            AmplitudeManager.amplitude.track(eventType : structName)
        }
        
    }
}

//struct RoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoutingView()
//    }
//}
