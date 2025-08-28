package Setup;

use v5.36;

use OpenFeature::SDK;
use OpenFeature::ProviderRegistry;
use OpenFeature::Providers::InMemoryProvider;

sub test_sdk() {
    my $test_sdk = OpenFeature::SDK->new();
    my $provider = OpenFeature::Providers::InMemoryProvider->new();
    $test_sdk->set_provider($provider, 'in-memory');
    $test_sdk
}

1;
