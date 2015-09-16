package Complete::Host;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Complete::Setting;

require Exporter;
our @ISA = qw(Exporter);
our @EXPORT_OK = qw(
                       complete_host
               );

our %SPEC;

$SPEC{':package'} = {
    v => 1.1,
    summary => 'Completion routines related to hostnames',
};

1;
# ABSTRACT:

=for Pod::Coverage .+

=head1 DESCRIPTION

B<NAME GRAB. NOT YET IMPLEMENTED.>


=head1 SEE ALSO

L<Complete>

Other C<Complete::*> modules.
