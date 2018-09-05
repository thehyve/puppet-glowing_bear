require 'json'

Puppet::Type.type(:glowing_bear_config).provide(:json) do

  def file_missing(path)
    if File.exists?(path)
      return false
    else
      return true
    end
  end

  def read_json(path)
    content = File.read(path)
    return JSON.load(content)
  end

  def write_json(path, properties)
    File.write(path, JSON.pretty_generate(properties) + "\n")
  end

  def read_properties
    if file_missing(resource[:default_path])
      raise StandardError, 'File does not exists %s' % [resource[:default_path]]
    end
    default_properties = read_json(resource[:default_path])
    target_properties = default_properties.merge(resource[:custom_properties])
    return target_properties
  end

  def create
    target_properties = read_properties
    write_json(resource[:path], target_properties)
  end

  def exists?
    if file_missing(resource[:path])
      return false
    end
    current_properties = read_json(resource[:path])
    target_properties = read_properties
    return current_properties == target_properties
  end

end
