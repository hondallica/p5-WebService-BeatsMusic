use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/artists.albums.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Albums' => sub {

    my $res = $bm->request('artists/ar22661/albums', {limit => 1});
    ok $res;
    is ref $res, 'HASH';

    subtest 'code' => sub {
        ok exists $res->{code};
        is $res->{code}, 'OK';
    };

    subtest 'data' => sub {
        ok exists $res->{data};
        is ref $res->{data}, 'ARRAY';
        my @elements = qw(
            type 
            id 
            title 
            duration 
            parental_advisory 
            edited_version 
            release_date 
            release_format 
            rating 
            popularity 
            streamable 
            artist_display_name 
            refs 
            canonical 
            total_companion_albums 
            album_family_id 
            total_tracks 
            essential
        );

        for my $element (@elements) {
            ok exists $res->{data}[0]{$element};
        }

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
