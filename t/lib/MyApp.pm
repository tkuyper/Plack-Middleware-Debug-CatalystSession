package MyApp;
use Moose;

use Catalyst(
   'Session',
   'Session::Store::Dummy',
   'Session::State::Cookie'
);

__PACKAGE__->config(
    'psgi_middleware', [
        'Debug' => {panels => [qw/CatalystSession/]},
    ],
);

__PACKAGE__->setup;
