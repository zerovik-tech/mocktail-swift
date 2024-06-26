//
//  MoreView.swift
//  Hashtag Generator Pro
//
//  Created by Karan Chilwal on 29/01/24.
//

import SwiftUI
import StoreKit
import RevenueCat

struct MoreView: View {
    
    
    @StateObject private var routingViewModel: RoutingViewModel
    @StateObject private var paywallViewModel: PaywallViewModel
    
    init(routingViewModel: RoutingViewModel
                  , paywallViewModel: PaywallViewModel
    ) {
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
                self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
    }
    
    @State var showManageSubscriptionSheet: Bool = false
    
    @State private var alertItem: AlertItem?
    
    let upgradeText = "Please Upgrade to use this feature."
    
    @State var alertShown : Bool = false
    
    var body: some View {
        NavigationStack {
        
        List {
            
            //MARK: Pro Settings Section
            
            #if DEBUG
            Section(){
                Button {
                    routingViewModel.send(action: .updateUserFlow(userflow: .onboarding))
                } label: {
                    HStack {
                        Label("Onboarding", systemImage: "chevron.right")
                            .labelStyle(.titleOnly)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
            }
            #endif
            
            Section(header:Text("PRO SETTINGS")) {
                
                                    if paywallViewModel.viewState.isUserSubscribed == true {
                Button(action: {
                    //                        RMetrics.recordEvent("app_setting_purchase_managed")
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_manage_subscription.rawValue)

                    
                    showManageSubscriptionSheet = true
                }) {
                    Label("Manage Subscription", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                        .foregroundColor(Color(UIColor.label))
                }.manageSubscriptionsSheet(isPresented: $showManageSubscriptionSheet)
                                    }
                                    if paywallViewModel.viewState.isUserSubscribed != true {
                
                //pro upgrade link
                Button {
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_upgrade_to_pro.rawValue)

                    routingViewModel.send(action: .updateUserFlow(userflow: .paywallWithLoading))
                } label: {
                    HStack {
                        Label("Upgrade to Pro", systemImage: "chevron.right")
                            .labelStyle(.titleOnly)
                            .foregroundColor(Color(UIColor.label))
                        Spacer()
                        Image(systemName: "chevron.forward")
                    }
                }
                //restore button
                
                Button {
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_restore_purchases.rawValue)

                                                paywallViewModel.send(action: .restorePressed)
                } label: {
                    HStack {
                        Label("Restore Purchases", systemImage: "info.circle")
                            .labelStyle(.titleOnly)
                            .foregroundColor(Color(UIColor.label))
                                                        if paywallViewModel.viewState.isProcessingPurchase {
                                                            Spacer()
                                                            ProgressView().progressViewStyle(CircularProgressViewStyle())
                                                        }
                    }
                }
                                    }
                
                
            }
            
            
            //MARK: How to use
            //                Section("User guide") {
            //                    NavigationLink {
            //                        UserGuideView()
            //                    } label: {
            //                        Text("How to use")
            //                    }
            //
            //                }
            
            //MARK: General Settings Section
            
            Section("Get in Touch") {
                NavigationLink(destination: URLView(url: URL(string: "https://tally.so/r/mK1bGz")!, title: "Customer Support")) {
                    Label("Customer Support", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                }
                NavigationLink(destination: URLView(url: URL(string: "https://tally.so/r/wLplOz")!, title: "Request Feature")) {
                    Label("Request Feature", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                }
                
                
                NavigationLink(destination: URLView(url: URL(string: "https://tally.so/r/mVJgVv")!, title: "Feedback Form")) {
                    Label("Give Feedback", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                }
                
                Button {
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_rateus.rawValue)

                    rateApp()
                } label: {
                    HStack {
                        Label("Rate Us", systemImage: "star.fill")
                            .labelStyle(.titleOnly)
                            .foregroundColor(Color(UIColor.label))
                                                    
                    }
                }
               
                
            }
            
            Section("Legal") {
                //                    NavigationLink(destination: URLView(url: URL(string: "http://roveterio.com/privacy-policy-for-live-transcribe/")!, title: "Privacy Policy")) {
                //                        Label("Privacy Policy", systemImage: "info.circle" )
                //                            .labelStyle(.titleOnly)
                //                    }
                
                //                    NavigationLink(destination: URLView(url: URL(string: "https://tally.so/r/nGZPZw")!, title: "Terms of Service")) {
                //                        Label("Privacy Policy", systemImage: "info.circle" )
                //                            .labelStyle(.titleOnly)
                //                    }
                Button(action: {
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_privacy_policy.rawValue)

                    if let url = URL(string: "https://zerovik.com/hashtag-generator-privacy-policy/?u="+Purchases.shared.appUserID) {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                }) {
                    Label("Privacy Policy", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                        .foregroundColor(Color(UIColor.label))
                    
                }
                Button(action: {
//                    AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.more_terms.rawValue)

                    if let url = URL(string: "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/") {
                        if #available(iOS 10, *) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        } else {
                            UIApplication.shared.openURL(url)
                        }
                    }
                    
                }) {
                    Label("Terms of Service", systemImage: "info.circle")
                        .labelStyle(.titleOnly)
                        .foregroundColor(Color(UIColor.label))
                    
                }
                
                
            }
            
           
            
            
        }
        
        
        
        
        
        .navigationTitle("More")
                    .alert(item: $paywallViewModel.viewState.alertItem) { alertItem in
                        Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
                    }
        
        
        
        
    }
        .onAppear {
            let structName = String(describing: type(of: self))
            AmplitudeManager.amplitude.track(eventType : structName)
        }
}
    
    func rateApp() {

        if #available(iOS 10.3, *) {

            SKStoreReviewController.requestReview()
        
        } else {

            let appID = "6477149814"
            let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
//            let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page
            
            guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
            }
        }
    }
    
    struct AlertItem: Identifiable {
        var id = UUID()
        var title: Text
        var message: Text?
        var dismissButton: Alert.Button?
        var type: AlertType? = .simple
        var actionButton: Alert.Button?
    }
    
    enum AlertType {
       case simple, action
    }
}

//#Preview {
//    MoreView()
//}
