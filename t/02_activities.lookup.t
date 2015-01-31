use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/activities.lookup.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Lookup' => sub {

    my $res = $bm->request('activities/ac3');
    ok $res;
    is ref $res->{data}, 'HASH';
    ok exists $res->{data}{type};
    ok exists $res->{data}{id};
    ok exists $res->{data}{name};
    ok exists $res->{data}{num_id};
    ok exists $res->{data}{created_at};

    TODO: {
        # This test don't pass. Maybe API document is wrong.
        # num_id element is exists, but total_editorial_playlists element is not exists.
        # See https://developer.beatsmusic.com/docs/read/activities/Lookup

        local $TODO = 'total_editorial_playlists element is not exists.';
        ok exists $res->{data}{total_editorial_playlists};
    }

};

done_testing;
