use strict;
$^W = 1;

use Test::More tests => 6;
use_ok('CPAN::FindDependencies', 'finddeps');

my $caught = '';
$SIG{__WARN__} = sub { $caught = $_[0]; };

ok(finddeps('Acme::Licence') == 1 &&
   (finddeps('Acme::Licence'))[0]->{ID} eq 'Acme::Licence',
   "Modules with no META.yml appear in the list of results");
ok($caught eq "CPAN::FindDependencies: DCANTRELL/Acme-Licence-1.0: no META.yml\n",
   "... and generate a warning");
$caught = '';

ok(finddeps('DCANTRELL/Acme-Licence-1.0.tar.gz') == 1 &&
   (finddeps('DCANTRELL/Acme-Licence-1.0.tar.gz'))[0]->{ID} eq 'Acme::Licence',
   "Distributions with no META.yml appear in the list of results");
ok($caught eq "CPAN::FindDependencies: DCANTRELL/Acme-Licence-1.0: no META.yml\n",
   "... and generate a warning");
$caught = '';

eval { finddeps('Acme::Licence', fatalerrors => 1) };
ok($@ eq "CPAN::FindDependencies: DCANTRELL/Acme-Licence-1.0: no META.yml\n" &&
   $caught eq '',
   "fatalerrors really does make META.yml errors fatal");