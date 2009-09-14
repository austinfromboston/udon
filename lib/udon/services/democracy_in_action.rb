require 'nokogiri'

module Udon
  module Services
    class DemocracyInAction

      def initialize(base, options={})
        base.send :include, ProxyMethods
        @host, @target = base, options[:as]
      end

      def save( source )
        dia_proxy.save dia_data( source )
      end

      def dia_proxy
        Udon::Account.configuration.services[:democracy_in_action].send @target
      end

      def dia_data(source)
        @host_keys ||= @host.keys.map do |key_name, key|
          dia_style_key_name = key_name.gsub /^[a-z]|_([a-z])/ do |match|
            match.upcase
          end
          [ key_name, dia_style_key_name ]
        end

        @host_keys.inject({}) do |dia_data, (host_key, dia_key)|
          dia_data[dia_key] = source.send host_key if dia_proxy.keys.include?(dia_key)
          dia_data
        end
      end

      module ProxyMethods
        def self.included(base)
          base.send :before_save, :update_democracy_in_action
        end

        def democracy_in_action
          Udon::Account.configuration.services[:democracy_in_action]
        end

        def update_democracy_in_action
          self.class.services[:democracy_in_action].each do |svc|
            svc.save(self)
          end
        end

      end

    end
  end
end
