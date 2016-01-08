require 'aws-sdk'


module VagrantPlugins
  module AwsDns
    module Util
      class AwsUtil

        attr_reader :ec2, :route53

        def initialize(accesskey, secretkey)
          credentials = Aws::Credentials.new(accesskey, secretkey)
          @ec2 = Aws::EC2::Client.new(
              region: 'eu-west-1',
              credentials: credentials
          )
          @route53 = Aws::Route53::Client.new(
              region: 'eu-west-1',
              credentials: credentials
          )
        end

        def get_public_ip(instance_id)
          @ec2.describe_instances({instance_ids: [instance_id]}).reservations[0].instances[0].public_ip_address
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
                      ttl: 1,
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
