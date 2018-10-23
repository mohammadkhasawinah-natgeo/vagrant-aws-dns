require_relative 'base'


module VagrantPlugins
  module AwsDns
    module Action
      class RemoveRecord < Base

        def call(env)
          super env do |hosted_zone_id, record, type, value|
            private_ip = @aws.get_private_ip(@machine.id)
            @aws.remove_record(hosted_zone_id, record, type, value||private_ip)
            @machine.ui.info("Removing dns record #{record}.")
          end
        end

      end
    end
  end
end
