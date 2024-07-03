//
//  PlanOptionView.swift
//  KeysAI
//
//  Created by Karan Chilwal on 02/07/24.
//

import SwiftUI
import FirebaseFirestore
import RevenueCat
import PostHog

struct PlanOptionView: View {
    
    @State var showManageSubscriptionSheet: Bool = false
    @State private var shouldNavigate : Bool = true
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink(
                    destination: CancelQueryView(shouldNavigate: $shouldNavigate),
                    label: {
                        Text("Cancel Plan")
                            .fontWeight(.semibold)
                    })
                Button(action: {
                    PostHogSDK.shared.capture(PostHogEvents.more_manage_subscription_change.rawValue)

                    showManageSubscriptionSheet = true

                }, label: {
                    HStack {
                        Text("Change Plan")
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.gray)
                            .imageScale(.small)
                    }
                })
                .manageSubscriptionsSheet(isPresented: $showManageSubscriptionSheet)

            }
            .navigationTitle("Manage Subscription")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            PostHogSDK.shared.capture(PostHogEvents.more_manage_subscription.rawValue)
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)

        }
        .onChange(of: shouldNavigate, perform: { value in
            if(!value){
                dismiss()
            }
        })
    }
}


struct CancelQueryView: View {
    let question = "Please let us know why you decided to cancel the plan?"
    let options = ["The app glitches", "I can't afford the price", "I am not ready to commit yet", "Lacks features for the price","Other"]
    
    @State private var selectedOption: String?
    @State private var navigateToTextInput = false
    @State private var navigateToSteps = false
    
    @Binding var shouldNavigate : Bool
    @Environment(\.dismiss) private var dismiss
    
    @State private var isProcessing : Bool = false
    
    var body: some View {
        NavigationStack {
            
            NavigationLink(destination: TextInputView(shouldNavigate: $shouldNavigate), isActive: $navigateToTextInput) {
                EmptyView()
            }
            
            NavigationLink(destination: StepsView(shouldNavigate: $shouldNavigate), isActive: $navigateToSteps) {
                EmptyView()
            }
            
            VStack(spacing: 20) {
                Text(question)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom,5)
                
                ForEach(options, id: \.self) { option in
                    Button(action: {
                        selectedOption = option
                    }) {
                        Text(option)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(selectedOption == option ? Color.green : Color.gray.opacity(0.2))
                            .foregroundColor(selectedOption == option ? .white : .black)
                            .cornerRadius(10)
                    }
                }
                Spacer()
                Button(action: {
                    // Handle continue action
                    isProcessing = true
                    print("Selected option: \(selectedOption ?? "")")
                    if let selectedOption = selectedOption {
                        let db = Firestore.firestore()
                        let docRef = db.collection("cancel-plan").document(Purchases.shared.appUserID)
                        
                        Task {
                            let document = try await docRef.getDocument()
                            if document.exists {
                                print("appuser already exists in firestore")
                                // this shouldnt trigger in first time
                                do {
                                    try await docRef.updateData([
                                        "reason" : selectedOption
                                    ])
                                    print("appuser updated successfully")
                                    isProcessing = false
                                    if selectedOption == "Other" {
                                        navigateToTextInput = true
                                    } else {
                                        navigateToSteps = true
                                    }
                                } catch {
                                    print("error updating appuser : \(error)")
                                    isProcessing = false
                                    if selectedOption == "Other" {
                                        navigateToTextInput = true
                                    } else {
                                        navigateToSteps = true
                                    }
                                   
                                }
   
                            } else {
                                print("appuser doesn't exists")
                                //create a user with document as appUserId
                                do {
                                    try await db.collection("cancel-plan").document(Purchases.shared.appUserID).setData([
                                        "user_id" : Purchases.shared.appUserID,
                                        "reason" : selectedOption
                                    ])
                                    print("appuser successfully registered!")
                                    isProcessing = false
                                    if selectedOption == "Other" {
                                        navigateToTextInput = true
                                    } else {
                                        navigateToSteps = true
                                    }
                                } catch {
                                    print("Error writing appuser: \(error)")
                                    isProcessing = false
                                    if selectedOption == "Other" {
                                        navigateToTextInput = true
                                    } else {
                                        navigateToSteps = true
                                    }
                                }
                            }
                        }
                        

                    }
                    
                }) {
                    Text(!isProcessing ? "Continue" : "")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isProcessing ? Color.gray : selectedOption != nil ? appColor2 : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay {
                            if(isProcessing) {
                                ProgressView()
                            }
                        }
                }
                .disabled(isProcessing ? true : selectedOption == nil)
                
                
            }
            .padding()
            .navigationTitle("Cancel Plan")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: shouldNavigate, perform: { value in
            if(!value){
                dismiss()
            }
        })
        .onAppear {
            PostHogSDK.shared.capture(PostHogEvents.more_manage_subscription_cancel.rawValue)
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)

        }
    }
}

