module Udon
  module ResourceHelper
    def collection_class
      @klass ||= Object.const_get params[:collection].classify
    end

    def collection_params
      params.dup.delete_if { |key, item| key == :collection }
    end

  end
end