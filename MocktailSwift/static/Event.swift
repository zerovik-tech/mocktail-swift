//
//  Event.swift
//  Hashtag Generator Pro
//
//  Created by Karan Chilwal on 14/06/24.
//

import Foundation

enum AmplitudeEvents: String {
    case first_app_launch = "first_app_launch"
    case tracking_not_allow = "tracking_not_allow"
    case tracking_allow = "tracking_allow"
    case onboarding_next = "onboarding_next"
      
    case paywall_annual = "paywall_annual"
    case paywall_six_month = "paywall_six_month"
    case paywall_monthly = "paywall_monthly"
    case paywall_start_plan = "paywall_start_plan"
    case paywall_plan_cancelled_ = "paywall_plan_cancelled_"
    case paywall_plan_errored_ = "paywall_plan_errored_"
    case paywall_plan_subscribed_ = "paywall_plan_subscribed_"
    case paywall_restore = "paywall_restore"
    case paywall_terms = "paywall_terms"
    case paywall_privacy_policy = "paywall_privacy_policy"
    case paywall_cross = "paywall_cross"
    
    case parent_autotagai = "parent_autotagai"
    
    case tagselect_unlockalltags = " tagselect_unlockalltags"

    case tag_copied_instagram = "tagselect_copied_instagram"
    case tag_copied_cancel = "tagselect_copied_cancel"
    
    case tap_tag = "tagselect_tap_tag"
    case copy_tags = "tagselect_copy_tags"
    case selectall = "tagselect_selectall"
    case unselectall = "tagselect_unselectall"
    case add_custom_tag = "tagselect_add_custom_tag"
    
    case autotag_upload = "autotag_upload"
    case autotag_upload_success = "autotag_upload_success"
    case autotag_upload_error = "autotag_upload_error"
    
    case autotag_upload_alert = "autotag_upload_alert"
    case autotag_upload_alert_unlock = "autotag_upload_alert_unlock"
    case autotag_upload_alert_cancel = "autotag_upload_alert_cancel"
    
    case autotag_claude_start = "autotag_claude_start"
    case autotag_claude_stop = "autotag_claude_stop"
    case autotag_claude_error = "utotag_claude_error"
    
    case more_upgrade_to_pro = "more_upgrade_to_pro"
    case more_manage_subscription = "more_manage_subscription"
    case more_restore_purchases = "more_restore_purchases"
    case more_request_feature = "more_request_feature"
    case more_give_feedback = "more_give_feedback"
    case more_rateus = "more_rateus"
    case more_privacy_policy = "more_privacy_policy"
    case more_terms = "more_terms"
    case more_contact_support = "more_contact_support"
    
}
