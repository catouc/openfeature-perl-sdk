use v5.36;
package OpenFeature::SDK;

use OpenFeature::ProviderRegistry;
use OpenFeature::Client;
use OpenFeature::EvaluationContext;

=pod

=head1 OpenFeature SDK for Perl

The future of feature flagging is here! Which is an assortment of functions to call L<providers|https://openfeature.dev/specification/sections/providers> to get your flag details out.

OpenFeature provides 5 distinct types of flags in: "Boolean", "String", "Integer", "Float" and "Object". The job of this SDK package is to provider the global configuration layer and access to the underlying Openfeature::Client package.

The code to get a minimal example working is:

C<<< use v5.36; >>>
C<<< use OpenFeature::SDK; >>>
C<<< my $openfeature_sdk = OpenFeature::SDK->new(); >>>
C<<< $openfeature_sdk->set_provider($someProvider, 'someDomain') >>>
C<<< my $openfeature_client = $openfeature_sdk->get_client('someDomain') >>>
C<<< my $boolean_flag = $openfeature_client->get_boolean_value('flagName', 0)>>>

=cut

sub new($class) {
    my $self = {};
    $self->{'provider_registry'} = OpenFeature::ProviderRegistry->new();
    $self->{'evaluation_context'} = OpenFeature::EvaluationContext->new({}); 
    bless $self, $class
}

sub set_provider($self, $provider, $domain = undef) {
    defined $domain
        ? $self->{'provider_registry'}->set_provider($domain, $provider)
        : $self->{'provider_registry'}->set_default_provider($provider)
}

sub clear_providers($self) {
    $self->{'provider_registry'}->clear_providers()
}

sub get_client($self, $domain) {
    OpenFeature::Client->new(
        $self->{'provider_registry'},
        $domain,
    )
}

sub get_evaluation_context($self) {
    $self->{'evaluation_context'}
}

sub set_evaluation_context($self, $new_context) {
    $self->{'evaluation_context'} = $new_context
}

=pod

=head1 Things left to implement

* get_provider_metadata

* add_hooks

* clear_hooks

* get_hooks

* shutdown

* add_handler

* remove_handler

=cut

1;
