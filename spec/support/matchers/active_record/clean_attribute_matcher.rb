class CleanAttributeMatcher

  def initialize(attribute)
    @attribute = attribute
  end

  def matches?(instance)
    @instance = instance
    @instance.send("#{@attribute}=", " ")
    # trigger before_validation callbacks
    @instance.valid?
    @instance.send("#{@attribute}").nil?
  end

  def failure_message_for_should
    "expected #{@instance} to clean #{@attribute}"
  end
end

def clean_attribute(attribute)
  CleanAttributeMatcher.new(attribute)
end
