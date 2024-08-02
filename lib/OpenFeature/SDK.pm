use v5.36;
package OpenFeature::SDK;

use OpenFeature::ProviderRegistry;
use OpenFeature::Client;

sub new($class) {
    my $self = {};
    $self->{'provider_registry'} = OpenFeature::ProviderRegistry->new();
    bless $self, $class
}

sub set_provider($self, $provider, $domain = undef) {
    defined $domain
        ? $self->{'provider_registry'}->set_provider($domain, $provider)
        : $self->{'provider_registry'}->set_default_provider($provider)
}

sub get_client($self, $domain) {
    OpenFeature::Client->new(
        $self->{'provider_registry'},
        $domain,
    )
}

1;
