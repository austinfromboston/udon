module Udon
  module ResourceHelper
    def collection_class
      @klass ||= Object.const_get params[:collection].classify
    end

    def collection_params
      unsafe_keys = [ :collection, :'_method' ]
      params.dup.delete_if { |key, item| unsafe_keys.include? key.to_sym }
    end

  end
end
