require 'nokogiri'

module Udon
  module Services
    class DemocracyInAction

      def initialize(base, options={})
        base.send :include, ProxyMethods
        base.send :extend, ProxyClassMethods
        base.cattr_accessor :dia_mappings
        @host = base
        @target = options[:as]
      end

      def save( source )
        dia_proxy.save dia_data( source )
      end

      def dia_proxy
        Udon::Account.configuration.services[:democracy_in_action].send @target
      end

      def dia_data(source)
        @host.keys.inject({}) do |dia_data, (key_name, key)|
          dia_style_key_name = key.name.gsub /^[a-z]|_([a-z])/ do |match|
            match.upcase
          end
          dia_data[dia_style_key_name] = source.send key.name if dia_proxy.keys.include?(dia_style_key_name)
          dia_data
        end

        
      end

      module ProxyClassMethods
        def add_dia_mapping(source)
          dia_mappings ||= []
          dia_mappings << source
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
            #proxy = democracy_in_action.send mapping
            #proxy.save to_dia(proxy.keys)
          end
        end

        def to_dia(dia_keys)

        end
      end

    end
  end
end
