[
  # Temp fix for pattern_match warnings caused by generated surface code.
  # Pattern match of the generated code seems to be always true so the false match will never succeed.
  # See '!match?' expressions in Surface.Compiler.EExEngine.build_slot_props/4 (core/deps/surface/libs/surface/compiler.eex_engine.ex:548)
  {"bundles/link/lib/console.ex", :pattern_match},
  {"bundles/link/lib/debug.ex", :pattern_match},
  {"bundles/link/lib/index.ex", :pattern_match},
  {"bundles/link/lib/marketplace.ex", :pattern_match},
  {"bundles/link/lib/onboarding/welcome.ex", :pattern_match},
  {"bundles/link/lib/onboarding/wizard.ex", :pattern_match},
  {"deps/surface/priv/catalogue/surface/components/form/example01.ex", :pattern_match},
  {"frameworks/pixel/components/button/action/redirect.ex", :pattern_match},
  {"frameworks/pixel/components/button/back_button.ex", :pattern_match},
  {"frameworks/pixel/components/button/dynamic_action.ex", :pattern_match},
  {"frameworks/pixel/components/button/dynamic_button.ex", :pattern_match},
  {"frameworks/pixel/components/button/primary_button.ex", :pattern_match},
  {"frameworks/pixel/components/button/primary_icon_button.ex", :pattern_match},
  {"frameworks/pixel/components/button/primary_wide_button.ex", :pattern_match},
  {"frameworks/pixel/components/card/campaign.ex", :pattern_match},
  {"frameworks/pixel/components/card/clickable_card.ex", :pattern_match},
  {"frameworks/pixel/components/card/highlight.ex", :pattern_match},
  {"frameworks/pixel/components/card/label.ex", :pattern_match},
  {"frameworks/pixel/components/card/primary_cta.ex", :pattern_match},
  {"frameworks/pixel/components/dropdown/selector.ex", :pattern_match},
  {"frameworks/pixel/components/form/form.ex", :pattern_match},
  {"frameworks/pixel/components/form/input.ex", :pattern_match},
  {"frameworks/pixel/components/form/input_value.ex", :pattern_match},
  {"frameworks/pixel/components/form/photo_input.ex", :pattern_match},
  {"frameworks/pixel/components/form/radio_button_group.ex", :pattern_match},
  {"frameworks/pixel/components/form/text_area.ex", :pattern_match},
  {"frameworks/pixel/components/form/url_input.ex", :pattern_match},
  {"frameworks/pixel/components/hero/hero_banner.ex", :pattern_match},
  {"frameworks/pixel/components/hero/hero_image.ex", :pattern_match},
  {"frameworks/pixel/components/navigation/button.ex", :pattern_match},
  {"frameworks/pixel/components/panel/usp.ex", :pattern_match},
  {"frameworks/pixel/components/search_bar.ex", :pattern_match},
  {"frameworks/pixel/components/widget/metric.ex", :pattern_match},
  {"frameworks/pixel/components/widget/progress.ex", :pattern_match},
  {"frameworks/pixel/components/widget/value_distribution.ex", :pattern_match},
  {"lib/core_web/image_catalog_picker.ex", :pattern_match},
  {"lib/core_web/live/console.ex", :pattern_match},
  {"lib/core_web/live/fake_survey.ex", :pattern_match},
  {"lib/core_web/live/user/await_confirmation.ex", :pattern_match},
  {"lib/core_web/live/user/confirm_token.ex", :pattern_match},
  {"lib/core_web/live/user/forms/debug.ex", :pattern_match},
  {"lib/core_web/live/user/forms/features.ex", :pattern_match},
  {"lib/core_web/live/user/forms/profile.ex", :pattern_match},
  {"lib/core_web/live/user/forms/scholar.ex", :pattern_match},
  {"lib/core_web/live/user/profile.ex", :pattern_match},
  {"lib/core_web/live/user/reset_password.ex", :pattern_match},
  {"lib/core_web/live/user/reset_password_token.ex", :pattern_match},
  {"lib/core_web/live/user/settings.ex", :pattern_match},
  {"lib/core_web/live/user/signup.ex", :pattern_match},
  {"lib/core_web/ui/container/restricted_width_area.ex", :pattern_match},
  {"lib/core_web/ui/content_list_item.ex", :pattern_match},
  {"lib/core_web/ui/dialog/selector_dialog.ex", :pattern_match},
  {"lib/core_web/ui/empty.ex", :pattern_match},
  {"lib/core_web/ui/navigation/action_bar.ex", :pattern_match},
  {"lib/core_web/ui/navigation/menu_item.ex", :pattern_match},
  {"lib/core_web/ui/navigation/navbar.ex", :pattern_match},
  {"lib/core_web/ui/navigation/tabbar_content.ex", :pattern_match},
  {"lib/core_web/ui/navigation/tabbar_footer.ex", :pattern_match},
  {"lib/core_web/ui/wallet_list_item.ex", :pattern_match},
  {"systems/admin/import_rewards_page.ex", :pattern_match},
  {"systems/admin/login_page.ex", :pattern_match},
  {"systems/admin/permissions_page.ex", :pattern_match},
  {"systems/assignment/assignment_form.ex", :pattern_match},
  {"systems/assignment/callback_page.ex", :pattern_match},
  {"systems/assignment/ethical_form.ex", :pattern_match},
  {"systems/assignment/experiment_form.ex", :pattern_match},
  {"systems/assignment/landing_page.ex", :pattern_match},
  {"systems/assignment/ticket_view.ex", :pattern_match},
  {"systems/campaign/content_page.ex", :pattern_match},
  {"systems/campaign/monitor_table_view.ex", :pattern_match},
  {"systems/campaign/monitor_view.ex", :pattern_match},
  {"systems/campaign/overview_page.ex", :pattern_match},
  {"systems/crew/reject_view.ex", :pattern_match},
  {"systems/crew/task_item_view.ex", :pattern_match},
  {"systems/data_donation/donate_page.ex", :pattern_match},
  {"systems/data_donation/execute_sheet.ex", :pattern_match},
  {"systems/data_donation/file_selection_sheet.ex", :pattern_match},
  {"systems/data_donation/flow_page.ex", :pattern_match},
  {"systems/data_donation/submit_data_sheet.ex", :pattern_match},
  {"systems/data_donation/thanks_page.ex", :pattern_match},
  {"systems/data_donation/thanks_whatsapp_account_page.ex", :pattern_match},
  {"systems/data_donation/thanks_whatsapp_chat_page.ex", :pattern_match},
  {"systems/data_donation/tool_form.ex", :pattern_match},
  {"systems/data_donation/welcome_sheet.ex", :pattern_match},
  {"systems/email/debug_form.ex", :pattern_match},
  {"systems/email/dialog.ex", :pattern_match},
  {"systems/email/form.ex", :pattern_match},
  {"systems/lab/check_in_view.ex", :pattern_match},
  {"systems/lab/day_entry_time_slot_item.ex", :pattern_match},
  {"systems/lab/day_list_item.ex", :pattern_match},
  {"systems/lab/day_view.ex", :pattern_match},
  {"systems/lab/experiment_task_view.ex", :pattern_match},
  {"systems/lab/public_page.ex", :pattern_match},
  {"systems/lab/tool_form.ex", :pattern_match},
  {"systems/next_action/overview_page.ex", :pattern_match},
  {"systems/next_action/view.ex", :pattern_match},
  {"systems/pool/pages/detail_page.ex", :pattern_match},
  {"systems/pool/pages/overview_page.ex", :pattern_match},
  {"systems/pool/pages/student_page.ex", :pattern_match},
  {"systems/pool/pages/submission_page.ex", :pattern_match},
  {"systems/pool/views/campaign_submission_view.ex", :pattern_match},
  {"systems/pool/views/campaigns_view.ex", :pattern_match},
  {"systems/pool/views/dashboard_view.ex", :pattern_match},
  {"systems/pool/views/item_view.ex", :pattern_match},
  {"systems/pool/views/students_view.ex", :pattern_match},
  {"systems/pool/views/submission_pool_view.ex", :pattern_match},
  {"systems/pool/views/submission_view.ex", :pattern_match},
  {"systems/promotion/form_view.ex", :pattern_match},
  {"systems/promotion/index_page.ex", :pattern_match},
  {"systems/promotion/landing_page.ex", :pattern_match},
  {"systems/support/helpdesk_form.ex", :pattern_match},
  {"systems/support/helpdesk_page.ex", :pattern_match},
  {"systems/support/overview_page.ex", :pattern_match},
  {"systems/support/overview_tab.ex", :pattern_match},
  {"systems/support/ticket_page.ex", :pattern_match},
  {"systems/survey/tool_form.ex", :pattern_match}
]