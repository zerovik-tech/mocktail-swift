//
//  PaywallRemoteDataSource.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation

import RevenueCat

protocol PaywallRemoteDataSourceProtocol {
    
    static func fetchSubscriptionPlans(completion: @escaping (Result<[SubscriptionPlan], Error>) -> Void)
    static func fetchCurrentOffering(completion: @escaping (Result<Offering, Error>) -> Void)
    static func restoreSubscription(completion: @escaping (Result<Date, Error>) -> Void)
    static func purchaseSubscription(plan: SubscriptionPlan, completion: @escaping (Result<Date, Error>) -> Void)
    
    static func fetchSubscriptionExpiry(completion: @escaping (Result<Date, Error>) -> Void)

}

class PaywallRemoteDataSource: PaywallRemoteDataSourceProtocol {
    static func fetchSubscriptionExpiry(completion: @escaping (Result<Date, Error>) -> Void) {
        Purchases.shared.getCustomerInfo { purchaserInfo, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let customerInfo = purchaserInfo {
                if customerInfo.entitlements["app_premium"]?.isActive == true {
                    let date: Date = customerInfo.entitlements["app_premium"]?.expirationDate ?? Date.distantPast
                    completion(.success(date))
                } else {
                    completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                    return
                }
            } else {
                completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                return
            }
        }
    }
    
    static func fetchSubscriptionPlans(completion: @escaping (Result<[SubscriptionPlan], Error>) -> Void) {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let packages = offerings?.current?.availablePackages {
                // Display packages for sale
                var productIDs: [String] = []
                var allPlans = [SubscriptionPlan]()

                for package in packages {
                    productIDs.append(package.storeProduct.productIdentifier)
                }

                Purchases.shared.checkTrialOrIntroDiscountEligibility(productIdentifiers: productIDs) { eligibility in
//                    print("eligibility")
//                    print(eligibility)
                    let trialEligibility: [String: IntroEligibility] = eligibility
                    
//                        print("package-details")
                    for package in packages {
                        //                        print(package.identifier)
                        //                        print(package.localizedPriceString)
                        allPlans.append(SubscriptionPlan(identifier: package.identifier, name: package.storeProduct.localizedTitle, isTrialEligible: trialEligibility[package.storeProduct.productIdentifier]!.status == .eligible, localizedPrice: package.localizedPriceString, rcPackage: package))
//                        if package.identifier == "$rc_annual" {
//                            defaultPackage = package
//                        }
                    }
                    completion(.success(allPlans))
                    return

                                        
                }
                
                            }
        }
    }
    
    static func fetchCurrentOffering(completion: @escaping (Result<Offering, Error>) -> Void) {
        Purchases.shared.getOfferings { offerings, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            if let offering = offerings?.current {
                
//                print(offering)
//                print("offering data")
//                print(offering.getMetadataValue(for: "paywall_id", default: 10))
                completion(.success(offering))
                return
                
            }
        }
    }
    
    static func restoreSubscription(completion: @escaping (Result<Date, Error>) -> Void) {
        Purchases.shared.restorePurchases { purchaserInfo, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let customerInfo = purchaserInfo {
                if customerInfo.entitlements["app_premium"]?.isActive == true {
                    let date: Date = (customerInfo.entitlements["app_premium"]?.expirationDate)!
                    completion(.success(date))
                } else {
                    completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                    return
                }
            } else {
                completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                return
            }
        }

    }
    
    static func purchaseSubscription(plan: SubscriptionPlan, completion: @escaping (Result<Date, Error>) -> Void) {
        Purchases.shared.purchase(package: plan.rcPackage!) { transaction, purchaserInfo, error, userCancelled in
                
            print("HERE👺👺👺👺")
           
            let planIdentifier = plan.rcPackage?.storeProduct.productIdentifier

            let prefixToRemove = "$rc_"
            var modifiedString = ""
            if plan.identifier.hasPrefix(prefixToRemove) {
                // Remove the prefix
                modifiedString = plan.identifier.replacingOccurrences(of: prefixToRemove, with: "")
                  // Output: "annual"
                
            }
            
            
            if let error = error {
                completion(.failure(error))
                AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_plan_errored_.rawValue + modifiedString,eventProperties: ["planIdentifier" : planIdentifier ?? "nil"])
                return
            }
            
            if userCancelled {
                completion(.failure(PaywallError.failureReason("Customer Cancelled the Purchase")))
                AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_plan_cancelled_.rawValue + modifiedString,eventProperties: ["planIdentifier" : planIdentifier ?? "nil"])
                return
            }
            
            if let customerInfo = purchaserInfo {
                if customerInfo.entitlements["app_premium"]?.isActive == true {
                    let date: Date = (customerInfo.entitlements["app_premium"]?.expirationDate)!
                    completion(.success(date))
                    AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_plan_subscribed_.rawValue + modifiedString,eventProperties: ["planIdentifier" : planIdentifier ?? "nil"])
                } else {
                    completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                    AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_plan_errored_.rawValue + modifiedString,eventProperties: ["planIdentifier" : planIdentifier ?? "nil"])
                    return
                }
            } else {
                completion(.failure(PaywallError.failureReason("Customer Info Not Available")))
                AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_plan_errored_.rawValue + modifiedString,eventProperties: ["planIdentifier" : planIdentifier ?? "nil"])
                return
            }
        }
    }
    
    
}
