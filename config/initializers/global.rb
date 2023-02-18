module Global
  mattr_accessor :answers_delimiter
  self.answers_delimiter = "\r\n"

  # configuration for setting the layout
  mattr_accessor :layout

  def self.config
    yield(self)
  end
end