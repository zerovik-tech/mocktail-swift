//
//  TwoPaywallView.swift
//  Keys AI AI Keyboard
//
//  Created by Sachin Pandey on 23/02/24.
//

import SwiftUI


import PostHog

struct TwoPaywallView: View {
    
    @StateObject private var viewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var screenWidth: CGFloat = 0
    @State private var screenHeight: CGFloat = 0
    
    let verticalSpacing = UIScreen.main.bounds.height / 94
    var showLoadingIndicator : Bool = false
    
    init(viewModel: PaywallViewModel, routingViewModel: RoutingViewModel, showLoadingIndicator: Bool) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        self.showLoadingIndicator = showLoadingIndicator
    }
    
    
    let PaywallButtonColor: Color = Color(red: 0.00, green: 0.48, blue: 1.00, opacity: 0.55)
    var body: some View {
        
        let annualPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_annual" }) ?? SubscriptionPlan.empty()
        
        let monthlyPlan = viewModel.viewState.allPlans.first(where: { $0.rcPackage?.identifier == "$rc_monthly" }) ?? SubscriptionPlan.empty()
        
        let annualPlanPrice = getSubscriptionPlanValue(from: annualPlan)
        let monthlyPlanPrice = getSubscriptionPlanValue(from: monthlyPlan)
        
        
        let discount = calculateDiscount(annualPlanPrice: annualPlanPrice, monthlyPlanPrice: monthlyPlanPrice)
      
        
        
        let annualTrialPeriod = getSubscriptionPeriodValue(from: annualPlan)
        let monthlyTrialPeriod = getSubscriptionPeriodValue(from: monthlyPlan)
        
        
        
        VStack {
            if (viewModel.viewState.isLoading || viewModel.viewState.allPlans.isEmpty) {
                if(showLoadingIndicator){
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                } else {
                    SplashView()
                }
            } else {
               
                   
                    ZStack {
//                        let screenWidth = UIScreen.main.bounds.width
//                        let screenHeight = UIScreen.main.bounds.height

                        VStack {
//                            Spacer()
                            appColor1
//                           Rectangle()
//                                .foregroundStyle(appColor1)
//                                .frame(width: screenWidth, height: screenHeight)
                                
                        }
                        
                        VStack {
                            Image("paywallBackground")
                                .resizable()
                                .scaledToFit()
                                .frame(width: screenWidth * 1.01, height: screenHeight * 0.6 )
                                
                                .edgesIgnoringSafeArea(.top)
                               
                            Spacer()
                        }
                        
                        VStack {
                            HStack {
                                Image(systemName: "multiply")
                                    .bold()
                                    .font(.title2)
                                    .foregroundStyle(Color(red: 0.08, green: 0.13, blue: 0.16))
                                    .padding(2)
//                                    .background(RoundedRectangle(cornerRadius: 4).fill(.ultraThinMaterial))
                                    .padding(.trailing)
                                    .onTapGesture {
                                        
                        
                                        PostHogSDK.shared.capture(PostHogEvents.paywall_cross.rawValue)
                                        
//                                        AppsFlyerLib.shared().logEvent(Event.af_paywall_cross.rawValue, withValues: nil)
                                        
                                        
                                        routingViewModel.send(action: .updateUserFlow(userflow: .home))
                                    }
                                    .disabled(viewModel.viewState.isProcessingPurchase)
                                
                                Spacer()
                                
                                Text("Restore")
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(Color(red: 0.08, green: 0.13, blue: 0.16))
                                    .padding(2)
//                                    .background(RoundedRectangle(cornerRadius: 4).fill(.ultraThinMaterial))
                                    .padding(.leading)
                                    .onTapGesture {
                                    
                                        PostHogSDK.shared.capture(PostHogEvents.paywall_restore.rawValue)
                                        
//                                        AppsFlyerLib.shared().logEvent(Event.af_paywall_restore.rawValue, withValues: nil)
                                        viewModel.send(action: .restorePressed)
                                    }
                                    .disabled(viewModel.viewState.isProcessingPurchase)
                            }
                            Spacer()
                        }
                        
                        .frame(width: screenWidth * 0.9, height: screenHeight * 0.9)
                        
                        
                       
                        
                        VStack {
                            Spacer()
                            HStack {
                                Text("Terms")
                                    .font(.caption)
                                    .foregroundStyle(appColor2)
                                    .underline()
                                    .onTapGesture {
                                        
                                        
                                        PostHogSDK.shared.capture(PostHogEvents.paywall_terms.rawValue)
                                        
//                                        AppsFlyerLib.shared().logEvent(Event.af_paywall_terms.rawValue, withValues: nil)
                                        if let url = URL(string: TERMS_OF_USE) {
                                            if #available(iOS 10, *) {
                                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                                            } else {
                                                UIApplication.shared.openURL(url)
                                            }
                                        }
                                    }
                                
                                Spacer()
                                
                                Text("Restore")
                                    .font(.caption)
                                    .foregroundStyle(appColor2)
                                    .underline()
                                    .onTapGesture {
                                        PostHogSDK.shared.capture(PostHogEvents.paywall_restore.rawValue)

//                                        AppsFlyerLib.shared().logEvent(Event.af_paywall_restore.rawValue, withValues: nil)
                                        viewModel.send(action: .restorePressed)
                                    }
                                    .disabled(viewModel.viewState.isProcessingPurchase)
                            }
                            .padding(.bottom)
                        }
                        .frame(width: screenWidth * 0.95, height: screenHeight * 0.95)
//                        .padding(.horizontal)
//                        .frame(width: screenWidth, height: screenHeight)

                        VStack(spacing:verticalSpacing) {
                            Spacer()
                            
                            Text("Mocktail Unlimited\nAccess")
                                .font(.largeTitle)
                                .foregroundStyle(.white)
                                .bold()
                                .multilineTextAlignment(.center)
                                .allowsTightening(true)
                                .minimumScaleFactor(0.55)
                                
                                
                            //                                .padding(.bottom)
                            
                            
                            
                            VStack(alignment: .leading, spacing: verticalSpacing) {
                                
                                
                                HStack {
                                    Image(systemName: "iphone")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .padding(6)
    
                                    
                                    Text("Unlimited mockup generation")
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                HStack {
                                    
                                    Image(systemName: "plus.square.dashed")
                                        .font(.title2)
                                        .foregroundStyle(.white)
                                        .padding(6)
                                        
                                    
                                    
                                    Text("High quality mockups")
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                
                                HStack {
                                    Image(systemName: "drop.triangle")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .padding(6)

                                    
                                    
                                    Text("Remove watermarks")
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                HStack {
                                    
                                    Image(systemName: "lightbulb.max")
                                        .font(.title3)
                                        .foregroundStyle(.white)
                                        .padding(6)

                                    
                                    Text("Unlock all features")
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                                
                                
                            }
//                            .minimumScaleFactor(0.9)
                            
                            VStack {
                                Text("⭐️⭐️⭐️⭐️⭐️")
                                    .padding(2)
                                    
                                Text("\"It helped me a lot while creating mockups. It is easy to use, and you can generate multiple mockups\"")
                                    .font(.caption2)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.center)
                                    .lineLimit(nil)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(.horizontal)
                                
                                Text("-Ashutosh")
                                    .font(.caption)
                                    .bold()
                                    .foregroundStyle(.white)
                                    
                            }
                            
                            Spacer()
                            
                            PlanCardTwoPaywall(viewModel: viewModel, plan: monthlyPlan, title: monthlyPlan.isTrialEligible ? "\(monthlyTrialPeriod)-days Free Trial" : "Monthly Plan", subtitle: "/month, cancel anytime", trialOffer: "")
                            
                            //                    viewModel: viewModel, currentPlan: weeklyPlan, title: "3-days Free Trial", subtitle: "/week, cancel anytime", trialOffer: ""
                            //
                            
                            PlanCardTwoPaywall(viewModel: viewModel, plan: annualPlan, title: annualPlan.isTrialEligible ? "\(annualTrialPeriod)-days Free Trial" : "Annual Plan", subtitle: "/year, cancel anytime", trialOffer: annualPlan.isTrialEligible ? "Save \(discount)%" : "")
                            //                    selectedPlan: viewModel.viewState.selectedPlan, currentPlan: annualPlan, title: "Billed Once", subtitle: ", Lifetime", trialOffer: "Save 90%"
                            
                            
                            
                            Button(action: {
                                PostHogSDK.shared.capture(PostHogEvents.paywall_start_plan.rawValue)

                                
//                                AppsFlyerLib.shared().logEvent(Event.af_paywall_start_plan.rawValue, withValues: nil)
                                viewModel.send(action: .continuePressed)
                            }, label:
                                    
                                    {
                                
                                if(!viewModel.viewState.isProcessingPurchase){
                                    if viewModel.viewState.selectedPlan == monthlyPlan {
                                        Text(viewModel.viewState.selectedPlan.isTrialEligible ? "Start my \(monthlyTrialPeriod)-day free trial" : "Start Plan")
                                            .font(.title3)
                                            .bold()
                                            .padding()
                                            .foregroundColor(.white)
                                            .frame(minWidth: 0, maxWidth: 350)
                                        
                                    }
                                    if viewModel.viewState.selectedPlan == annualPlan {
                                        
                                        Text(viewModel.viewState.selectedPlan.isTrialEligible ? "Start my \(annualTrialPeriod)-day free trial" : "Start Plan")
                                        
                                            .font(.title3)
                                            .bold()
                                            .padding()
                                            .foregroundColor(.white)
                                            .frame(minWidth: 0, maxWidth: 350)
                                        
                                    }
                                }else {
                                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                                    
                                        .font(.system(size: 18))
                                        .bold()
                                        .padding()
                                        .foregroundColor(.white)
                                        .frame(minWidth: 0, maxWidth: 350)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(.white, lineWidth: 0)
                                            
                                        )
                                    
                                }
                                
                            })
                            .background(appColor2)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .padding(.horizontal)
                            
                            
                            if viewModel.viewState.selectedPlan == annualPlan {
                                HStack(spacing: 1) {
                                    Image(systemName: "checkmark.shield.fill")
                                        .foregroundStyle(.green)
                                        .font(.title3)
                                    Text("No payment now")
                                        .font(.caption)
                                        .bold()
                                }
                                .opacity(viewModel.viewState.selectedPlan.isTrialEligible ? 1 : 0)
                                .padding(.bottom)
                                
                            }
                            
                            if viewModel.viewState.selectedPlan == monthlyPlan {
                                HStack(spacing: 1) {
                                    Image(systemName: "checkmark.shield.fill")
                                    //
                                        .font(.title3)
                                    Text("No payment now")
                                        .font(.caption)
                                        .bold()
                                    //
                                }
                                .opacity(viewModel.viewState.selectedPlan.isTrialEligible ? 1 : 0)
                                .padding(.bottom)
                                //
                            }
                            
                          Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        
                    }
                    .onAppear {
                        print(" monthly trial is : \(monthlyTrialPeriod)")
                        print(" annual trial is : \(annualTrialPeriod )")
                        print("discount is : \(discount)")
                        print("annual plan price : \(annualPlanPrice)")
                        print("monthly plan price: \(monthlyPlanPrice)")
                        print("annual plan is : \(annualPlan.rcPackage?.storeProduct.price)")
                        screenWidth = UIScreen.main.bounds.width
                        screenHeight = UIScreen.main.bounds.height
                    }
                    
                    
                
                .alert(item: $viewModel.viewState.alertItem) { alertItem in
                    Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                }
                //                .onAppear {
                //                    print("is trial eligible: \(viewModel.viewState.selectedPlan.isTrialEligible)")
                //                }
                .onChange(of: horizontalSizeClass) { _ in
                    screenWidth = UIScreen.main.bounds.width
                    screenHeight = UIScreen.main.bounds.height
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
        }
        .onAppear(perform: {
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
            viewModel.send(action: .subscriptionPlansRequested)
            
        })
        
        
        
    }
    
    func extractInteger(from string: String) -> Int? {
        let components = string.components(separatedBy: .whitespaces)
        
        for component in components {
            if let number = Int(component) {
                return number
            }
        }
        
        return nil
    }
    
    func getSubscriptionPeriodValue(from plan: SubscriptionPlan?) -> String {
        if let subscriptionPeriodValue = plan?.rcPackage?.storeProduct.introductoryDiscount?.subscriptionPeriod.value {
            return String(describing: subscriptionPeriodValue)
        } else {
            return ""
        }
    }
    
    func getSubscriptionPlanValue(from plan: SubscriptionPlan?) -> Float {
        
        
        if let subscriptionPlanValue = plan?.rcPackage?.storeProduct.price {
            let value = subscriptionPlanValue
            // Convert Decimal to Double
            let doubleValue = NSDecimalNumber(decimal: value).doubleValue
            
            // Convert Double to Float
            let floatValue = Float(doubleValue)
            
            return floatValue
        } else {
            return 0
        }
    }
    
    func calculateDiscount(annualPlanPrice: Float, monthlyPlanPrice: Float) -> String {
        let discountValue = (( 1 - (annualPlanPrice / (monthlyPlanPrice * 52) )) * 100)
        if discountValue.isFinite && !discountValue.isNaN {
            let discount = String(Int(discountValue))
            return discount
        }
        else {
            return ""
        }
    }
}

//#Preview {
//    TwoPaywallView()
//}

struct PlanCardTwoPaywall: View {
    
    @StateObject private var viewModel: PaywallViewModel
 
    var plan: SubscriptionPlan
    
   

    var title: String
    var subtitle: String
    var trialOffer: String
    var localizedPrice:  String  {
        plan.localizedPrice
    }
    init(viewModel: PaywallViewModel, plan: SubscriptionPlan, title: String, subtitle: String, trialOffer: String) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.plan = plan
        self.title = title
        self.subtitle = subtitle
        self.trialOffer = trialOffer
        
    }
    
    var body: some View {
        VStack{
            HStack {
                VStack(alignment: .leading)  {
                    Text(title)
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundStyle(.gray)
                    Text("\(localizedPrice)\(subtitle)")
                        .font(.subheadline)
                        .bold()
                }
                Spacer()
                
                if (!trialOffer.isEmpty) {
                    Text(trialOffer)
                        .font(.footnote)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(5)
                        .background(RoundedRectangle(cornerRadius: 10).fill(appColor2))
                }
               
            }
            
            
        }
        .padding()
        .frame(minWidth: 0, maxWidth: 350)
        .background(viewModel.viewState.selectedPlan == plan ? paywallButtonColor : .white)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .overlay(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.2).fill(viewModel.viewState.selectedPlan == plan ? appColor2 : appColor2.opacity(0.5)))
        .onTapGesture {
            if(title == "Monthly Plan"){
//                AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.paywall_weekly.rawValue)
                
//                AppsFlyerLib.shared().logEvent(Event.af_paywall_weekly.rawValue, withValues: nil)
                PostHogSDK.shared.capture(PostHogEvents.paywall_monthly.rawValue)

            }
            if(title == "Annual Plan"){
                PostHogSDK.shared.capture(PostHogEvents.paywall_annual.rawValue)

                
//                AppsFlyerLib.shared().logEvent(Event.af_paywall_annual.rawValue, withValues: nil)
            }
            viewModel.send(action: .subscriptionPlanChanged(plan: plan))
        }
    }
}
