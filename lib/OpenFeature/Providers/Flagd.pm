use v5.36;
package OpenFeature::Providers::Flagd;

use HTTP::Tiny;
use JSON::PP;
use Data::Dumper;

#pod =encoding UTF-8
#pod
#pod =head1 NAME
#pod
#pod OpenFeature::Providers::Flagd - Flagd HTTP provider implementation
#pod
#pod =head1 SYNOPSIS
#pod
#pod     use 5.36;
#pod     use OpenFeature::SDK;
#pod     use OpenFeature::Providers::Flagd;
#pod     my $sdk = OpenFeature::SDK->new();
#pod     my $provider = OpenFeature::Providers::Flagd->new({
#pod             url => 'https://flagd.endpoint',
#pod     });
#pod     $sdk->set_provider($provider, 'flagd');
#pod     my $features = $test_sdk->get_client('flagd');
#pod     my $string_feature = $features->get_string_value('myStringFlag', "defaultValue");
#pod
#pod =head1 DESCRIPTION
#pod
#pod This is the Flagd provider implementation. We use the less advertised HTTP calls over gRPC here

#pod =method new
#pod
#pod    $provider = new( 'https://foo.bar' );
#pod
#pod Create a new provider instances pointed at a URL.
sub new($class, $url, %args) {
    my $self = { %args };
    $self->{'url'} = $url;
    $self->{'http'} = HTTP::Tiny->new();
    $self->{'json'} = JSON::PP->new();
    bless $self, $class
}

for my $flag_type ( qw/boolean string number object/ ) {
    my $sub_name = "resolve_".$flag_type."_details";
    eval <<"HERE"
    sub $sub_name (\$self, \$flag_key, \$default_value, \$evaluation_context) {
       return \$self->resolve_flag_details(\$flag_key, \$flag_type, \$default_value, \$evaluation_context);
    }
HERE
}

sub resolve_flag_details($self, $flag_key, $flag_type, $default_value, $evaluation_context) {
    my $response = $self->{'http'}->post(
        $self->{'url'}."/flagd.evaluation.v1.Service/Resolve".ucfirst($flag_type),
        {
            headers => {
                'content-type' => 'application/json',
            },
            content => '{"flagKey":"myStringFlag","context":{}}',
        },
    );

    my $flag = $self->{'json'}->decode($response->{'content'});

    return $flag;
}

1;
