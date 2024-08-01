use Test::More;

use OpenFeature::SDK;
use OpenFeature::ProviderRegistry;

my $test_sdk = OpenFeature::SDK->new();
my $provider_registry = OpenFeature::ProviderRegistry->new();
$test_sdk->set_provider({ foo => 'bar' }, 'test');
$test_sdk->set_provider({ foo => 'baz' });

is($test_sdk->{'provider_registry'}->get_provider('test')->{'foo'}, 'bar', 'TestProvider');
is($test_sdk->{'provider_registry'}->get_default_provider()->{'foo'}, 'baz', 'TestDefaultProvider');

my $client = $test_sdk->get_client('domain');
is($client->{'provider_registry'}->get_default_provider()->{'foo'}, 'baz', 'TestClientPassthrough');
is($client->{'domain'}, 'domain', 'TestClientDomain');

done_testing();
