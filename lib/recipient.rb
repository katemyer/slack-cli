#00 ride share csvrecord
module SlackCli
  class Recipient
    attr_reader :id 
    attr_accessor :name

    def initialize(id, name)
      @id = id
      @name = name
    end #initialize

    private
    def self.load_all() #abstract method/template
      raise NotImplementedError, 'Implement me in a child class!'
    end
  end #class
end #module

#Common to tell other files in the program
#Per Devin, include here so it's accessible to other classes
class SlackAPIError < Exception
end
