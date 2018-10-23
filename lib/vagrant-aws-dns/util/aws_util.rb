require 'aws-sdk'


module VagrantPlugins
  module AwsDns
    module Util
      class AwsUtil

        attr_reader :ec2, :route53

        def initialize(accesskey, secretkey, region)
          credentials = Aws::Credentials.new(accesskey, secretkey)
          @ec2 = Aws::EC2::Client.new(
              region: region,
              credentials: credentials
          )
          @route53 = Aws::Route53::Client.new(
              region: region,
              credentials: credentials
          )
        end

        def get_public_ip(instance_id)
          @ec2.describe_instances({instance_ids: [instance_id]}).reservations[0].instances[0].public_ip_address
        end

        def get_private_ip(instance_id)
          @ec2.describe_instances({instance_ids: [instance_id]}).reservations[0].instances[0].private_ip_address
        end

        def is_private_zone(hosted_zone_id)
	  @route53.get_hosted_zone({id: '/hostedzone/' + hosted_zone_id}).hosted_zone.config.private_zone
        end

        def add_record(hosted_zone_id, record, type, value)
          change_record(hosted_zone_id, record, type, value, 'UPSERT')
        end

        def remove_record(hosted_zone_id, record, type, value)
          change_record(hosted_zone_id, record, type, value, 'DELETE')
        end

        private

        def change_record(hosted_zone_id, record, type, value, action='CREATE')
          @route53.change_resource_record_sets({
            hosted_zone_id: hosted_zone_id, # required
              change_batch: {
                changes: [
                  {
                    action: action, # required, accepts CREATE, DELETE, UPSERT
                    resource_record_set: {
                      name: record, # required
                      type: type, # required, accepts SOA, A, TXT, NS, CNAME, MX, PTR, SRV, SPF, AAAA
                      ttl: 900,
                      resource_records: [
                        {
                          value: value # required
                        }
                      ]
                    }
                  }
                ]
              }
          })
        end
      end
    end
  end
end
