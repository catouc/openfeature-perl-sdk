use v5.36;
use Test::More;
use lib 't/lib';
use Setup;

my $test_sdk = Setup::test_sdk();
my $provider = $test_sdk->{'provider_registry'}->get_provider('in-memory');
my $in_memory_client = $test_sdk->get_client('in-memory');

# Flag Values
is($in_memory_client->get_boolean_value('boolVal', 1), 1, 'TestBooleanValueDefault');
$provider->store_flag('boolVal', 0);
is($in_memory_client->get_boolean_value('boolVal', 1), 0, 'TestBooleanValueSet');

is($in_memory_client->get_string_value('stringVal', "bar"), "bar", 'TestStringValueDefault');
$provider->store_flag('stringVal', "bar");
is($in_memory_client->get_string_value('stringVal', "baz"), "bar", 'TestStringValueSet');

is($in_memory_client->get_number_value('numberVal', 100), 100, 'TestNumberValueDefault');
$provider->store_flag('numberVal', 50);
is($in_memory_client->get_number_value('numberVal', 100), 50, 'TestNumberValueSet');

my $objDefaultVal = $in_memory_client->get_object_value('objVal', { foo => "bar" });
is($objDefaultVal->{'foo'}, "bar", 'TestObjectValueDefault');
$provider->store_flag('objVal', { foo => "baz" });
my $objVal = $in_memory_client->get_object_value('objVal', { foo => "bar"});
is ($objVal->{'foo'}, "baz",'TestObjectValueSet');

# Flag details
my $boolDetails = $in_memory_client->get_boolean_details('boolDetails', 1, {}, {});
is($boolDetails->{'value'}, 1, 'TestBooleanDetailsDefault');
is($boolDetails->{'reason'}, "DEFAULT", 'TestBooleanDetailsDefaultReason');

$provider->store_flag('boolDetails', 0);
my $boolVal = $in_memory_client->get_boolean_details('boolDetails', 1, {}, {});
is($boolVal->{'value'}, 0, 'TestBooleanDetailsSet');
is($boolVal->{'reason'}, "STATIC", 'TestBooleanDetailsSetReason');

my $stringDetails = $in_memory_client->get_string_details('stringDetails', "bar", {}, {});
is($stringDetails->{'value'}, "bar", 'TestStringDetailsDefault');
is($stringDetails->{'reason'}, "DEFAULT", 'TestStringDetailsDefaultReason');

$provider->store_flag('stringDetails', "foo");
my $stringVal = $in_memory_client->get_string_details('stringDetails', "baz", {}, {});
is($stringVal->{'value'}, "foo", 'TestBooleanDetailsSet');
is($stringVal->{'reason'}, "STATIC", 'TestStringDetailsSetReason');

my $numberDetails = $in_memory_client->get_number_details('numberDetails', 50, {}, {});
is($numberDetails->{'value'}, 50, 'TestNumberDetailsDefault');
is($numberDetails->{'reason'}, "DEFAULT", 'TestNumberDetailsDefaultReason');

$provider->store_flag('numberDetails', 10);
my $numberVal = $in_memory_client->get_number_details('numberDetails', 50, {}, {});
is($numberVal->{'value'}, 10, 'TestBooleanDetailsSet');
is($numberVal->{'reason'}, "STATIC", 'TestNumberDetailsSetReason');

my $objectDetails = $in_memory_client->get_object_details('objectDetails', { foo => "bar" }, {}, {});
is($objectDetails->{'value'}{'foo'}, "bar", 'TestObjectDetailsDefault');
is($objectDetails->{'reason'}, "DEFAULT", 'TestObjectDetailsDefaultReason');

$provider->store_flag('objectDetails', { baz => "foo" });
my $objectVal = $in_memory_client->get_object_details('objectDetails', { foo => "bar" }, {}, {});
is($objectVal->{'value'}{'baz'}, "foo", 'TestBooleanDetailsSet');
is($objectVal->{'reason'}, "STATIC", 'TestObjectDetailsSetReason');

###
# Flagd testing
###
#
my $flagd_provider = $test_sdk->{'provider_registry'}->get_provider('flagd');
my $flagd_client   = $test_sdk->get_client('flagd');

is($flagd_client->get_string_value('myStringFlag', "bar"), "val1", 'FlagdTestStringValue');

done_testing();
