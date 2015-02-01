use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/artists.collection.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Collection' => sub {

    my $res = $bm->request('artists', { limit => 3, order_by => 'popularity' });
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
        ok exists $res->{data}[0]{popularity};
        ok exists $res->{data}[0]{streamable};
        ok exists $res->{data}[0]{total_albums};
        ok exists $res->{data}[0]{total_singles};
        ok exists $res->{data}[0]{total_eps};
        ok exists $res->{data}[0]{total_lps};
        ok exists $res->{data}[0]{total_freeplays};
        ok exists $res->{data}[0]{total_compilations};
        ok exists $res->{data}[0]{total_tracks};
        ok exists $res->{data}[0]{refs};
        ok exists $res->{data}[0]{refs}{similars};
        ok exists $res->{data}[0]{verified};
        ok exists $res->{data}[0]{total_follows};
        ok exists $res->{data}[0]{total_followed_by};
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
