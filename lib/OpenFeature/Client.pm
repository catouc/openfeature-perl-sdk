use v5.36;
package OpenFeature::Client;

sub new($class, $provider_registry, $domain = undef, $hooks = []) {
    my $self = {};
    my $provider = {};
    if (defined $domain) {
        $provider = $provider_registry->get_provider($domain);
        $self->{'domain'} =  $domain;
    } else {
        $provider = $provider_registry->get_default_provider();
    }
    $self->{'provider'} = $provider;
    $self->{'hooks'} = $hooks;
    bless $self, $class
}

sub get_metadata($self) {
    { domain => $self->{'domain'} }
}

sub get_provider($self) {
    $self->{'provider'}
}

sub add_hooks($self, $new_hooks) {
    my $original_hooks = $self->{'hooks'};
    $self->{'hooks'} = [@$original_hooks, @$new_hooks]
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
    # maybe copy the evaluation_context? For now we don't need it I think.
    for my $hook (@{$flag_evaluation_options->{'hooks'}}) {
        if ($hook->can('before')) {
             $evaluation_context = $hook->before({
                flag_key => $flag_key,
                flag_value_type => "boolean",
                evaluation_context => $evaluation_context,
                default_value => $default_value,
                client_metadata => $self->get_metadata(),
                provider_metadata => $self->get_provider(),
             }, $flag_evaluation_options->{'hook_hints'})
        }
    }

    my $flag_details = $self->{'provider'}->resolve_boolean_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

sub get_string_value(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context = undef,
    $flag_evaluation_options = undef
) {
    $self->get_string_details(
        $flag_key,
        $default_value,
        $evaluation_context,
        $flag_evaluation_options
    )->{'value'}
}

sub get_string_details(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context,
    $flag_evaluation_options
) {
    # pre-hooks
    my $flag_details = $self->{'provider'}->resolve_string_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

sub get_integer_value(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context = undef,
    $flag_evaluation_options = undef
) {
    $self->get_integer_details(
        $flag_key,
        $default_value,
        $evaluation_context,
        $flag_evaluation_options
    )->{'value'}
}

sub get_integer_details(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context,
    $flag_evaluation_options
) {
    # pre-hooks
    my $flag_details = $self->{'provider'}->resolve_integer_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

sub get_float_value(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context = undef,
    $flag_evaluation_options = undef
) {
    $self->get_float_details(
        $flag_key,
        $default_value,
        $evaluation_context,
        $flag_evaluation_options
    )->{'value'}
}

sub get_float_details(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context,
    $flag_evaluation_options
) {
    # pre-hooks
    my $flag_details = $self->{'provider'}->resolve_float_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

sub get_object_value(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context = undef,
    $flag_evaluation_options = undef
) {
    $self->get_object_details(
        $flag_key,
        $default_value,
        $evaluation_context,
        $flag_evaluation_options
    )->{'value'}
}

sub get_object_details(
    $self,
    $flag_key,
    $default_value,
    $evaluation_context,
    $flag_evaluation_options
) {
    # pre-hooks
    my $flag_details = $self->{'provider'}->resolve_object_details(
        $flag_key, $default_value, $evaluation_context,
    );
    # post hooks
    
    $flag_details
}

1;
