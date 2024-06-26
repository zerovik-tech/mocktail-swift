//
//  FaqView.swift
//  Live Translator
//
//  Created by Sachin Pandey on 18/04/24.
//

import SwiftUI

struct FaqView: View {
    let verticalGap: CGFloat = 1
    let leadingPadding: CGFloat = 8
    
    var body: some View {
        NavigationStack {
            ZStack {
                
                List {
                    
                    
                    Section(header:Text("You have further questions?")) {
                        
                        ForEach(faqItems) { faqItem in
                            DisclosureGroup() {
                                Text(faqItem.answer)
                                    .padding()
                                    .font(.callout)
                                    .foregroundStyle(.gray)
                            } label: {
                                Text(faqItem.question)
                                    .onTapGesture {
                                        AmplitudeManager.amplitude.track(eventType: AmplitudeEvents.faq_query.rawValue)
                                    }
                            }
                        }
                    }
                    
                    
                    Section(header:Text("You have further questions?")) {
                        
                        NavigationLink(destination: URLView(url: URL(string: CUSTOMER_SUPPORT_URL)!, title: "Customer Support")) {
                            HStack{
                                Image(systemName: "envelope")
                                    .imageScale(.large)
                                Text("Contact Us")
                                    .font(.footnote)
                                
                                    .padding(.leading, leadingPadding)
                                ZStack {
                                    Color.white.opacity(0.001)
                                    Spacer()
                                    
                                    
                                }
                            }
                            
                            .padding(.vertical, verticalGap)

                            
                        }
                        
                    }
                }
                .listStyle(InsetGroupedListStyle())
                
                
                
                .navigationTitle("FAQ & Support")
                
            }
            .onAppear {
                let structName = String(describing: type(of: self))
                AmplitudeManager.amplitude.track(eventType : structName)
                
            }
        }
        
       
    }
}




struct FAQItem: Identifiable {
    let id = UUID()
    let question: String
    let answer: String
}
let faqItems: [FAQItem] =
    [FAQItem(question: "How to start a subscription?", answer: "Starting a subscription is easy! When you open Live Translator, a pop-up screen will appear where you can begin the subscription process."),
    FAQItem(question: "What are the subscription benefits?", answer: "Subscription provides an array of valuable features and streamlines your experience.\nHere's an overview of its offerings:\nUnlimited Translation.\nText Sharing.\n60+ Language Translation"),
    FAQItem(question: "How can I change my subscription plan?", answer: "If you're facing trouble accessing the payment screen or subscription plans while attempting to switch plans, here's a step-by-step guide: If you're currently on a trial or have an active subscription, the first step is to cancel it. Once canceled, simply click on the 'Settings' go to 'more' and then click the 'upgrade' button.\nThis process will smoothly transition you to a new subscription tier, granting you access to an even more expensive realm of Live Translator's offerings!"),
    FAQItem(question: "How to cancel my subscription?", answer: "Unfortunately, we do not have the authority to process cancellations or issue refunds directly. You will need to contact the respective app store (Apple) for assistance with your subscription cancellation. To cancel your subscription, please follow these steps:\nFor iOS (Apple) users:\n⁃ Go to the 'Settings' app on your device.\n⁃ Tap on your name and select\n'Subscriptions.'\n⁃ Find the app subscription you wish to cancel and select it.\n⁃ Choose the 'Cancel Subscription' option and confirm your choice.\nTo find out more on how to cancel your subscription, you can check the below link:\niOS: https://support.apple.com/HT202039"),
    FAQItem(question: "How can I get a refund?", answer: "Unfortunately, we don't have the authority for subscription and refund processes. Apple controls such processes very strictly to protect user privacy. You can take a look at this webpage for your problem: https:// support.apple.com/HT204084 6. Why can't I restore my previous purchase?"),
    FAQItem(question: "Why can't I restore my previous purchase?", answer: "We understand that you may have changed devices and are unable to restore your previous purchase. It's important to note that our app's purchase and access are tied to the specific device details where the purchase was made. Unfortunately, if you no longer have access to the original device or if you're using a different device, the app may not recognize your previous purchase. We apologize for any inconvenience this may cause. We continuously strive to improve our app and enhance the user experience, and your feedback is valuable to us. If you have any further questions or require additional support, please feel free to contact our customer support team. We're here to assist you."),
    FAQItem(question: "How do I report a bug or make suggestions?", answer: "Apple Support\nIf you want to cancel a subscription from Apple\nLearn how to cancel a subscription from Apple or a subscription that you purchased with an app from the App Store.\nIf you have any questions, concerns, or need assistance with our app, our dedicated customer support team is here to help. You can reach us by sending an email to support@zerovik.com. Our support team is available to provide prompt and personalized assistance to address any issues or inquiries you may have. When contacting our customer support, please provide as much detail as possible regarding your question or concern. This will enable us to better understand your specific situation and provide you with accurate and helpful support."),
    FAQItem(question: "What should I do when there is a bug?", answer: "If you encounter issues with the app not opening or crashing upon launch, it might be due to recent updates. Please follow these steps to troubleshoot:\nUpdate the App: Ensure that you have the latest version of the app installed. Go to your app store and check for updates. Updating to the latest version might resolve the issue.\nReinstall the App: If the problem persists, try uninstalling the app and reinstalling it.\nSometimes, a fresh installation can resolve issues caused by corrupted files.\nIf the problem persists, please contact our support team. Send us an email detailing the issue along with screenshots, if possible.\nThis will help us understand and address the problem more effectively.")
    
    ]


#Preview {
    FaqView()
}

