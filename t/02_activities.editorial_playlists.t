use strict;
use Test::More 0.98;
use WebService::BeatsMusic;
use Test::HTTP::Server;
use File::Slurp;


my $server = new Test::HTTP::Server;
sub Test::HTTP::Server::Request::v1 {
    my $self = shift;
    return read_file('t/resources/activities.editorial_playlists.json');
}

my $bm = new WebService::BeatsMusic(url => $server->uri);

subtest 'Editorial Playlists' => sub {

    my $res = $bm->request('activities/ac3/editorial_playlists', {limit => 1});
    ok $res;
    is ref $res->{data}, 'ARRAY';

    subtest 'code' => sub {
        ok exists $res->{code};
        is $res->{code}, 'OK';
    };

    subtest 'data' => sub {
        ok exists $res->{data};
        is ref $res->{data}, 'ARRAY';
        for my $data (@{$res->{data}}) {
            ok exists $data->{access};
            ok exists $data->{created_at};
            ok exists $data->{description};
            ok exists $data->{duration};
            ok exists $data->{hidden};
            ok exists $data->{id};
            ok exists $data->{name};
            ok exists $data->{parental_advisory};
            ok exists $data->{refs};
            is ref $data->{refs}, 'HASH';
            ok exists $data->{refs}{author};
            is ref $data->{refs}{author}, 'HASH';
            ok exists $data->{refs}{author}{display};
            ok exists $data->{refs}{author}{id};
            ok exists $data->{refs}{author}{ref_type};
            ok exists $data->{refs}{tracks};
            is ref $data->{refs}{tracks}, 'ARRAY';
            for my $track (@{$data->{refs}{tracks}}) {
                ok exists $track->{display};
                ok exists $track->{id};
                ok exists $track->{ref_type};
            }
            is ref $data->{refs}{user}, 'HASH';
            ok exists $data->{refs}{user}{display};
            ok exists $data->{refs}{user}{id};
            ok exists $data->{refs}{user}{ref_type};
            ok exists $data->{total_subscribers};
            ok exists $data->{total_tracks};
            ok exists $data->{type};
            ok exists $data->{updated_at};
            ok exists $data->{user_display_name};
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
