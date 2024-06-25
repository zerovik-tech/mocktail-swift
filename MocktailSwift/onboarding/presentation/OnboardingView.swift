//
//  OnboardingView.swift
//  Teleprompter
//
//  Created by Karan Chilwal on 29/05/23.
//

import SwiftUI
//import Foundation
//import UIKit

struct OnboardingView: View {
    
    @State private var selectedPage = 0
    
    @StateObject private var paywallViewModel: PaywallViewModel
    @StateObject private var routingViewModel: RoutingViewModel
    
    init(paywallViewModel: PaywallViewModel, routingViewModel: RoutingViewModel) {
            self._paywallViewModel = StateObject(wrappedValue: paywallViewModel)
        self._routingViewModel = StateObject(wrappedValue: routingViewModel)
        UIPageControl.appearance().currentPageIndicatorTintColor = .black.withAlphaComponent(0)
            UIPageControl.appearance().pageIndicatorTintColor = .black.withAlphaComponent(0)
    }
    
    
    
    
    
    

    
    
    var body: some View {
        ScrollView((selectedPage == 4) ? [] : .horizontal, showsIndicators: false) {
                ZStack{
                    TabView(selection: $selectedPage) {

                            OnboardingSinglePage(
                                myIndex: 0,
                                selectedPage: $selectedPage,
                                image: "onboarding1",
                                title: "Hashtags Generator\nusing AI ❤️",
                                subtitle: "Let us assist you in gaining more followers and likes using popular Hashtags"
                            ).tag(0)
                            OnboardingSinglePage(
                                myIndex: 1,
                                selectedPage: $selectedPage,
                                image: "onboarding2",
                                title: "Explore Popular,\nTrending Hashtags 📈",
                                subtitle: "Boost your likes and followers by discovering our trending tag selection"
                            ).tag(1)
                            OnboardingSinglePage(
                                myIndex: 2,
                                selectedPage: $selectedPage,
                                image: "onboarding3",
                                title: "Generate Tags\nwith AI 🤖",
                                subtitle: "Instantly generate tags for your images using our Auto Tag AI feature"
                                
                            ).tag(2)
                        
                        OnboardingSinglePage(
                            myIndex: 3,
                            selectedPage: $selectedPage,
                            image: "onboarding4",
                            title: "Personalise using\nCustom Tags #️⃣",
                            subtitle: "Create custom tags to efficiently organise and manage social media hashtags",
                            isLastPage: true
                        ).tag(3)


                        VStack{
//                            ThreePaywallView(viewModel: paywallViewModel, routingViewModel : routingViewModel, showLoadingIndicator: true)
                            
                                PaywallRouter(viewModel: paywallViewModel, routingViewModel: routingViewModel, showLoadingIndicator: true)
                               
                                
                        }.tag(4)
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .never))
                    .frame(
                        width: UIScreen.main.bounds.width
//                        height: UIScreen.main.bounds.height
                    )
                    if selectedPage != 4 {
                        VStack{
                            Spacer()
                            PageIndicator(myIndex: selectedPage)
                                .padding(.vertical, 32)
                        }
                    }
                    
                }
            }
        
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            let structName = String(describing: type(of: self))
            AmplitudeManager.amplitude.track(eventType : structName)
        }
        
    }
    
    struct OnboardingSinglePage: View {
        
        var myIndex: Int
        @Binding var selectedPage: Int
        var image: String
        var title: String
        var subtitle: String
        var isLastPage: Bool?
        
        @State private var goToApp = false
        
//        var defaults = UserDefaults.standard

//        @EnvironmentObject var appState: AppState

        var body: some View {
            VStack {
//                Rectangle()
                Image(image)
                    .resizable()
                    .scaledToFit()
                    .padding(.top, 16)
//                    .ignoresSafeArea()
//                Spacer()
                VStack {
                    Group {
                        Text(title)
                            .font(.system(size: 32))
                            .bold()
                            .padding(.vertical)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                          

                        Text(subtitle)
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(maxWidth: 350, alignment: .center)
                    }
                    Spacer()
                    Button(action: {
                        //MARK: Set the onboarding shown to true if new user presses continue on third page aka 2th page
                        if isLastPage ?? false {
                            #if DEBUG
//                            AppDefaults.store(true, for: .onboardingShown)
                            #else
//                            AppDefaults.store(true, for: .onboardingShown)
                            #endif
//                            RMetrics.recordEvent("app_onboarding_completed")
//                            appState.userFlow = .paywall
                        } else {
//                            RMetrics.recordEvent("app_onboarding_continued")
                        }
                        
                                
                        AmplitudeManager.amplitude.track(eventType : AmplitudeEvents.onboarding_next.rawValue)

                        
                        withAnimation {
                            selectedPage += 1
                        }
                        
                    }, label: {
                            Text("Continue")
                                .frame(minWidth: 0, maxWidth: 300)
                                .font(.system(size: 18))
                                .padding()
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                         .stroke(.white, lineWidth: 0)
                                )
                        })
                        .background(.blue)
                        .cornerRadius(16)
//                    Group{
//                        Spacer()
//                        PageIndicator(myIndex: selectedPage)
//                    }
                    Spacer()
                }.padding(.horizontal, 16)
                Spacer()
            }
            .edgesIgnoringSafeArea(.all)
            .padding(0)
        }
    }
    
    struct PageIndicator: View {
        
        var myIndex: Int
        
        var size: CGFloat = 8
        
        var body: some View {
            HStack {
                Spacer()
                Circle()
                    .foregroundColor((myIndex == 0) ? .blue : .gray)
                    .frame(width: size, height: size)
                Circle()
                    .foregroundColor((myIndex == 1) ? .blue : .gray)
                    .frame(width: size, height: size)
                Circle()
                    .foregroundColor((myIndex == 2) ? .blue : .gray)
                    .frame(width: size, height: size)
                Circle()
                    .foregroundColor((myIndex == 3) ? .blue : .gray)
                    .frame(width: size, height: size)
                Circle()
                    .foregroundColor((myIndex == 4) ? .blue : .gray)
                    .frame(width: size, height: size)
                Spacer()
            }
        }
        
    }
}

//struct OnboardingView_Previews: PreviewProvider {
//    static var previews: some View {
//        OnboardingView()
//    }
//}

