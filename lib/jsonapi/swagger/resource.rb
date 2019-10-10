require 'forwardable'
module Jsonapi
  module Swagger
    class Resource
      def self._model_name
        puts "_model_name: #{@model_class_name}"
        @model_class_name
      end

      def self.with(model_class_name)
        @model_class_name = model_class_name
        if Object.const_defined?("#{model_class_name}Resource")
          @resource_class = "#{model_class_name}Resource".safe_constantize
          unless @resource_class < JSONAPI::Resource
            raise Jsonapi::Swagger::Error, "#{@resource_class.class} is not Subclass of JSONAPI::Resource!"
          end
          require 'jsonapi/swagger/resources/jsonapi_resource'
          return Jsonapi::Swagger::JsonapiResource.new(@resource_class)
        elsif Object.const_defined?("Serializable#{model_class_name}")
          @resource_class = "Serializable#{model_class_name}".safe_constantize
          unless @resource_class < JSONAPI::Serializable::Resource
            raise Jsonapi::Swagger::Error, "#{@resource_class.class} is not Subclass of JSONAPI::Serializable::Resource!"
          end
          require 'jsonapi/swagger/resources/serializable_resource'
          return Jsonapi::Swagger::SerializableResource.new(@resource_class)
        else
          raise Jsonapi::Swagger::Error, "#{model_class_name} not support!"
        end
      end
    end
  end
end
