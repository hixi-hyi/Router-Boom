use strict;
use warnings;
use utf8;
use Test::More;
use Router::Boom::Method;

my $r = Router::Boom::Method->new();
$r->add('GET',  '/a', 'g');
$r->add('POST', '/a', 'p');
$r->add(undef,  '/b', 'any');
$r->add('GET',  '/c', 'get only');

subtest 'GET /' => sub {
    ok !$r->match('GET', '/');
};

subtest 'GET /a' => sub {
    my ($a,$b,$c) = $r->match('GET', '/a');
    is $a, 'g';
    is_deeply $b, {};
    is $c, 0;
};
subtest 'POST /a' => sub {
    my ($a,$b,$c) = $r->match('POST', '/a');
    is $a, 'p';
    is_deeply $b, {};
    is $c, 0;
};

subtest 'GET /b' => sub {
    my ($a,$b,$c) = $r->match('POST', '/b');
    is $a, 'any';
    is_deeply $b, {};
    is $c, 0;
};

subtest 'GET /c' => sub {
    my ($a,$b,$c) = $r->match('GET', '/c');
    is $a, 'get only';
    is_deeply $b, {};
    is $c, 0;
};

subtest 'POST /c' => sub {
    my ($a,$b,$c) = $r->match('POST', '/c');
    is $a, undef;
    is_deeply $b, undef;
    is $c, 1;
};

done_testing;
