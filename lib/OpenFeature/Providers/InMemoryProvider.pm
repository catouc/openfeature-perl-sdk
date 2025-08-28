use v5.36;
package OpenFeature::Providers::InMemoryProvider;

use JSON::PP qw(decode_json);

sub new($class, %args) {
    my $self = { %args };
    $self->{'flags'} = {};
    bless $self, $class
}

sub store_flag($self, $flag_key, $flag_value) {
    $self->{'flags'}{$flag_key} = $flag_value;
}

sub metadata($self) {
    { Name => "in-memory-flag-provider" }
}

sub hooks($self) {
    undef
}

sub resolve_boolean_details($self, $flag_key, $default_value, $evaluation_context) {
    $self->flag_evaluation($flag_key, $default_value, $evaluation_context)
}

sub resolve_string_details($self, $flag_key, $default_value, $evaluation_context) {
    $self->flag_evaluation($flag_key, $default_value, $evaluation_context)
}

sub resolve_number_details($self, $flag_key, $default_value, $evaluation_context) {
    $self->flag_evaluation($flag_key, $default_value, $evaluation_context)
}

sub resolve_object_details($self, $flag_key, $default_value, $evaluation_context) {
    $self->flag_evaluation($flag_key, $default_value, $evaluation_context)
}

sub flag_evaluation($self, $flag_key, $default_value, $evaluation_context) {
     my $flag_value = $self->{'flags'}{$flag_key};
     if (!defined($flag_value)) {
         return { 
             value => $default_value,
             reason => "DEFAULT",
         };
     }
     { 
         value => $flag_value,
         reason => "STATIC",
     }
}

1;
