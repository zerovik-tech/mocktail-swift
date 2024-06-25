//
//  PaywallView.swift
//  FancyKeys
//
//  Created by Karan Chilwal on 22/11/23.
//

import SwiftUI
import AmplitudeSwift

struct PaywallView: View {
    
    @StateObject private var viewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
    
    init(viewModel: PaywallViewModel, routingViewModel: RoutingViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
    }
    
//    @EnvironmentObject var globalState: GlobalState
//    @EnvironmentObject var appState: AppState

//    @State private var showingAlert: Bool = false
//    @State private var showRestoreFailedError = false
//    @State private var showRestoreSuccessAlert = false
//    @State private var showLoader: Bool = false
    @State private var buttonTitle = "Continue"
//    @State private var showClose = false
//    @State private var defaultPackage: Package?
//    @State private var subscribed = false
//    @State private var trialEligibility: [String: IntroEligibility]?

    var forceShowTrials = false

    var defaults = UserDefaults.standard

    @State private var alertItem: AlertItem?
    
    var body: some View {
        VStack {

            if viewModel.viewState.isLoading {
                SplashView()
            }

            else {
                Spacer()
                    // MARK: CLOSE BUTTON
                    HStack {
                        Spacer()
                        Button(action: {
//                            RMetrics.recordEvent("app_paywall_closed")
//                            Analytics.logEvent("skip_trial", parameters: nil)
//                            appState.userFlow = .sidebar
                            routingViewModel.send(action: .updateUserFlow(userflow: .home))
                        }, label: {
                                Image(systemName: "xmark")
                                .foregroundColor((viewModel.viewState.isProcessingPurchase) ? Color(UIColor.systemBackground) : .gray.opacity(0.8))
                            })
                    }





                    Spacer()

                    // MARK: Features
                    VStack(alignment: .leading) {
                        Spacer()
                        Group {
                            Image("app_icon")
                                .resizable()
                                .frame(width: 88, height: 88)
                                .cornerRadius(10)
                            Text("KeysAI")
                                .font(.system(size: 32))
                                .bold()
                                .padding(.bottom, 4)



                            Text("Premium Features")
                                .font(.system(size: 24))
                                .bold()


                            Feature(text: "Write unlimited Emails")
                            Feature(text: "Premium Keyboard Extension")
                            Feature(text: "No usage limit")
//                            Feature(text: "Request New Features")
                            Feature(text: "Get New and Advance Features")
                            Feature(text: "Cancel Anytime")
                        }
                            .padding(.bottom, 4)
                        Spacer()
                        Group {
                            Text((viewModel.viewState.selectedPlan.isTrialEligible ? "One Week Free Trial then " : "") + "Plan auto renews for \(viewModel.viewState.selectedPlan.localizedPrice)/year until cancelled.")
                                .multilineTextAlignment(TextAlignment.leading)
                                .font(.body)
                                .fixedSize(horizontal: false, vertical: true)



                            NavigationLink(destination: AllPlansView(viewModel: viewModel, routingViewModel: routingViewModel)) {
                                Text("See More Plans")
                                    .font(.body)
                            }
                            .disabled(viewModel.viewState.isProcessingPurchase)
                        }

                    }
//                    }
                    // END: UPPER PORTION

                    Spacer()
                // MARK: a - Purchase Button
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
                    .padding(.top, 32)
                    Button(action: {
                        // MARK: Restore Purchase
//                        RMetrics.recordEvent("app_product_restore_attempted")
                        viewModel.send(action: .restorePressed)

                    }) {
                        Text("Restore Purchase")
                            .font(.subheadline)
                    }.disabled(viewModel.viewState.isProcessingPurchase)


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
                    }
                    .padding(.vertical, 10)
                    .onChange(of: viewModel.viewState.isProcessingPurchase) { _ in
                        print("view vars")
                        print(viewModel.viewState.isProcessingPurchase)
                        print(viewModel.viewState.subscriptionSuccessful)
                        if viewModel.viewState.subscriptionSuccessful {
                            routingViewModel.send(action: .updateUserFlow(userflow: .home))
                        }
                    }
//                    }
                Group {
                    if viewModel.viewState.isProcessingPurchase {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
                    }
                    
//                    if viewModel.viewState.subscriptionSuccessful {
//                        Rectangle().hidden().onAppear {
//                            print("Subscription Successful Found in View")
//
//                        }
//                    }
                    
                    
                    
                    Spacer()
                }


            }
        }
        .navigationBarHidden(true)
        .padding(16)
        .onAppear(perform: {
            
            let structName = String(describing: type(of: self))
            AmplitudeManager.amplitude.track(eventType : structName)
            viewModel.send(action: .subscriptionPlansRequested)

        })


        .alert(item: $viewModel.viewState.alertItem) { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        }


    }
    
    struct Feature: View {
        var text: String
        var body: some View {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
                    .font(.system(size: 24))


                Text(text)
                    .font(.system(size: 18))
                    .bold()
            }
            .padding(2)


        }
    }

    struct AlertItem: Identifiable {
        var id = UUID()
        var title: Text
        var message: Text?
        var dismissButton: Alert.Button?
    }

}
