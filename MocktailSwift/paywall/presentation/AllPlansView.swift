//
//  AllPlansView.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 05/12/23.
//

import Foundation
import SwiftUI
import RevenueCat


struct AllPlansView: View {
    
    @StateObject private var viewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
    
    init(viewModel: PaywallViewModel, routingViewModel: RoutingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
    }
    
    //    @EnvironmentObject var globalState: GlobalState
    //    @EnvironmentObject var appState: AppState
    
//    @State var selectedPlan = 2
    @State var buttonTitle = "Continue"
//    @State var showLoader = false
//    @State var showingAlert = false
    
//    @State var monthlyPlanDetails: Package?
//    @State var annualPlanDetails: Package?
    
//    @State var trialEligibility: [String: IntroEligibility]?
    
    var forceShowTrials = false
    
    //    init() {
    //        RMetrics.recordEvent("app_paywall_allplans_viewed")
    //    }
    
    
    
    
    var body: some View {
        
        let annualPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_annual" }) ?? SubscriptionPlan.empty()
        let monthlyPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_monthly" }) ?? SubscriptionPlan.empty()
        let weeklyPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_weekly" }) ?? SubscriptionPlan.empty()
        
        var subtitleText: String  {
            if (viewModel.viewState.selectedPlan == monthlyPlan ){
                return "Plan automatically renews monthly until cancelled."
            } else if (viewModel.viewState.selectedPlan == annualPlan) {
                return "Plan automatically renews annually until cancelled."
            }
            else if (viewModel.viewState.selectedPlan == weeklyPlan) {
                return "Plan automatically renews weekly until cancelled."
            }
            else {
                return ""
            }
        }
        
        
        
        
        VStack{
            HStack{
                Text("Choose a plan")
                    .font(.system(size: 32))
                    .bold()
            }
            VStack{
                Button(action: {
                    //                    RMetrics.recordEvent("app_paywall_product_changed")
                    viewModel.send(action: .subscriptionPlanChanged(plan: weeklyPlan))
                }, label: {
                    PlanCard(
                        plan: weeklyPlan,
                        selectedPlan: viewModel.viewState.selectedPlan,
                        title: "Weekly" + (weeklyPlan.isTrialEligible ? " (3 Day Trial)" : ""),
                        subtitle: weeklyPlan.localizedPrice+"/week"
                    )
                })
                
                Button(action: {
                    //                    RMetrics.recordEvent("app_paywall_product_changed")
                    viewModel.send(action: .subscriptionPlanChanged(plan: annualPlan))
                }, label: {
                    PlanCard(
                        plan: annualPlan,
                        selectedPlan: viewModel.viewState.selectedPlan,
                        title: "Annual" + (annualPlan.isTrialEligible ? " (1 Week Trial)" : ""),
                        subtitle: annualPlan.localizedPrice+"/year"
                    )
                })
                
//                Button(action: {
//                    //                    RMetrics.recordEvent("app_paywall_product_changed")
//                    viewModel.send(action: .subscriptionPlanChanged(plan: monthlyPlan))
//                }, label: {
//                    PlanCard(
//                        plan: monthlyPlan,
//                        selectedPlan: viewModel.viewState.selectedPlan,
//                        title: "Monthly" + (monthlyPlan.isTrialEligible ? " (3 Day Trial)" : ""),
//                        subtitle: monthlyPlan.localizedPrice+"/month"
//                    )
//                })
                
                
                //                Button(action: {
                //                    selectedPlan = 3
                //                }, label: {
                //                    PlanCard(planId: 3, selectedPlan: selectedPlan, title: "Lifetime", subtitle: "$ 99.99 once")
                //                })
            }
            Spacer()
            VStack {
                Text(subtitleText)
                    .font(.caption)
                    .foregroundColor(.gray)
                Button(action: {
                    viewModel.send(action: .continuePressed)
                }, label: {
                    Text(buttonTitle)
                        .frame(minWidth: 0, maxWidth: 300)
                        .font(.system(size: 18))
                        .padding()
                        .foregroundColor(.white)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white, lineWidth: 0))
                })
                .background((viewModel.viewState.isProcessingPurchase) ? .gray : .blue)
                .cornerRadius(16)
                .disabled(viewModel.viewState.isProcessingPurchase)
                
            }
            
            
        }.padding(16)
            .onAppear(perform: {
                //                    RMetrics.recordEvent("app_paywall_allplans_viewed")
              
            })
        
        .navigationBarTitleDisplayMode(.inline)
        
        HStack{
            Button(action: {
                // TODONE: Open Url
                if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            }, label: {
                Text("Terms of Service")
                    .font(.subheadline)
            })
            Text("and")
                .font(.subheadline)
            Button(action: {
                //                         TODONE: Open Url
                if let url = URL(string: "https://www.freeprivacypolicy.com/live/cfeee37b-0c93-4bc8-ac4b-fd25ff754886") {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
            }, label: {
                Text("Privacy Policy")
                    .font(.subheadline)
            })
            
        }.padding(.vertical)
            .onChange(of: viewModel.viewState.isProcessingPurchase) { _ in
                print("view vars")
                print(viewModel.viewState.isProcessingPurchase)
                print(viewModel.viewState.subscriptionSuccessful)
                if viewModel.viewState.subscriptionSuccessful {
                    routingViewModel.send(action: .updateUserFlow(userflow: .home))
                }
            }
        
        
        
        if viewModel.viewState.isProcessingPurchase {
            ProgressView().progressViewStyle(CircularProgressViewStyle())
        }
        
//        if viewModel.viewState.subscriptionSuccessful {
//            Rectangle().hidden().onAppear {
//                print("Subscription Successful Found in View")
//                routingViewModel.send(action: .updateUserFlow(userFlow: .sidebar))
//            }
//        }
        
           
        
    }
    
    struct PlanCard: View {
        
        var plan: SubscriptionPlan
        var selectedPlan: SubscriptionPlan
        var title: String
        var subtitle: String
        
        var isActive:Bool {
            (plan.identifier == selectedPlan.identifier)
        }
        
        var body: some View {
            HStack{
                VStack {
                    HStack{
                        Text(title)
                            .foregroundColor(isActive ? .white : nil)
                            .bold()
                            .font(.system(size: 24))
                        Spacer()
                    }
                    
                    HStack{
                        Text(subtitle)
                            .foregroundColor(isActive ? .white : nil)
                            .bold()
                        Spacer()
                    }
                }
                if isActive {
                    VStack{
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                    }
                }
                
            }
            .padding()
            .background(
                isActive ?
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(
                    LinearGradient(
                        gradient: Gradient(
                            
                            colors: [.indigo, .pink]
                        ),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                :
                    nil
            )
            .overlay(
                isActive ?
                nil
                :
                    RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.blue, lineWidth: 1)
            )
        }
    }
    
}
