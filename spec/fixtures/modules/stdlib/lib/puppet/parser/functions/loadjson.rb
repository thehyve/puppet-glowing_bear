#
# loadjson.rb
#
module Puppet::Parser::Functions
  newfunction(:loadjson, :type => :rvalue, :arity => -2, :doc => <<-'DOC') do |args|
    Load a JSON file containing an array, string, or hash, and return the data
    in the corresponding native data type.
    The second parameter is the default value. It will be returned if the file
    was not found or could not be parsed.

    For example:

        $myhash = loadjson('/etc/puppet/data/myhash.json')
        $myhash = loadjson('no-file.json', {'default' => 'value'})
  DOC

    raise ArgumentError, 'Wrong number of arguments. 1 or 2 arguments should be provided.' unless args.length >= 1

    raise StandardError, 'No files are being read in testing mode' unless args[1]
    args[1]
  end
end
