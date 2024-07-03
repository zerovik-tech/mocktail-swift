//
//  ThreePaywallView.swift
//  FancyKeys
//
//  Created by Bhartendu Vimal Joshi on 10/12/23.
//

import SwiftUI


struct ThreePaywallView: View {
    
    @StateObject private var viewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
    
    var showLoadingIndicator : Bool = false
    
    init(viewModel: PaywallViewModel, routingViewModel: RoutingViewModel,showLoadingIndicator: Bool) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        self.showLoadingIndicator = showLoadingIndicator
    }
    
    var body: some View {
        let annualPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_annual" }) ?? SubscriptionPlan.empty()
        let monthlyPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_monthly" }) ?? SubscriptionPlan.empty()
        let weeklyPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_weekly" }) ?? SubscriptionPlan.empty()
        
        var subtitleText: String  {
            if (viewModel.viewState.selectedPlan == monthlyPlan ){
                return "Plan automatically renews monthly until cancelled."
            } else if (viewModel.viewState.selectedPlan == annualPlan) {
                return "Plan automatically renews annually until cancelled."
            }  else if (viewModel.viewState.selectedPlan == weeklyPlan) {
                return "Plan automatically renews weekly until cancelled."
            } else {
                return "Enjoy unlimited live transcription for lifetime."
            }
        }
        
        var trialText: String {
            if (viewModel.viewState.selectedPlan == monthlyPlan ){
                return "Three Days Free Trial then "
            } else if (viewModel.viewState.selectedPlan == annualPlan) {
                return "One Week Free Trial then "
            }  else if (viewModel.viewState.selectedPlan == weeklyPlan) {
                return "One Days Free Trial then "
            } else {
                return " "
            }
        }
        
        var durationText: String {
            if (viewModel.viewState.selectedPlan == monthlyPlan ){
                return "month"
            } else if (viewModel.viewState.selectedPlan == annualPlan) {
                return "year"
            }  else if (viewModel.viewState.selectedPlan == weeklyPlan) {
                return "week"
            } else {
                return " "
            }
        }
        
        
        @State var buttonTitle: String = "Continue"
        VStack {
            if (viewModel.viewState.isLoading || viewModel.viewState.allPlans.isEmpty) {
                if(showLoadingIndicator){
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                } else {
                    SplashView()
                }
            } else {
                GeometryReader { geometry in
                    
                    ZStack{
                        
                        VStack{
                            Image("paywall_bg")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .background(.black)
                            Spacer()
                            
                        }
                        VStack{
                            Spacer()
                            ZStack{
                                
                                RoundedRectangle(cornerSize: CGSize(width: 50, height: 50)).fill(.white)
                                    .shadow(color: .black.opacity(0.80), radius:10, y: -20)
                                    .mask(Rectangle().padding(.top, -50))
                                VStack{
                                    
                                    //                Spacer()
                                    
                                    VStack{
                                        Spacer()
                                        Text("Free Premium")
                                            .font(.title)
                                            .bold()
                                        //                                .padding(.vertical)
                                        Text("40+ Fancy Fonts")
                                            .font(.title2)
                                            .bold()
                                        //                                .padding(.vertical)
                                        Text("40+ Keyboard Themes")
                                            .font(.title2)
                                            .bold()
                                        //                                .padding(.vertical)
                                        Text("Kaomojis & Symbols")
                                            .font(.title2)
                                            .bold()
                                        //                                .padding(.vertical)
                                        Text("Unlock All Premium Features")
                                            .font(.title2)
                                            .bold()
                                        Spacer()
                                    }
                                    
                                    
                                    
                                    
                                    HStack{
                                        Button(action: {
                                            if viewModel.viewState.selectedPlan == weeklyPlan {
                                                viewModel.send(action: .continuePressed)
                                            } else {
                                                viewModel.send(action: .subscriptionPlanChanged(plan: weeklyPlan))
                                            }
                                            
                                        }, label: {
                                            VerticalPlanCard(plan: weeklyPlan, selectedPlan: viewModel.viewState.selectedPlan,title: "Weekly", titleTrial: "(3 days free)", trialOffer: "BASIC")
                                        })
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        Button(action: {
                                            if viewModel.viewState.selectedPlan == annualPlan {
                                                viewModel.send(action: .continuePressed)
                                            } else {
                                                viewModel.send(action: .subscriptionPlanChanged(plan: annualPlan))
                                            }
                                        }, label: {
                                            VerticalPlanCard(plan: annualPlan, selectedPlan: viewModel.viewState.selectedPlan,title: "Annual", titleTrial: "(7 days free)", trialOffer: "SAVE 68%")
                                        })
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        Button(action: {
                                            if viewModel.viewState.selectedPlan == monthlyPlan {
                                                viewModel.send(action: .continuePressed)
                                            } else {
                                                viewModel.send(action: .subscriptionPlanChanged(plan: monthlyPlan))
                                            }
                                        }, label: {
                                            VerticalPlanCard(plan: monthlyPlan, selectedPlan: viewModel.viewState.selectedPlan,title: "Monthly", titleTrial: "(3 days free)", trialOffer: "SAVE 22%")
                                        })
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        
                                        
                                        
                                    }
                                    
                                    VStack{
                                        //                                    Text((viewModel.viewState.selectedPlan.isTrialEligible ? "One Week Free Trial then " : "") + "Plan auto renews for \(viewModel.viewState.selectedPlan.localizedPrice)/year until cancelled.")
                                        Text((viewModel.viewState.selectedPlan.isTrialEligible ? trialText : "") + "Plan auto renews for \(viewModel.viewState.selectedPlan.localizedPrice)/\(durationText) until cancelled.")
                                            .lineLimit(2, reservesSpace: true)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal)
                                    }
                                    
                                    VStack {
                                        // MARK: a - Purchase Button
                                        Button(action: {
                                            viewModel.send(action: .continuePressed)
                                        }, label: {
                                            if(!viewModel.viewState.isProcessingPurchase){
                                                Text(buttonTitle)
                                                    .frame(minWidth: 0, maxWidth: 300)
                                                    .font(.system(size: 18))
                                                    .padding()
                                                    .foregroundColor(.white)
                                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white, lineWidth: 0))
                                            } else {
                                                ProgressView().progressViewStyle(CircularProgressViewStyle())
                                                    .frame(minWidth: 0, maxWidth: 300)
                                                    .font(.system(size: 18))
                                                    .padding()
                                                    .foregroundColor(.white)
                                                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white, lineWidth: 0))
                                            }
                                        })
                                        .background((viewModel.viewState.isProcessingPurchase) ? .gray : .blue)
                                        .cornerRadius(16)
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        .padding(.top, 32)
                                        Button(action: {
                                            // MARK: Restore Purchase
                                            //                        RMetrics.recordEvent("app_product_restore_attempted")
                                            viewModel.send(action: .restorePressed)
                                            
                                        }) {
                                            Text("Restore Purchase")
                                                .font(.subheadline)
                                        }
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        
                                    }
                                    .padding(.bottom,28)
                                    
                                    HStack {
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
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        Text("and")
                                            .font(.subheadline)
                                        Button(action: {
                                            //                         TODONE: Open Url
                                            if let url = URL(string: "https://zerovik.com/fancy-keys-privacy-policy/") {
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
                                        .disabled(viewModel.viewState.isProcessingPurchase)
                                        
                                    }
                                    .padding(.vertical, 10)
                                    //                                if viewModel.viewState.isProcessingPurchase {
                                    //                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    //
                                    //                                }
                                }
                                
                                
                            }
                            .frame(height: UIScreen.main.bounds.height*0.70)
                            
                            
                        }
                        // MARK: CLOSE BUTTON
                        VStack{
                            HStack {
                                Spacer()
                                Button(action: {
                                    routingViewModel.send(action: .updateUserFlow(userflow: .home))
                                }, label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(Color(UIColor.systemBackground))
                                    //                                    .foregroundColor((viewModel.viewState.isProcessingPurchase) ? Color(UIColor.systemBackground) : .gray.opacity(0.8))
                                })
                                .disabled(viewModel.viewState.isProcessingPurchase)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, UIScreen.main.bounds.height * 0.05)
                            Spacer()
                        }
                        
                        
                        
                    }
                    .onChange(of: viewModel.viewState.isProcessingPurchase) { _ in
                        print("view vars")
                        print(viewModel.viewState.isProcessingPurchase)
                        print(viewModel.viewState.subscriptionSuccessful)
                        if viewModel.viewState.subscriptionSuccessful {
                            routingViewModel.send(action: .updateUserFlow(userflow: .home))
                        }
                    }
                    
                    
                }
               
                .alert(item: $viewModel.viewState.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
                .ignoresSafeArea(.container, edges: .top)
            }
        } .onAppear(perform: {
           
            viewModel.send(action: .subscriptionPlansRequested)
        })
    }
}


//
//#Preview {
//    ThreePaywallView()
//}
