//
//  MocktailIosTempApp.swift
//  MocktailIosTemp
//
//  Created by Sachin Pandey on 18/06/24.
//

import SwiftUI
import RevenueCat
import AppTrackingTransparency
import PostHog


@main
struct MocktailApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared
    
    //MARK: View Models
    let paywallViewModel : PaywallViewModel
    let routingViewModel : RoutingViewModel
    let moreViewModel : MoreViewModel

    
    init() {
        
        
        let paywallRepository = PaywallRepository()
        let paywallViewInteractor = PaywallViewInteractor(repository: paywallRepository)
        paywallViewModel = PaywallViewModel(interactor: paywallViewInteractor)
        
        let routingRepository = RoutingRepository()
        let routingViewInteractor = RoutingViewInteractor(repository: routingRepository)
        routingViewModel = RoutingViewModel(interactor: routingViewInteractor)
        
        let moreRepository = MoreRepository()
        let moreViewInteractor = MoreViewInteractor(repository: moreRepository)
        moreViewModel = MoreViewModel(interactor: moreViewInteractor)
    
        
        Purchases.configure(withAPIKey: RC_API_KEY)
        Purchases.logLevel = .debug
        print("RC User ID")
        print(Purchases.shared.appUserID)
        
    }
    
    //NEWLY ADDED PERMISSIONS FOR iOS 14
    func requestPermission() {
        if #available(iOS 14, *) {
            
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    print("Authorized")
//                    print("before -> \(FacebookCore.Settings.shared.isAutoLogAppEventsEnabled)  \(FacebookCore.Settings.shared.isAdvertiserIDCollectionEnabled)")
                    
//                    FacebookCore.Settings.shared.isAutoLogAppEventsEnabled = false
                    
                    Purchases.shared.attribution.collectDeviceIdentifiers()
                    
//                    Purchases.shared.attribution.setFBAnonymousID(FacebookCore.AppEvents.shared.anonymousID)
                    
//                    Purchases.shared.attribution.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
                    
//                    AppEvents.shared.logEvent(AppEvents.Name("hekk"), parameters: [AppEvents.ParameterName("count") : 10])
                    
        
                    PostHogSDK.shared.capture(PostHogEvents.tracking_allow.rawValue)


                    
//                    Settings.shared.isAutoLogAppEventsEnabled = true
                    
//                    FacebookCore.Settings.shared.isAdvertiserTrackingEnabled = true
//                    FacebookCore.Settings.shared.isAdvertiserIDCollectionEnabled = true
                    
//                    print(ASIdentifierManager.shared().advertisingIdentifier)
//                    print("after - \(FacebookCore.Settings.shared.isAutoLogAppEventsEnabled)  \(FacebookCore.Settings.shared.isAdvertiserIDCollectionEnabled)")
//                    processAttribution()
                    // Now that we are authorized we can get the IDFA
//                    print(ASIdentifierManager.shared().advertisingIdentifier)
                    
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
//                    processAttribution()
//                    FacebookCore.Settings.shared.isAutoLogAppEventsEnabled = false
                    Purchases.shared.attribution.collectDeviceIdentifiers()   // here it will not collect nil as user rejected tracking
                    
//                    Purchases.shared.attribution.setFBAnonymousID(FacebookCore.AppEvents.shared.anonymousID)
                    
//                    Purchases.shared.attribution.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
                    
                    PostHogSDK.shared.capture(PostHogEvents.tracking_not_allow.rawValue)


                    
//                    FacebookCore.Settings.shared.isAdvertiserTrackingEnabled = false
//                    FacebookCore.Settings.shared.isAdvertiserIDCollectionEnabled = false
//                    print(ASIdentifierManager.shared().advertisingIdentifier)
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
//                    processAttribution()
                    
                    print("Not Determined")
                case .restricted:
//                    processAttribution()
                    print("Restricted")
                @unknown default:
//                    processAttribution()
                    print("Unknown")
                    
                }
            }
        }
    }
    
    @State var isConnectedToInternet : Bool = true

    var body: some Scene {
        
        WindowGroup {
            
            RoutingView(viewModel: routingViewModel, paywallViewModel: paywallViewModel, moreViewModel: moreViewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .onAppear {
                    routingViewModel.send(action: .getFirstRunStatus)
                    moreViewModel.send(action: .checkDaysFirstRun)
                    
             
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                        if let status = routingViewModel.viewState.firstRunStatus {
                            PostHogSDK.shared.capture(PostHogEvents.first_app_launch.rawValue)
                            PostHogSDK.shared.identify(Purchases.shared.appUserID)
                        }
                        
                        if(moreViewModel.viewState.daysFirstRun){
                            moreViewModel.send(action: .updateDailyLimit(to: DAILY_FREE_LIMIT))
                            moreViewModel.send(action: .setMore(moreType: .dailyFreeLimit))
                        }
                        
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
                    print("App became active")
//                    AppsFlyerLib.shared().waitForATTUserAuthorization(timeoutInterval: 30)
//                    //                        AppsFlyerLib.shared().start()
//                    AppsFlyerLib.shared().start(completionHandler: { (dictionary, error) in
//                        if (error != nil){
//                            print(error ?? "")
//                            return
//                        } else {
//                            print(dictionary ?? "")
//                            print(AppsFlyerLib.shared().getAppsFlyerUID())
//                            Purchases.shared.attribution.setAppsflyerID(AppsFlyerLib.shared().getAppsFlyerUID())
//                            return
//                        }
//                    })
                    requestPermission()
                    isConnectedToInternet = Reachability.isConnectedToNetwork()
                    if(isConnectedToInternet == false){
                        routingViewModel.send(action: .updateUserFlow(userflow: .home))
                    }
                    
                }
        }
    }
}

import SystemConfiguration


public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
