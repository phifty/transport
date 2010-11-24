
module Transport

  autoload :Common, File.join(File.dirname(__FILE__), "transport", "common")
  autoload :HTTP, File.join(File.dirname(__FILE__), "transport", "http")
  autoload :JSON, File.join(File.dirname(__FILE__), "transport", "json")

end
