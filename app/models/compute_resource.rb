module Foreman::Model
  class Openstack < ComputeResource
    def self.provider_friendly_name
      "example"
    end
  end
end
