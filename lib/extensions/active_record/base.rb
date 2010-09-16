module ActiveRecord

  class Base

    private

    def clean_attributes(*attributes)
      attributes.each do |attribute|
        sym = attribute.to_sym
        unless self[sym].nil?
          if self[sym].respond_to?(:strip!)
            self[sym].strip!
            self[sym] = nil if self[sym].blank?
          end
        end
      end
    end
  end
end
