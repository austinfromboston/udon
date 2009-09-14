module Udon
  class Account
    cattr_accessor :configuration

    def self.configure(config_string = nil)
      self.configuration ||= Udon::AccountConfiguration.new
      yield self.configuration
      self.configuration
    end

  end
end
