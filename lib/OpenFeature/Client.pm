use v5.36;
package OpenFeature::Client;

sub new($class, $provider_registry, $domain = undef) {
    my $self = {};
    my $provider = {};
    if (defined $domain) {
        $provider = $provider_registry->get_provider($domain);
        $self->{'domain'} =  $domain;
    } else {
        $provider = $provider_registry->get_default_provider();
    }
    $self->{'provider'} = $provider;
    bless $self, $class
}

sub get_boolean_value(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context = undef,
    $flag_evaluation_options = undef
) {
    $self->get_boolean_details(
        $flag_key,
        $default_value,
        $evaluation_context,
        $flag_evaluation_options
    )->{'value'}
}

sub get_boolean_details(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context,
    $flag_evaluation_options
) {
    # pre-hooks
    my $flag_details = $self->{'provider'}->resolve_boolean_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

1;
