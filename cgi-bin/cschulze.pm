package cschulze;

use strict;
use JSON;
use election;
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
    my ($n, $matrix, $ballots, $choices, $num_winners) = @_;

    my @rankings = ();
    my $log = '<ul>';

    my $data = "";
    my $c_size = 0;
    my $b_size = 0;

    $c_size = scalar @$choices;
    $b_size = scalar @$ballots;

    $data .= "M $num_winners\n";
    $data .= "C $c_size\n";
    $data .= "N $b_size\n";
    $data .= "F 1\n";

    $data .= "\n";
    $data .= "# Candidates in order:\n";

    my $letter = 'A';

    foreach my $c (@$choices) {
        $data .= "X $letter $c\n";
        $letter++;
    }
    
    $data .= "\n";
    $data .= "BEGIN\n";

    my $num = 1;

    foreach my $b (@$ballots) {

        $data .= sprintf("%03u", $num);

        foreach my $c (@$b) {
            $data .= sprintf(" %02u", $c);
        }

	$data .= "\n";

        $num = $num + 1;
    }

    $data .= "END\n";

    my $adata = "";

    my $data_file = "$election_dir/ballots_$election_id.dat";
    my $details_file = "$election_dir/details_$election_id.dat";
    my $ret = `echo \'$data\' > $data_file`;
    $ret    = `./cschulze $data_file $details_file`;
    my $det = `cat $details_file`;

    print main::RESULTS "<pre>$ret</pre>";

    #my $ret = `echo \'$adata\' | python3`;
    if ($? != 0) {
        print main::RESULTS "Error calling cschulze ($?)($!)($ret)";
    }

    #print main::RESULTS "ballots written into $data_file";

    #my $ret_json = decode_json $ret;
    #    my %json = %$ret_json;

    #    #my $ref_order = $json{'order'}; #SchulzePR
    #    my $ref_order = $json{'winners'}; #SchulzeSTV
    #    my @order = @$ref_order;

        my @rankings_new = ();
    #    foreach my $o (@order) {
    #        my @rankings_sub = ();
    #        my $idx = &get_idx($choices, $o);
    #        if ($idx > -1) {
    #            push @rankings_sub, $idx;
    #        }
    #        push @rankings_new, \@rankings_sub;
    #    }


    @rankings = @rankings_new;
    $log = "<pre>" . $det . "</pre>";

    return (\@rankings, $log . '</ul>');
}


# print_details($log, $n, $choices, $choice_index):
# Print out to RESULTS the details of the election algorithm, using the
# information in $log that was returned by rank_candidates.
sub print_details {
    (my $log, my $num_choices, my $choices_ref, my $ciref) = @_;

    print main::RESULTS "Candidates in original order: <pre>";
    my $letter = 'A';
    foreach my $c (@$choices_ref) {
	    print main::RESULTS "$letter: $c\n";
	    $letter++;
    }
    print main::RESULTS "</pre>";

    print main::RESULTS main::p($log);
}

1; # ok!

