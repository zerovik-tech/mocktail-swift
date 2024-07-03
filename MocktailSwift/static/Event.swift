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
        case mockup_image_uploaded = "mockup_image_uploaded"
        case mockup_image_saved = "mockup_image_saved"
        case mockup_image_replace = "mockup_image_replace"
        case mockup_device_ = "mockup_device_ "
        case mockup_image_fit = "mockup_image_fit"
        case mockup_image_fill = "mockup_image_fill"
        case mockup_image_stretch = "mockup_image_stretch"
        case mockup_star = "mockup_star"
        case mockup_clear = "mockup_clear"
    
        case alert_save_permission_denied = "alert_save_permission_denied"
        case alert_save_permission_denied_cancel = "alert_save_permission_denied_cancel"
        case alert_save_permission_denied_settings = "alert_save_permission_denied_settings"
        case alert_daily_limit = "alert_daily_limit"
        case alert_daily_limit_unlock = "alert_daily_limit_unlock"
        case alert_daily_limit_cancel = "alert_daily_limit_cancel"
        
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
        case more_manage_subscription_change = "more_manage_subscription_change"
        case more_manage_subscription_cancel = "more_manage_subscription_cancel"
        case faq_customer_support = "faq_customer_support"
        case faq_query = "faq_query"
        

    
        case notification_allowed = "notification_allowed"
        case notification_not_allowed = "notification_not_allowed"
    

}