struct TextInputView: View {
    @State private var feedback = ""
    @State private var navigateToSteps = false
    
    @Binding var shouldNavigate : Bool
    @Environment(\.dismiss) private var dismiss
    @FocusState private var keyboardFocused: Bool
    
    @State private var isProcessing : Bool = false
    
    var body: some View {
        NavigationStack {
            NavigationLink(destination: StepsView(shouldNavigate: $shouldNavigate), isActive: $navigateToSteps) {
                EmptyView()
            }
            VStack(spacing: 20) {
                Text("Please provide more details about why you want to cancel the plan.")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.bottom,5)
                
                TextField("Your feedback", text: $feedback,axis: .vertical)
                    .focused($keyboardFocused)
                    .frame(height: 150,alignment:.topLeading)
                    .padding(EdgeInsets(top: 10, leading: 6, bottom: 5, trailing: 6))
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(lineWidth: 1.0)
                    )
                    .onTapGesture {
                        keyboardFocused = true
                       
                    }
                
                Spacer()
                
                Button {
                    isProcessing = true
                    let db = Firestore.firestore()
                    let docRef = db.collection("cancel-plan").document(Purchases.shared.appUserID)
                    
                    Task {
                        let document = try await docRef.getDocument()
                        if document.exists {
                            print("appuser already exists in firestore")
                            do {
                                try await docRef.updateData([
                                    "feedback" : feedback
                                ])
                                print("appuser updated successfully")
                                isProcessing = false
                                navigateToSteps = true
                            } catch {
                                print("error updating appuser : \(error)")
                                isProcessing = false
                                navigateToSteps = true
                            }
                        } else {
                            print("appuser doesn't exists")
                            // this shouldn't execute because user should be there when user reaches here but anyway for edge case we'll create a new user with feedback
                            do {
                                try await db.collection("cancel-plan").document(Purchases.shared.appUserID).setData([
                                    "user_id" : Purchases.shared.appUserID,
                                    "feedback" : feedback
                                ])
                                print("appuser successfully registered!")
                                isProcessing = false
                                navigateToSteps = true
                            } catch {
                                print("Error writing appuser: \(error)")
                                isProcessing = false
                                navigateToSteps = true
                            }
                        }
                    }
                
                } label: {
                    Text(!isProcessing ? "Continue" : "")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isProcessing ? Color.gray : !feedback.isEmpty ? appColor2 : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .overlay {
                            if(isProcessing) {
                                ProgressView()
                            }
                        }
                }
                .disabled(isProcessing ? true : feedback.isEmpty ? true : false)
                
            }
            .padding()
            .navigationTitle("Additional Feedback")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onChange(of: shouldNavigate, perform: { value in
            if(!value){
                dismiss()
            }
        })
        .onAppear {
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
        }
    }
}

struct StepsView: View {
    @Binding var shouldNavigate : Bool
    @Environment(\.dismiss) private var dismiss
    let steps = [
        "Open the App Store on your iPhone.",
        "Tap your avatar on upper right corner.",
        "Go to Account Settings by tapping on your profile name or icon.",
        "Tap on Subscriptions.",
        "Find KeysAI in list and tap it.",
        "Tap Cancel Subscription."
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("We highly appreciate your feedback! To cancel your subscription, please do the following")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.bottom,10)
            
            ForEach(steps.indices, id: \.self) { index in
                Text("\(index + 1). \(steps[index])")
                    .fontWeight(.semibold)
                    .padding(.vertical, 3)
            }
            
            Text("You are all set to go free now. No Charges.")
                .padding(.top,5)
                .fontWeight(.semibold)
            
            Spacer()
            
            Button {
                shouldNavigate = false
                dismiss()
            } label: {
                Text("Back to Home")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(appColor2)
                    .foregroundColor(.white)
                    .cornerRadius(20)
            }

            
          
        }
        .padding()
        .navigationTitle("Next Steps")
        .onAppear {
            let structName = String(describing: type(of: self))
            PostHogSDK.shared.capture(structName)
        }
    }
}



//#Preview {
//    PlanOptionView()
//}
