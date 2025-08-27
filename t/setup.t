use v5.36;
use Test::More;
use lib 't/lib';
use Setup;

my $test_sdk = Setup::test_sdk();
my $provider = $test_sdk->{'provider_registry'}->get_provider('in-memory');

is($test_sdk->{'provider_registry'}->get_provider('in-memory')->metadata()->{'Name'}, 'in-memory-flag-provider', 'TestProvider');
#is($test_sdk->{'provider_registry'}->get_default_provider()->metadata()->{'Name'}, 'in-memory-flag-provider', 'TestDefaultProvider');

my $in_memory_client = $test_sdk->get_client('in-memory');
is($in_memory_client->{'domain'}, 'in-memory', 'TestClientDomain');

# Hook stuff doesn't really work yet because I don't know how Perl datastructures work :)
$in_memory_client->add_hooks(['foo', 'bar']);
is($in_memory_client->{'hooks'}[0], 'foo', 'TestHookAddingEmpty');
is($in_memory_client->{'hooks'}[1], 'bar', 'TestHookAddingEmpty');

# Flags
# Bool
is($in_memory_client->get_boolean_value('boolVal', 1), 1, 'TestWithProvider');
# set the flag and check if we do this right
$provider->store_flag('boolVal', 0);
is($in_memory_client->get_boolean_value('boolVal', 1), 0, 'TestWithProvider');

# String
is($in_memory_client->get_string_value('stringVal', "bar"), "bar", 'TestWithProvider');
# set the flag and check if we do this right
$provider->store_flag('stringVal', "bar");
is($in_memory_client->get_string_value('stringVal', "baz"), "bar", 'TestWithProvider');

# Number
is($in_memory_client->get_number_value('numberVal', 100), 100, 'TestWithProvider');
# set the flag and check if we do this right
$provider->store_flag('numberVal', 50);
is($in_memory_client->get_number_value('numberVal', 100), 50, 'TestWithProvider');

# Object
my $objDefaultVal = $in_memory_client->get_object_value('objVal', { foo => "bar" });
is($objDefaultVal->{'foo'}, "bar", 'TestWithProvider');
# set the flag and check if we do this right
$provider->store_flag('objVal', { foo => "baz" });
my $objVal = $in_memory_client->get_object_value('objVal', { foo => "bar"});
is ($objVal->{'foo'}, "baz",'TestWithProvider');

done_testing();
