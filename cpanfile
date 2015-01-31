requires 'perl', '5.008001';
requires 'JSON';
requires 'Cache::LRU';
requires 'Net::DNS::Lite';
requires 'Furl';
requires 'URI';
requires 'URI::QueryParam';
requires 'Carp';
requires 'Moo';
requires 'namespace::clean';

on 'test' => sub {
    requires 'Test::More', '0.98';
    requires 'Test::Flatten';
    requires 'Test::HTTP::Server';
    requires 'File::Slurp';
};

