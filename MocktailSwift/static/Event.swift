//
//  Event.swift
//  Hashtag Generator Pro
//
//  Created by Karan Chilwal on 14/06/24.
//

import Foundation

enum PostHogEvents: String {
        case first_app_launch = "first_app_launch"
        case tracking_not_allow = "tracking_not_allow"
        case tracking_allow = "tracking_allow"
        case intro_get_started = "intro_get_started"
        case onboarding_continue = "onboarding_continue"
        case paywall_annual = "paywall_annual"
        case paywall_monthly = "paywall_monthly"
        case paywall_start_plan = "paywall_start_plan"
        case paywall_plan_cancelled_ = "paywall_plan_cancelled_"
        case paywall_plan_errored_ = "paywall_plan_errored_"
        case paywall_plan_subscribed_ = "paywall_plan_subscribed_"
        case paywall_restore = "paywall_restore"
        case paywall_terms = "paywall_terms"
        case paywall_cross = "paywall_cross"
    
    
        case mockup_ = " mockup_"
    
    
       
        
        case more_rateus = "more_rateus"
        case more_upgrade_to_pro = "more_upgrade_to_pro"
        case more_about = "more_about"
        case more_request_feature = "more_request_feature"
        case more_give_feedback = "more_give_feedback"
        case more_restore_purchases = "more_restore_purchases"
        case more_manage_subscription = "more_manage_subscription"
        case more_privacy_policy = "more_privacy_policy"
        case more_terms = "more_terms"
        case more_customer_support = "more_customer_support"
        case faq_customer_support = "faq_customer_support"
        case faq_query = "faq_query"
        
    case email_change_ol_ = "email_change_ol_"
        case email_change_tf_ = "email_change_tf_"
        case email_write_submit = "email_write_submit"
        case ask_ai_submit = "ask_ai_submit"
        case email_reply_changestatus_ = "email_reply_changestatus_"
        case email_reply_submit = "email_reply_submit"
        case email_output_rewrite = "email_output_rewrite"
        case email_output_copy = "email_output_copy"
        case email_output_share = "email_output_share"
        case keyboard_activated = "keyboard_activated"
        case keyboard_full_accessed = "keyboard_full_accessed"
        
        case activation_notification_scheduled_ = "activation_notification_scheduled_"
        case activation_notification_shown_ = "activation_notification_shown_"
        case activation_notification_tap_ = "activation_notification_tap_"
        case activation_watch_more_issue = "activation_watch_more_issue"
        case activation_watch_setup_issue = "activation_watch_setup_issue"
        case activation_email = "activation_email"
        case activation_cross = "activation_cross"
        case activation_goto_more = "activation_goto_more"
        case activation_watch_goto_more = "activation_watch_goto_more"
    
        case notification_allowed = "notification_allowed"
        case notification_not_allowed = "notification_not_allowed"
    

}
