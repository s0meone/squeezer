class String
  def to_boolean
    return true if self == "true" or self == "1"
    return false if self == "false" or self == "0"
  end
end