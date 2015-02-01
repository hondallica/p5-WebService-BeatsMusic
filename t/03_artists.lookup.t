use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/artists.lookup.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Lookup' => sub {

    my $res = $bm->request('artists/ar42844');
    ok $res;
    is ref $res, 'HASH';

    subtest 'code' => sub {
        ok exists $res->{code};
        is $res->{code}, 'OK';
    };

    subtest 'data' => sub {
        ok exists $res->{data};
        is ref $res->{data}, 'HASH';
        ok exists $res->{data}{type};
        ok exists $res->{data}{id};
        ok exists $res->{data}{name};
        ok exists $res->{data}{popularity};
        ok exists $res->{data}{streamable};
        ok exists $res->{data}{total_albums};
        ok exists $res->{data}{total_singles};
        ok exists $res->{data}{total_eps};
        ok exists $res->{data}{total_lps};
        ok exists $res->{data}{total_freeplays};
        ok exists $res->{data}{total_compilations};
        ok exists $res->{data}{total_tracks};
        ok exists $res->{data}{refs};
        ok exists $res->{data}{refs}{similars};
        ok exists $res->{data}{verified};
        ok exists $res->{data}{total_follows};
        ok exists $res->{data}{total_followed_by};
    };

};

done_testing;
