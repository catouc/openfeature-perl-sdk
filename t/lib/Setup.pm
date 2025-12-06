package Setup;

use v5.36;

use OpenFeature::SDK;
use OpenFeature::ProviderRegistry;
use OpenFeature::Providers::InMemoryProvider;
use OpenFeature::Providers::Flagd;

sub test_sdk() {
    my $test_sdk = OpenFeature::SDK->new();
    my $provider = OpenFeature::Providers::InMemoryProvider->new();
    my $flagd_provider = OpenFeature::Providers::Flagd->new('http://127.0.0.1:8080');
    $test_sdk->set_provider($provider, 'in-memory');
    $test_sdk->set_provider($flagd_provider, 'flagd');
    $test_sdk
}

1;
