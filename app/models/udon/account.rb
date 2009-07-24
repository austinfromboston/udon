module Udon
  class Account
    def self.configure(config_string = nil)
      @configuration ||= Udon::AccountConfiguration.new
      yield @configuration
      @configuration
    end

  end
end
