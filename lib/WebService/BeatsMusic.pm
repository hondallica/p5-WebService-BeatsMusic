package WebService::BeatsMusic;
use JSON::XS;
use Cache::LRU;
use Net::DNS::Lite;
use Furl;
use URI;
use URI::QueryParam;
use Carp;
use Moo;
use namespace::clean;
our $VERSION = "0.01";


$Net::DNS::Lite::CACHE = Cache::LRU->new( size => 512 );

has 'api_key' => (
    is => 'rw',
    isa => sub { $_[0] },
    required => 1,
    default => sub { $ENV{BEATSMUSIC_API_KEY} },
);

has 'http' => (
    is => 'rw',
    required => 1,
    default  => sub {
        my $http = Furl::HTTP->new(
            inet_aton => \&Net::DNS::Lite::inet_aton,
            agent => 'WebService::BeatsMusic/' . $VERSION,
            headers => [ 'Accept-Encoding' => 'gzip',],
        );
        return $http;
    },
);


my @methods = (
    'chart.artists.get',
    'chart.tracks.get',
    'track.search',
    'track.get',
    'track.subtitle.get',
    'track.lyrics.get',
    'track.snippet.get',
    'track.lyrics.post',
    'track.lyrics.feedback.post',
    'matcher.lyrics.get',
    'matcher.track.get',
    'matcher.subtitle.get',
    'artist.get',
    'artist.search',
    'artist.albums.get',
    'artist.related.get',
    'album.get',
    'album.tracks.get',
    'tracking.url.get',
    'catalogue.dump.get',
);


for my $method (@methods) {
    my $code = sub {
        my ($self, %query_param) = @_;
        return $self->request($method, \%query_param);
    };
    no strict 'refs';
    my $method_name = $method;
    $method_name =~ s|\.|_|g;
    *{$method_name} = $code; 
}


sub request {
    my ( $self, $path, $query_param ) = @_;

    my $query = URI->new;
    $query->query_param( 'client_id', $self->api_key );
    map { $query->query_param( $_, $query_param->{$_} ) } keys %$query_param;

    my ($minor_version, $status_code, $message, $headers, $content) = 
        $self->http->request(
            scheme => 'https',
            host => 'partner.api.beatsmusic.com',
            path_query => "v1/api/$path$query",
            method => 'GET',
        );

    my $data = decode_json( $content );
    if ( $data->{message}{header}{status_code} != 200 ) {
        confess $data->{message}{header}{status_code};
    } else {
        return $data;
    }
}


1;

__END__

=encoding utf-8

=head1 NAME

WebService::BeatsMusic - It's new $module

=head1 SYNOPSIS

    use WebService::BeatsMusic;

=head1 DESCRIPTION

WebService::BeatsMusic is ...

=head1 LICENSE

Copyright (C) Hondallica.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hondallica E<lt>hondallica@gmail.comE<gt>

=cut

