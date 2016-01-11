require_relative 'base'


module VagrantPlugins
  module AwsDns
    module Action
      class AddRecord < Base

        def call(env)
          super env do |hosted_zone_id, record, type, value|
            @aws.add_record(hosted_zone_id, record, type, value)
            @machine.ui.info("Add dns record #{record} pointing to #{value}.")
          end
        end

      end
    end
  end
end
