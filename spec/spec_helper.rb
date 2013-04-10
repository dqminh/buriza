require 'minitest/autorun'
require 'buriza'

# redefine IO.read in terms of File#read for fakefs
class IO
  def self.read(*args)
    File.open(args[0], "rb") { |f| f.read(args[1]) }
  end
end
