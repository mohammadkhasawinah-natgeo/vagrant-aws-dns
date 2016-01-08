# vagrant-aws-dns

`vagrant-aws-dns` is a Vagrant plugin that allows you to set up route53 records.

## Behaviors

* Set route53 records on machine up.
* Remove associated route53 records on machine halt/destroy.
 
## Installation

    $ vagrant plugin install vagrant-aws-dns

## Usage

### Configuration example

```ruby
Vagrant.configure("2") do |config|
  config.vm.box = "dummy"

  config.vm.provider :aws do |aws, override|
    aws.access_key_id = "YOUR KEY"
    aws.secret_access_key = "YOUR SECRET KEY"
    aws.session_token = "SESSION TOKEN"
    aws.keypair_name = "KEYPAIR NAME"

    aws.ami = "ami-7747d01e"

    override.ssh.username = "ubuntu"
    override.ssh.private_key_path = "PATH TO YOUR PRIVATE KEY"
    
    override.dns.hosted_zone_id = 'HOSTED ZONE ID'
    override.dns.record_sets = [['subdomain1.domain.com', 'A', '4.3.2.1'], ['subdomain1.domain.com', 'A']]
  end
```

### record_sets

`record_sets` is an array of record set that are also represented as arrays. Below are some examples:

* `['subdomain.domain.com', 'A']` - This will set a record of type `subdomain.domain.com. A <public_ip>`, the <public_ip> is auto detected.
* `['subdomain.domain.com', 'A', '4.3.2.1']` - This will set a record of type `subdomain.domain.com. A 4.3.2.1`.
* `['subdomain1.domain.com', 'CNAME', 'domain2.com']` - This will set a record of type `subdomain1.domain.com. CNAME domain2.com.`.

## FAQ

* Why this plugin is not named `vagrant-aws-route53` ?
> Unfortunately, that name was already taken by another plugin of the same kind.
* So why develop a new one?
> There are several reasons for this: use of new AWS SDK, support of multiple records, support of deleting records on machine halt
  or destory.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nasskach/vagrant-aws-dns.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

## Acknowledgments

I want to thank my employer `atHome Group S.A - REA Group` for giving me the opportunity to share this work with the open source community.
