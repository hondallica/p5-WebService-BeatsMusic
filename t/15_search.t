use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/search.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Search' => sub {

    my $res = $bm->request('search', { q => 'metallica', type => 'artist' });
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
        ok exists $res->{data}[0]{result_type};
        ok exists $res->{data}[0]{id};
        ok exists $res->{data}[0]{display};
        ok exists $res->{data}[0]{detail};
        ok exists $res->{data}[0]{verified};
        ok exists $res->{data}[0]{related};
        ok exists $res->{data}[0]{related}{ref_type};
        ok exists $res->{data}[0]{related}{id};
        ok exists $res->{data}[0]{related}{display};
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
