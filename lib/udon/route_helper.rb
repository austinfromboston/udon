module Udon
  module RouteHelper
    def objects_path
      "/#{params[:collection]}"
    end

    def object_path( obj )
      "/#{obj.class.name.underscore.pluralize}/#{obj.id}"
    end

    def edit_object_path( obj )
      "/#{obj.class.name.underscore.pluralize}/#{obj.id}/edit"
    end

  end
end
