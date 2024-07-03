//
//  PaywallViewState.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import RevenueCat

enum PaywallViewState {
    
    struct ViewState {
        var allPlans: [SubscriptionPlan] = []
        var selectedPlan: SubscriptionPlan = SubscriptionPlan.empty()
        var isLoading: Bool = false
        var isProcessingPurchase: Bool = false
        #if DEBUG
        var isUserSubscribed: Bool?
        #else
        var isUserSubscribed: Bool?
        #endif
        
        var errorMessage: String?
        var alertItem: AlertItem?
        var subscriptionSuccessful: Bool = false
        var currentOffering: Offering?
    }
    
    enum Action {
        case userSubscriptionStatusRequested
        case subscriptionPlansRequested
        case currentOfferingRequested
        case continuePressed
        case restorePressed
        case subscriptionPlanChanged(plan: SubscriptionPlan)
        
        
        var eventName : String {
            switch self {
            case .userSubscriptionStatusRequested:
                return "user_subscription_status_requested"
            case .subscriptionPlansRequested:
                return "subscription_plan_requested"
            case .continuePressed :
                return "continue_pressed"
            case .restorePressed:
                return "restore_pressed"
            case .subscriptionPlanChanged:
                return "subscription_plan_changed"
            case .currentOfferingRequested:
                return "current_offering_requested"
            }
        }
        
    }
    
    enum Result {
        case success(SuccessResultValue)
        case failure(Error)
    }

    enum SuccessResultValue {
        case subscriptionPlans([SubscriptionPlan])
        case currentOffering(Offering)
        case isUserSubscribed(Bool)
        case void
    }
    
}
