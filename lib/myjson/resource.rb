module Myjson
  ##
  # Extend this class to get find and save functionality
  module Resource
    def self.included(base)
      base.instance_eval do
        attr_reader :id

        class << self
          attr_reader :myjson_attributes
        end
      end

      base.instance_variable_set(:@myjson_attributes, [])
      base.extend(ClassMethods)
    end

    ##
    # Class-level extensions
    module ClassMethods
      def myjson_attribute(attribute, type)
        instance_eval do
          attr_reader attribute

          define_method "#{attribute}=" do |value|
            value = Kernel.send(type.to_s, value)
            instance_variable_set("@#{attribute}", value)
          end
        end

        myjson_attributes.push(attribute)
      end

      def find(id)
        myjson_bin = Myjson::Bin.new
        attributes = myjson_bin.show(id)

        return nil unless attributes

        new.tap do |instance|
          instance.instance_variable_set(:@id, id)

          attributes.each do |attr, value|
            instance.send "#{attr}=", value
          end
        end
      end
    end

    def save
      id ? update : create
    end

    def attributes
      self.class.myjson_attributes.each_with_object({}) do |attribute, h|
        h[attribute] = send(attribute)
      end
    end

    private

    def create
      myjson_bin = Myjson::Bin.new
      response = myjson_bin.create(attributes)
      id = response['uri'].split('/').last
      instance_variable_set(:@id, id)
      true
    end

    def update
      myjson_bin = Myjson::Bin.new
      response = myjson_bin.update(id, attributes)
      !response.nil?
    end
  end
end
