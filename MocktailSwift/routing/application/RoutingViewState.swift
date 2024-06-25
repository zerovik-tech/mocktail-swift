//
//  RoutingViewState.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import Foundation

enum RoutingViewState {
    
    struct ViewState {
        
        var userflow : UserFlow = .splash
        var isLoading : Bool = true
        var firstRunStatus : Bool?
        var errorMessage : String?
    }
    
    enum Action {
        
        case initialUserFlowRequested
        case updateUserFlow(userflow : UserFlow)
        case getFirstRunStatus
        
        var eventName : String {
            switch self {
                
            case .initialUserFlowRequested:
                return "initial_userflow_requested"
            case .updateUserFlow:
                return "update_userflow"
            case .getFirstRunStatus:
                return "get_firstrun_status"
            }
        }
        
    }
    
    enum Result {
        case success(UserFlow)
        case failure(Error)
    }
    
}
