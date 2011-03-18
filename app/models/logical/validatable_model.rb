module Logical

  class ValidatableModel

    include ActiveModel::Validations

    def initialize(attributes = {})
      return unless attributes.respond_to?(:each)
      attributes.each do |name, value|
        send("#{name}=", value)
      end
    end
  end
end
