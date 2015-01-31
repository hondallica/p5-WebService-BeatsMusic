package WebService::BeatsMusic;
use JSON;
use Cache::LRU;
use Net::DNS::Lite;
use Furl;
use URI;
use URI::QueryParam;
use Carp;
use Moo;
use namespace::clean;
our $VERSION = "0.01";


$Net::DNS::Lite::CACHE = Cache::LRU->new( size => 5 );

my $http = Furl::HTTP->new(
    inet_aton => \&Net::DNS::Lite::inet_aton,
    agent => "WebService::BeatsMusic/$VERSION",
    headers => [ 'Accept-Encoding' => 'gzip',],
);

has 'api_key' => (
    is => 'rw',
    isa => sub { $_[0] },
    required => 1,
    default => sub { $ENV{BEATSMUSIC_API_KEY} || '' },
);

has 'url' => (
    is => 'rw',
    isa => sub { $_[0] },
    required => 1,
    default => sub { 'https://partner.api.beatsmusic.com' },
);

has 'http_request_method' => (
    is => 'rw',
    isa => sub { $_[0] },
    required => 1,
    default => sub { 'GET' },
);

sub request {
    my ( $self, $path, $query ) = @_;

    $query->{client_id} = $self->api_key;

    my $url = new URI($self->url);
    $url->path("v1/api/$path");
    $url->query_form($query);

    my (undef, $code, $msg, $headers, $content) = 
        $http->request(method => $self->http_request_method, url => $url);

    confess "$code $msg $url" if $code != 200;

    return decode_json( $content );
}


1;

__END__

=encoding utf-8

=head1 NAME

WebService::BeatsMusic - A simple and fast interface to the BeatsMusic API

=head1 SYNOPSIS

    use WebService::BeatsMusic;

    my $bm = new WebService::BeatsMusic(api_key => 'YOUR_API_KEY');
    my $data = $bm->request('activities');

=head1 DESCRIPTION

The module provides a simple interface to the BeatsMusic API. To use this module, you must first sign up at L<https://developer.beatsmusic.com/page> to receive an API key.

=head1 METHODS

These methods usage: L<https://developer.beatsmusic.com/docs>

=head1 SEE ALSO

L<https://developer.beatsmusic.com/page>

=head1 LICENSE

Copyright (C) Hondallica.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Hondallica E<lt>hondallica@gmail.comE<gt>

=cut

