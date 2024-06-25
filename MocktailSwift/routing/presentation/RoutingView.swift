//
//  RoutingView.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import SwiftUI
import AmplitudeSwift

struct RoutingView: View {
    
    
    @StateObject private var viewModel : RoutingViewModel
    @StateObject private var paywallViewModel : PaywallViewModel
   

    
    init(viewModel: RoutingViewModel, paywallViewModel: PaywallViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
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
                NavigationView {
                    HomeView(paywallViewModel: paywallViewModel, routingViewModel: viewModel)
                        .preferredColorScheme(.light)
                }
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
            AmplitudeManager.amplitude.track(eventType : structName)
        }
        
    }
}

//struct RoutingView_Previews: PreviewProvider {
//    static var previews: some View {
//        RoutingView()
//    }
//}
