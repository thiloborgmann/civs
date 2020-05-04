use lib '.';
use lib 'cgi-bin';
use languages;

my $cr = "\r\n";

&languages::init($ARGV[0]);

print $languages::log;

print $tx->Condorcet_Internet_Voting_Service, $cr;
print $tx->Condorcet_Internet_Voting_Service_email_hdr, $cr;
print $tx->about_civs, $cr;
print $tx->create_new_poll, $cr;
print $tx->about_security_and_privacy, $cr;
print $tx->FAQ, $cr;
print $tx->CIVS_suggestion_box, $cr;
print $tx->unable_to_process, $cr;
print $tx->CIVS_Error, $cr;
print $tx->CIVS_server_busy, $cr;
print $tx->Sorry_the_server_is_busy, $cr;
print $tx->mail_has_been_sent, $cr;
print $tx->click_on_the_URL_to_start, $cr;
print $tx->here_is_the_control_URL, $cr;
print $tx->the_poll_is_in_progress, $cr;
print $tx->CIVS_Poll_Creation, $cr;
print $tx->Poll_created, $cr;
print $tx->Address_unacceptable, $cr;
print $tx->Poll_must_have_two_choices, $cr;
print $tx->Poll_directory_not_writeable, $cr;
print $tx->CIVS_poll_created, $cr;
print $tx->creation_email_info1, $cr;
print $tx->creation_email_public_link, $cr;
print $tx->for_more_information_about_CIVS, $cr;
print $tx->Sending_result_key, $cr;
print $tx->Results_of_CIVS_poll, $cr;
print $tx->Results_key_email_body, $cr;
print $tx->poll_started, $cr;
print $tx->CIVS_Poll_Control, $cr;
print $tx->Poll_control, $cr;
print $tx->poll_has_not_yet_started, $cr;
print $tx->Start_poll, $cr;
print $tx->End_poll, $cr;
print $tx->ending_poll_cannot_be_undone, $cr;
print $tx->writeins_have_been_disabled, $cr;
print $tx->disallow_further_writeins, $cr;
print $tx->voting_disabled_during_writeins, $cr;
print $tx->allow_voting_during_writeins, $cr;
print $tx->this_is_a_test_poll, $cr;
print $tx->poll_supervisor('name', 'email');
print $tx->no_authorized_yet('waiting');
print $tx->total_authorized_voters('num_auth_string');
print $tx->actual_votes_so_far('num');
print $tx->poll_ends('end');
print $tx->Poll_results_available_to_all_voters_when_poll_completes, $cr;
print $tx->Voters_can_choose_No_opinion, $cr;
print $tx->Voting_is_disabled_during_writeins, $cr;
print $tx->Poll_results_will_be_available_to_the_following_users, $cr;
print $tx->Poll_results_are_now_available_to_the_following_users, $cr;
print $tx->results_available_to_the_following_users, $cr;
print $tx->Poll_results_are_available('<url>');
print $tx->Description, $cr;
print $tx->Candidates, $cr;
print $tx->Add_voters, $cr;
print $tx->the_top_n_will_win('<num_winners>');
print $tx->add_voter_instructions, $cr;
print $tx->Upload_file, $cr;
print $tx->Load_ballot_data, $cr;
print $tx->File_to_upload_ballots_from, $cr;
print $tx->This_is_a_public_poll_plus_link, $cr;
print $tx->The_poll_has_ended, $cr;
print $tx->CIVS_Adding_Voters, $cr;
print $tx->Adding_voters, $cr;
print $tx->Sorry_voters_can_only_be_added_to_poll_in_progress, $cr;
print $tx->Total_of_x_voters_authorized('<x>');
print $tx->Go_back_to_poll_control, $cr;
print $tx->Done, $cr;
print $tx->page_header_CIVS_Vote('<election_title>');
print $tx->ballot_reporting_is_enabled, $cr;
print $tx->instructions1('<num_winners>', '<end>', '<name>', '<email>');
print $tx->instructions2(0,0,0,'<url>');
print $tx->Rank, $cr;
print $tx->Choice, $cr;
print $tx->Weight, $cr;
print $tx->address_will_be_visible, $cr;
print $tx->ballot_ballot_id_will_be_visible, $cr;
print $tx->ballot_will_be_anonymous, $cr;
print $tx->submit_ranking, $cr;
print $tx->only_writeins_are_permitted, $cr;
print $tx->to_top, $cr;
print $tx->to_bottom, $cr;
print $tx->move_up, $cr;
print $tx->move_down, $cr;
print $tx->make_tie, $cr;
print $tx->buttons_are_deactivated, $cr;
print $tx->ranking_instructions, $cr;
print $tx->write_in_a_choice, $cr;
print $tx->if_you_have_already_voted('<url>');
print $tx->thank_you_for_voting('<title>', '<receipt>');
print $tx->name_of_writein_is_empty, $cr;
print $tx->writein_too_similar, $cr;
print $tx->vote_has_already_been_cast, $cr;
print $tx->following_URL_will_report_results, $cr;
print $tx->following_URL_reports_results, $cr;
print $tx->Already_voted, $cr;
print $tx->Error, $cr;
print $tx->Invalid_key, $cr;
print $tx->Authorization_failure, $cr;
print $tx->already_ended('<title>');
print $tx->Poll_not_yet_ended, $cr;
print $tx->The_poll_has_not_yet_been_ended('<title>', '<name>', '<email>');
print $tx->The_results_of_this_completed_poll_are_here, $cr;
print $tx->No_write_access_to_lock_poll, $cr;
print $tx->This_poll_has_already_been_started('<title>');
print $tx->No_write_access_to_start_poll, $cr;
print $tx->Poll_does_not_exist_or_not_started, $cr;
print $tx->Your_voter_key_is_invalid__check_mail('<voter>');
print $tx->Invalid_result_key('<key>');
print $tx->Invalid_control_key('<key>');
print $tx->Invalid_voting_key, $cr;
print $tx->Invalid_poll_id, $cr;
print $tx->Poll_id_not_valid('<d>');
print $tx->Unable_to_append_to_poll_log, $cr;
print $tx->Voter_v_already_authorized, $cr;
print $tx->Invalid_email_address_hdr('<addr>');
print $tx->Invalid_email_address('<addr>');
print $tx->Sending_mail_to_voter_v, $cr;
print $tx->CIVS_poll_supervisor("John Doe"), $cr;
print $tx->voter_mail_intro('<title>', '<name>', '<email_addr>');
print $tx->Description_of_poll, $cr;
print $tx->if_you_would_like_to_vote_please_visit, $cr;
print $tx->This_is_your_private_URL, $cr;
print $tx->Your_privacy_will_not_be_violated, $cr;
print $tx->This_is_a_nonanonymous_poll, $cr;
print $tx->poll_has_been_announced_to_end('<lection_end>');
print $tx->To_view_the_results_at_the_end, $cr;
print $tx->For_more_information, $cr;
print $tx->CIVS_Ending_Poll, $cr;
print $tx->Ending_poll, $cr;
print $tx->View_poll_results, $cr;
print $tx->Poll_ended('<title>');
print $tx->The_poll_has_been_ended('<election_end>');
print $tx->poll_results_available_to_authorized_users, $cr;
print $tx->was_not_able_stop_the_poll, $cr;
print $tx->CIVS_poll_result, $cr;
print $tx->Poll_results('<title>');
print $tx->Writeins_currently_allowed, $cr;
print $tx->Writeins_allowed, $cr;
print $tx->Writeins_not_allowed, $cr;
print $tx->Detailed_ballot_reporting_enabled, $cr;
print $tx->Detailed_ballot_reporting_disabled, $cr;
print $tx->Voter_identities_will_be_kept_anonymous, $cr;
print $tx->Voter_identities_will_be_public, $cr;
print $tx->Condorcet_completion_rule, $cr;
print $tx->undefined_algorithm, $cr;
print $tx->computing_results, $cr;
print $tx->Supervisor('<name, email>');
print $tx->Announced_end_of_poll, $cr;
print $tx->Actual_time_poll_closed('<close time>');
print $tx->Poll_not_ended, $cr;
print $tx->This_is_a_test_poll, $cr;
print $tx->This_is_a_private_poll('<num_auth>');
print $tx->This_is_a_public_poll, $cr;
print $tx->Actual_votes_cast('<num_votes>');
print $tx->Number_of_winning_candidates, $cr;
print $tx->Poll_actually_has('<winmsg>');
print $tx->poll_description_hdr, $cr;
print $tx->Ranking_result, $cr;
print $tx->x_beats_y('<x>', '<y>', '<w>', '<l>');
print $tx->x_ties_y ('<x>', '<y>', '<w>', '<l>');
print $tx->x_loses_to_y('<x>', '<y>', '<w>', '<l>');
print $tx->some_result_details_not_shown, $cr;
print $tx->Show_details, $cr;
print $tx->Hide_details, $cr;
print $tx->Result_details, $cr;
print $tx->Ballot_report, $cr;
print $tx->Ballots_are_shown_in_random_order, $cr;
print $tx->Download_ballots_as_a_CSV, $cr;
print $tx->No_ballots_were_cast, $cr;
print $tx->Ballot_reporting_was_not_enabled, $cr;
print $tx->Tied, $cr;
print $tx->loss_explanation, $cr;
print $tx->loss_explanation2, $cr;
print $tx->Condorcet_winner_explanation, $cr;
print $tx->undefeated_explanation, $cr;
print $tx->Choices_shown_in_red_have_tied, $cr;
print $tx->Condorcet_winner, $cr;
print $tx->Choices_in_individual_pref_order, $cr;
print $tx->All_prefs_were_affirmed, $cr;
print $tx->Presence_of_a_green_entry_etc, $cr;
print $tx->Random_tie_breaking_used, $cr;
print $tx->No_random_tie_breaking_used, $cr;

exit 0;
