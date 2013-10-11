use strict;
use warnings;
use Router::Boom;
use Test::More;

my $b = Router::Boom->new();
$b->add('/' => {controller => 'Root', action => 'show', method => 'GET'});
$b->add('/blog/{year}/{month}', {controller => 'Blog', action => 'monthly', method => 'GET'});
$b->add('/blog/{year:\d{1,4}}/{month:\d{2}}/{day:\d\d}', {controller => 'Blog', action => 'daily'}, {method => 'GET'});
$b->add('/:controller/:action');
$b->add('/comment', {controller => 'Comment', 'action' => 'create'}, {method => 'POST'});
my $r = $b->compile;
note $r->regexp;

is_deeply(
    [$r->match( '/' )],
    [{
        controller => 'Root',
        action     => 'show',
        method     => 'GET',
    }, {}]
);
is_deeply(
    [$r->match( '' )],
    [{
        controller => 'Root',
        action     => 'show',
        method     => 'GET',
    }, {
    }],
    'empty PATH_INFO is same as "/"'
);
is_deeply(
    [ $r->match('/blog/2010/03') ],
    [
        {
            controller => 'Blog',
            action     => 'monthly',
            method     => 'GET',
        }, {
            year       => 2010,
            month      => '03'
        }
    ],
    'blog monthly'
);
is_deeply(
    [ $r->match( '/blog/2010/03/04' ) ],
    [
        {
            controller => 'Blog',
            action     => 'daily',
        },
        {
            year => 2010, month => '03', day => '04',
        }
    ],
    'daily'
);
is_deeply(
    [$r->match( '/comment' ) ],
    [
        {
            controller => 'Comment',
            action     => 'create',
        }, { }
    ]
);
is_deeply(
    [$r->match( '/foo/bar' )],
    [undef, {
        controller => 'foo',
        action     => 'bar',
    }]
);

done_testing;
