use v5.36;

package OpenFeature::ProviderRegistry;

my $providers = {};

sub new($class) {
    my $self = {};
    $self->{'providers'} = {};
    bless $self, $class
}

sub get_provider($self, $domain) {
    $self->{'providers'}{$domain}
}

sub get_default_provider($self) {
    $self->{'providers'}{'default'}
}

sub set_default_provider($self, $provider) {
    $self->{'providers'}{'default'} = $provider
}

sub set_provider($self, $domain, $provider) {
    $self->{'providers'}{$domain} = $provider
}
