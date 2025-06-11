class Tools::BaseService
  attr_reader :params

  def initialize(params = {})
    @params = params
  end

  def name
    raise NotImplementedError, "#{self.class} must implement name"
  end

  def description
    raise NotImplementedError, "#{self.class} must implement description"
  end

  def parameters
    raise NotImplementedError, "#{self.class} must implement parameters"
  end

  def execute(arguments)
    raise NotImplementedError, "#{self.class} must implement execute"
  end

  def to_registry_format
    {
      type: "function",
      name: name,
      description: description,
      parameters: parameters
    }
  end

  def active?
    true
  end
end
