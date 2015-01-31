use strict;
use Test::More 0.98;
use Test::Flatten;
use WebService::BeatsMusic;


my $bm = new WebService::BeatsMusic;
isa_ok $bm, 'WebService::BeatsMusic';
can_ok 'WebService::BeatsMusic', qw/request api_key url http_request_method/;


subtest 'API Key' => sub {

    subtest 'Default API Key' => sub {
        my $bm = new WebService::BeatsMusic;

        if (exists $ENV{BEATSMUSIC_API_KEY}) {
            ok $bm->api_key;
        } else {
            is $bm->api_key, '';
        }
    };

    subtest 'Setting API Key' => sub {
        my $bm = new WebService::BeatsMusic(api_key => 'API_KEY');
        is $bm->api_key, 'API_KEY';
    };

};

subtest 'API endpoint URL' => sub {

    subtest 'Default API endpoint URL' => sub {
        my $bm = new WebService::BeatsMusic;
        is $bm->url, 'https://partner.api.beatsmusic.com';
    };

    subtest 'Setting API endpoint URL' => sub {
        my $bm = new WebService::BeatsMusic(url => 'http://127.0.0.1:6666');
        is $bm->url, 'http://127.0.0.1:6666';
    };

};

subtest 'HTTP request method' => sub {

    subtest 'Default HTTP request method' => sub {
        my $bm = new WebService::BeatsMusic;
        is $bm->http_request_method, 'GET';
    };

    subtest 'Setting HTTP request method' => sub {
        my $bm = new WebService::BeatsMusic(http_request_method => 'POST');
        is $bm->http_request_method, 'POST';
    };

};

done_testing;

