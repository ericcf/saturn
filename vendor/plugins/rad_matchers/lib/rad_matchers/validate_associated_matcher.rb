class ValidateAssociatedMatcher

  def initialize(attribute)
    @attribute = attribute
  end

  def matches?(instance)
    @instance = instance
    association_class = @instance.class.reflect_on_association(@attribute).klass
    invalid_record = association_class.new
    invalid_record.stub!(:valid?).and_return(false)
    @instance.send("#{@attribute}=", invalid_record)
    @instance.valid? == false && @instance.errors_on(@attribute)
  end

  def failure_message_for_should
    "expected #{@instance} to validate associated #{@attribute}"
  end
end

def validate_associated(attribute)
  ValidateAssociatedMatcher.new attribute
end
