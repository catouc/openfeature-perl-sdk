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

    use v5.36;
    use OpenFeature::SDK;
    my $openfeature_sdk = OpenFeature::SDK->new();
    $openfeature_sdk->set_provider($someProvider, 'someDomain');
    my $openfeature_client = $openfeature_sdk->get_client('someDomain');
    my $boolean_flag = $openfeature_client->get_boolean_value('flagName', 0);

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

sub get_provider_metadata($self, $domain = undef) {
    defined $domain
        ? $self->{'provider_registry'}->get_provider($domain)->get_metadata()
        : $self->{'provider_registry'}->get_default_provider()->get_metadata()
}

sub add_hooks($self, $new_hooks) {
    my $original_hooks = $self->{'hooks'};
    $self->{'hooks'} = [@$original_hooks, @$new_hooks]
}

sub clear_hooks($self) {
    $self->{'hooks'} = []
}

sub get_hooks($self) {
    $self->{'hooks'}
}

sub shutdown($self) {
    $self->{'provider_registry'}->shutdown_all_providers()
}

=pod

=head1 Things left to implement


* add_handler

* remove_handler

=cut

1;
