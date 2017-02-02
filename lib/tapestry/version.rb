module Tapestry
  module_function

  VERSION = "0.1.0".freeze

  def version
    """
Tapestry v#{Tapestry::VERSION}
watir: #{gem_version('watir')}
selenium-webdriver: #{gem_version('selenium-webdriver')}
    """
  end

  def dependencies
    Gem.loaded_specs.values.map { |spec| "#{spec.name} #{spec.version}\n" }
       .uniq.sort.join(",").split(",")
  end

  def gem_version(name)
    Gem.loaded_specs[name].version
  rescue NoMethodError
    puts "No gem loaded for #{name}."
  end
end
