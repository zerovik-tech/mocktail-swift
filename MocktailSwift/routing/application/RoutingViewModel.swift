//
//  RoutingViewModel.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import Foundation

class RoutingViewModel : ObservableObject {
    
    // only view model can access the state directly
    @Published private(set) var viewState: RoutingViewState.ViewState
    
    private let interactor : RoutingViewInteractorProtocol
    
    init(interactor : RoutingViewInteractorProtocol){
        self.interactor = interactor
        ///iinitialize state here
        self.viewState = RoutingViewState.ViewState()
    }
    
    func send(action : RoutingViewState.Action){
        switch action {
            
        case .initialUserFlowRequested:
            getInitialUserFlow()
        case .updateUserFlow(userflow: let userflow):
            updateUserFlow(userflow: userflow)
        case .getFirstRunStatus:
            getFirstRunStatus()
        }
    }
    
    ///get the first run status
    private func getFirstRunStatus()  {
        interactor.getFirstRunStatus { status in
            self.viewState.firstRunStatus = status
        }
    }
    
    
    ///updates state's userflow
    private func updateUserFlow(userflow : UserFlow){
        viewState.userflow = userflow
    }
    
    ///gets the userflow and updates the state's userflow
    private func getInitialUserFlow(){
        self.viewState.isLoading = true
        
        interactor.getInitialUserFlow { result in
            switch result {
            case .success(let userflow):
                self.viewState.userflow = userflow
                self.viewState.isLoading = false
            case .failure(let error):
                self.viewState.errorMessage = error.localizedDescription
                self.viewState.isLoading = false
            }
        }
    }
    
}
