use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/activities.collection.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Collection' => sub {

    my $res = $bm->request('activities');
    ok $res;
    is ref $res, 'HASH';

    subtest 'code' => sub {
        ok exists $res->{code};
        is $res->{code}, 'OK';
    };

    subtest 'data' => sub {
        ok exists $res->{data};
        is ref $res->{data}, 'ARRAY';
        ok exists $res->{data}[0]{type};
        ok exists $res->{data}[0]{id};
        ok exists $res->{data}[0]{name};
        ok exists $res->{data}[0]{total_editorial_playlists};
        ok exists $res->{data}[0]{created_at};
    };

    subtest 'info' => sub {
        ok exists $res->{info};
        is ref $res->{info}, 'HASH';
        ok exists $res->{info}{count};
        ok exists $res->{info}{offset};
        ok exists $res->{info}{total};
    };

};

done_testing;
