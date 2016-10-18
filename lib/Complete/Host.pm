package Complete::Host;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Common qw(:all);

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_known_host
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to hostnames',
};

# from Regexp::IPv4, anchored
my $re_ipv4 = qr/\A(?-xism:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})(?:\.(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})){3}))\z/;
# from Regexp::IPv6, anchored
my $re_ipv6 = qr/\A(?-xism::(?::[0-9a-fA-F]{1,4}){0,5}(?:(?::[0-9a-fA-F]{1,4}){1,2}|:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})))|[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}:(?:[0-9a-fA-F]{1,4}|:)|(?::(?:[0-9a-fA-F]{1,4})?|(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))))|:(?:(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|[0-9a-fA-F]{1,4}(?::[0-9a-fA-F]{1,4})?|))|(?::(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|:[0-9a-fA-F]{1,4}(?::(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[0-9a-fA-F]{1,4}){0,2})|:))|(?:(?::[0-9a-fA-F]{1,4}){0,2}(?::(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[0-9a-fA-F]{1,4}){1,2})|:))|(?:(?::[0-9a-fA-F]{1,4}){0,3}(?::(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[0-9a-fA-F]{1,4}){1,2})|:))|(?:(?::[0-9a-fA-F]{1,4}){0,4}(?::(?:(?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2})[.](?:25[0-5]|2[0-4][0-9]|[0-1]?[0-9]{1,2}))|(?::[0-9a-fA-F]{1,4}){1,2})|:)))\z/;

$SPEC{'complete_known_host'} = {
    v => 1.1,
    summary => 'Complete a known hostname',
    description => <<'_',

Complete from a list of "known" hostnames, which are hostnames that are listed
in some configurations or those that have previously been entered into the
system.

Known hosts will be searched from: `/etc/hosts`, SSH known hosts files, and
remotes in `.git` configuration files.

_
    args => {
        %arg_word,
        include_ip => {
            summary => 'Whether to include IP addresses',
            schema => 'bool*',
        },
        include_hosts => {
            summary => 'Whether to include hosts in /etc/hosts',
            schema => 'bool*',
            default => 1,
        },
        include_ssh_known_hosts => {
            summary => 'Whether to include hosts in ssh known_hosts files',
            description => <<'_',

Only unhashed hosts will be included.

_
            schema => 'bool*',
            default => 1,
        },
    },
};
sub complete_known_host {
    my %args = @_;

    my $inc_ip = $args{include_ip};

    my %hosts;

    # from /etc/hosts
    {
        last unless $args{include_hosts} // 1;
        require Parse::Hosts;
        my $res = Parse::Hosts::parse_hosts();
        last if $res->[0] != 200;
        for my $row (@{ $res->[2] }) {
            $hosts{$row->{ip}}++ if $inc_ip;
            $hosts{$_}++ for @{$row->{hosts}};
        }
    }

    # from SSH known_hosts
    {
        last unless $args{include_ssh_known_hosts} // 1;
        my @files;
        push @files, "$ENV{HOME}/.ssh/known_hosts"
            if $ENV{HOME};
        for my $file (@files) {
            next unless -f $file;
            open my($fh), "<", $file or next;
            while (my $line = <$fh>) {
                next unless $line =~ /\S/;
                next if $line =~ /^\s*#/;
                $line =~ /^(\S+)/ or next;
                my $h = $1;
                next if $h =~ /\A\|/; # hashed
                my $is_ip = $h =~ $re_ipv6 || $h =~ $re_ipv4;
                next if $is_ip && !$inc_ip;
                $hosts{$h}++;
            }
        }
    }

    # TODO: from git remotes

    # TODO: from shell history of ssh commands

    require Complete::Util;
    Complete::Util::complete_hash_key(word => $args{word}, hash=>\%hosts);
}

1;
# ABSTRACT:

=for Pod::Coverage .+

=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
