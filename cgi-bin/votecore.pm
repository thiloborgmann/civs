package votecore;

use strict;
use JSON;
use Data::Dumper; # just debugging, remove

# rank_candidates($n, $matrix, $ballots) : construct a ranking of the choices.
#
# Arguments:
#   n is the number of choices
#   matrix is a reference to an n x n preference matrix
#   ballots is a reference to a list of ballots, where each ballot
#     is a reference to a list containing the ranking of the candidates.
#
# Returns: a list ($rankings, $log), where:
#   $rankings is a reference to a list of references to lists. An element
#     in the outer list is a rank (from highest/most preferred to
#     lowest/least preferred) and each inner list contains the
#     indices of choices.
#   $log is an HTML log (string) giving details of how the algorithm worked.
#
# Requires:
#     The matrix referenced by $matrix is consistent with the ballots
#     referenced by $ballots, and matrix is the right shape (as defined by $n).
#     Some ballots may not have entries for all $n candidates, because of
#     write-ins.
#

# order defeats by weakness.
sub compare_defeats {
    (my $a, my $b) = @_;
    (($b->[1] - $b->[2]) <=> ($a->[1] - $a->[2]))
    ||
    ($a->[1] <=> $b->[1])
}
sub compare_defeats_sort { compare_defeats($a, $b) }

sub defeat_to_string {
    (my $d) = @_;
    "vs. $d->[0] : ($d->[1] - $d->[2]) "
}

sub defeats_to_string {
    my $result = '';
    (my $defs) = @_;
    $result = "undefeated" if !@{$defs};
    foreach my $d (@{$defs}) {
        $result .= defeat_to_string($d)
    }
    $result
}

# compare_candidates($def1, $def2, $ranked):
# compare two candidates based on their current lists of defeats, provided as
# array references.  The individual defeats in the list must be sorted in
# order of decreasing strength. A candidate is considered 'stronger' if
# its defeats are weaker.
# Any defeat involving a ranked candidate (as defined by @{$ranked}) is
# invalid and should be ignored. Such defeats may be removed from the
# the list when encountered.
sub compare_candidates {
    (my $d1, my $d2, my $ranked) = @_;

    my $i = 0, my $j = 0;

    while (1) {
        while ($i < @{$d1} && $ranked->[$d1->[$i]->[0]]) {
            splice @{$d1}, $i, 1;
        }
        while ($j < @{$d2} && $ranked->[$d2->[$j]->[0]]) {
            splice @{$d2}, $j, 1;
        }
        my $u1 = ($i >= @{$d1});
        my $u2 = ($j >= @{$d2});
        return $u1 <=> $u2 if ($u1 || $u2);

        my $cmp = &compare_defeats($d1->[$i], $d2->[$j]);
        return $cmp if $cmp != 0;

        $i++;
        $j++;
    }
}

sub get_idx {
    (my $list_ref, my $elem) = @_;

    my @list = @$list_ref;
    my ($index) = grep { $list[$_] eq $elem } (0 .. @list-1);

    return defined $index ? $index : -1;
}
# rank_candidates($n, $matrix, $ballots) : construct a ranking of the choices.
#
# Arguments:
#   n is the number of choices
#   matrix is a reference to an n x n preference matrix
#   ballots is a reference to a list of ballots, where each ballot
#     is a reference to a list containing the ranking of the candidates.
#
# Returns: a list ($rankings, $log), where:
#   $rankings is a reference to a list of references to lists. An element
#     in the outer list is a rank (from highest/most preferred to
#     lowest/least preferred) and each inner list contains the
#     indices of choices.
#   $log is an HTML log (string) giving details of how the algorithm worked.
#
# Requires:
#     The matrix referenced by $matrix is consistent with the ballots
#     referenced by $ballots, and matrix is the right shape (as defined by $n).
#     Some ballots may not have entries for all $n candidates, because of
#     write-ins.
#
sub rank_candidates {
    my ($n, $matrix, $ballots, $choices) = @_;

    my @rankings = ();
    my $log = '<ul>';

    my $py_code = "";

    $py_code .= "from pyvotecore.condorcet import CondorcetHelper;\n";
    #$py_code .= "from pyvotecore.schulze_pr import SchulzePR;\n";
    $py_code .= "from pyvotecore.schulze_stv import SchulzeSTV;\n";
    $py_code .= "ballots = [\n";

    my $c_size = scalar @$choices;
    foreach my $b (@$ballots) {

        $py_code .= "{ \"count\":1, \"ballot\":[";

        my $i = 0;
        foreach my $c (@$b) {
            if ($i > 0) {
                $py_code .= ", ";
            }
            $py_code .= "[\"$choices->[$c_size - $c]\"]"; # not eq to display in table of results page but reversed indices?

            $i = $i + 1;
        }
        $py_code .= "] },\n";
    }

    $py_code .= "];\n";
    #$py_code .= "ret = SchulzePR(ballots, winner_threshold=3, ballot_notation = CondorcetHelper.BALLOT_NOTATION_GROUPING).as_json();\n";
    $py_code .= "ret = SchulzeSTV(ballots, required_winners=3, ballot_notation = CondorcetHelper.BALLOT_NOTATION_GROUPING).as_json();\n";
    $py_code .= "print(ret);\n";

    #print main::RESULTS "$py_code";

    my $ret = `echo \'$py_code\' | python3`;
    if ($? != 0) {
        print main::RESULTS "Error calling python ($?)($!)($ret)";
    }

    #print main::RESULTS "ret: $ret";

    my $ret_json = decode_json $ret;
    my %json = %$ret_json;

    #my $ref_order = $json{'order'}; #SchulzePR
    my $ref_order = $json{'winners'}; #SchulzeSTV
    my @order = @$ref_order;

    my @rankings_new = ();
    foreach my $o (@order) {
        my @rankings_sub = ();
        my $idx = &get_idx($choices, $o);
        if ($idx > -1) {
            push @rankings_sub, $idx;
        }
        push @rankings_new, \@rankings_sub;
    }


    @rankings = @rankings_new;
    $log = "Python-Vote-Core returned: " . $ret;

    return (\@rankings, $log . '</ul>');
}


# print_details($log, $n, $choices, $choice_index):
# Print out to RESULTS the details of the election algorithm, using the
# information in $log that was returned by rank_candidates.
sub print_details {
    (my $log) = @_;

    print main::RESULTS $log;
}

1; # ok!

