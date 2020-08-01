require 'fog'

fog = Fog::Compute.new(
	:provider => 'AWS',
	:region => 'eu-west-1',
	:aws_access_key_id => '',
	:aws_secret_access_key => '',
)

server = fog.servers.create(
	:tags => {"Name" => "Cloud_Emperor"},
	:image_id => 'ami-234ecc54',
	:flavor_id => 't2.micro',
	:key_name => 'key_pair',
	:security_group_ids => ['ssh_only'],
)

server.wait_for { print "..."; ready? }


