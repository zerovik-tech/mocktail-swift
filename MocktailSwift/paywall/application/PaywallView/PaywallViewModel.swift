//
//  PaywallViewModel.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import SwiftUI



class PaywallViewModel: ObservableObject {
    
    @Published var viewState: PaywallViewState.ViewState
    
    private let interactor: PaywallViewInteractorProtocol
    
    init(interactor: PaywallViewInteractorProtocol) {
        self.interactor = interactor
        self.viewState = PaywallViewState.ViewState()
    }
    
    func send(action: PaywallViewState.Action) {
        switch action {
        case .continuePressed:
            purchasePlan()
        case .restorePressed:
            restorePlan()
        case .subscriptionPlanChanged(let plan):
            changeSelectedPlan(plan: plan)
        case .subscriptionPlansRequested:
            fetchAllPlans()
        case .userSubscriptionStatusRequested:
            checkUserSubscriptionStatus()
        case .currentOfferingRequested:
            fetchCurrentOffering()
        }
    }
    
        private func checkUserSubscriptionStatus() {
            interactor.getUserSubscriptionStatus() { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    switch result {
                    case .success(let success):
                        
                        switch success {
                            
                        case .subscriptionPlans(_):
                            self.viewState.isLoading = false
                            print("sat to false CU1")

                        case .isUserSubscribed(let status):
                            #if DEBUG
                            self.viewState.isUserSubscribed = status
                            #else
                            self.viewState.isUserSubscribed = status
                            #endif
                            
                            self.viewState.isLoading = false
                            print("sat to false CU2")

                        case .void:
                            self.viewState.isLoading = false
                            print("sat to false CU3")

                        case .currentOffering(_):
                            self.viewState.isProcessingPurchase = false
                            print("sat to false FP3")
                        }
                        
                    case .failure(let error):
                        self.viewState.errorMessage = error.localizedDescription
                        self.viewState.isLoading = false
                        print("sat to false CU4")

                    }
                }
            }
        }
    
    private func purchasePlan() {
        viewState.isProcessingPurchase = true
        
        interactor.purchaseSubscription(plan: viewState.selectedPlan) { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let success):
                    print("purchase success vm")
                    switch success {
                        
                    case .subscriptionPlans(let allPlans):
                        self.viewState.allPlans = allPlans
                        self.viewState.isProcessingPurchase = false
                    case .void:
                        self.viewState.isProcessingPurchase = false
                    case .isUserSubscribed(_):
                        print("isUserSubscribed worked ===>>>")
                        self.viewState.isProcessingPurchase = false
                        self.viewState.isUserSubscribed = true
                        self.viewState.subscriptionSuccessful = true
                    case .currentOffering(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")
                    }
                case .failure(let error):
                    self.viewState.errorMessage = error.localizedDescription
                    self.viewState.isProcessingPurchase = false
                }
            }
        }
    }
    
    private func restorePlan() {
        viewState.isProcessingPurchase = true
        
        interactor.restoreSubscription { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let success):
                    print("restore success vm")
                    switch success {
                    case .subscriptionPlans(let allPlans):
                        self.viewState.allPlans = allPlans
                        self.viewState.isProcessingPurchase = false
                    case .void:
                        self.viewState.alertItem = AlertItem(title: Text("Restoration Successful"), message: Text("Successfully Restored Purchase"), dismissButton: .default(Text("OK")))
                        self.viewState.isProcessingPurchase = false
                    case .isUserSubscribed(_):
                        self.viewState.isProcessingPurchase = false
                        self.viewState.isUserSubscribed = true
                        self.viewState.subscriptionSuccessful = true
                    case .currentOffering(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")
                    }
                case .failure(let error):
                    self.viewState.errorMessage = error.localizedDescription
                    self.viewState.alertItem = AlertItem(title: Text("Restoration Failed"), message: Text("Unable to Restore Purchase"), dismissButton: .default(Text("OK")))
                    self.viewState.isProcessingPurchase = false
                }
            }
        }
    }
    
    private func fetchAllPlans() {
        viewState.isLoading = true
        print("set to true")
        interactor.fetchSubscriptionPlans { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let success):
                    switch success {
                    case .subscriptionPlans(let allPlans):
                        self.viewState.allPlans = allPlans
                        self.viewState.selectedPlan = allPlans.first(where: { $0.rcPackage?.identifier == "$rc_annual" }) ?? SubscriptionPlan.empty()
                        print("sat to false FP1")
                        self.viewState.isLoading = false
                    case .void:
                        self.viewState.isLoading = false
                        print("sat to false FP2")

                    case .isUserSubscribed(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")

                    case .currentOffering(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")
                    }
                case .failure(let error):
                    self.viewState.errorMessage = error.localizedDescription
                    self.viewState.alertItem = AlertItem(title: Text("Connection Issue"), message: Text("Unable to fetch offers. \n Please check your internet connection and try again"), dismissButton: .default(Text("OK")))
                    self.viewState.isLoading = false
                    print("sat to false FP4")

                }
            }
        }
    }
    
    private func fetchCurrentOffering() {
        viewState.isLoading = true
        print("set to true")
        interactor.fetchCurrentOffering { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                switch result {
                case .success(let success):
                    switch success {
                    case .subscriptionPlans(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")
                    case .void:
                        self.viewState.isLoading = false
                        print("sat to false FP2")

                    case .isUserSubscribed(_):
                        self.viewState.isProcessingPurchase = false
                        print("sat to false FP3")

                    case .currentOffering(let offering):
                        self.viewState.currentOffering = offering
                        print("sat to false FP1")
                        self.viewState.isLoading = false
                    }
                case .failure(let error):
                    self.viewState.errorMessage = error.localizedDescription
                    self.viewState.alertItem = AlertItem(title: Text("Connection Issue"), message: Text("Unable to fetch offers. \n Please check your internet connection and try again"), dismissButton: .default(Text("OK")))
                    self.viewState.isLoading = false
                    print("sat to false FP4")

                }
            }
        }
    }
    
    private func changeSelectedPlan(plan: SubscriptionPlan) {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                        self.viewState.selectedPlan = plan
            }
    }
    
}
