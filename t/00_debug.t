use strict;
use warnings;
use FindBin qw/$Bin/;

use lib "$Bin/lib";

use Test::More tests => 3;
use Catalyst::Test 'MyApp';

use Data::Dumper;
use HTML::Entities qw/encode_entities_numeric/;

my $res = request('/');
ok( $res->is_success, "/ is success" );

my $content = $res->decoded_content;
$content =~ m|plDebugPanelContent.+?<pre>(.*?)</pre>|s;
ok( $1, "debug panel is there" );

( my $stripped = $1 ) =~ s/\n\s*//gs;
$stripped =~ s/package MyApp::Controller::Root;//;

$stripped =~ s/,?&#x27;__created&#x27; =&#x3E; &#x27;\d*&#x27;,?//;
$stripped =~ s/,?&#x27;__updated&#x27; =&#x3E; &#x27;\d*&#x27;,?//;

my $should_be;
{
    local $Data::Dumper::Terse = 1;
    local $Data::Dumper::Indent = 1;
    local $Data::Dumper::Deparse = 1;
    $should_be = encode_entities_numeric( Dumper( {
        ar  => [
            "bar",
            1,
            2,
            3,
            {
                key => 'value',
            },
        ],
    } ) );
    $should_be =~ s/\n\s*//gs;
}
is( $stripped, $should_be, 'panel content is correct' );

1;
