require_relative 'user'
require_relative 'channel'
require 'dotenv'

module SlackCli
  class Workspace
    attr_reader :users, :channels
    attr_accessor :selected
    
    def initialize()
      Dotenv.load(__dir__ + "/" + "../.env") #https://github.com/bkeepers/dotenv
      url = ENV['BASE_URL'] + ENV['SUB_USER_URL'] + "token=" + ENV['SLACK_TOKEN']
      @users = SlackCli::User.load_all(url)        
      url = ENV['BASE_URL'] + ENV['SUB_CHANNEL_URL'] + "token=" + ENV['SLACK_TOKEN']
      @channels = SlackCli::Channel.load_all(url)
      @selected = nil
    end #initialize

  #--------------------------Class Methods ------------------------

    #Returns all valid user id and name
    # inputs: aMode that's either "user" or "channel"
    def valid_inputs_id_names(aMode)
      valid_inputs = []
      if aMode == "user"
        self.users.each do |user|
          valid_inputs << user.id
          valid_inputs << user.name
        end
      elsif aMode == "channel"
        self.channels.each do |channel|
          valid_inputs << channel.id
          valid_inputs << channel.name
        end
      end
    return valid_inputs
    end

  #----------------------------------------------------------------

    #finds a user
    #input: aUser_input
    #Returns a found user
    def find_user(aUser_input)
      found_user = nil
      self.users.each do |user|
        if (aUser_input == user.id) || (aUser_input == user.name)
          return user
        end
      end
      return found_user
    end

  #----------------------------------------------------------------

    #finds a channel
    #input: aUser_input
    #Returns a found channel
    def find_channel(aUser_input)
      found_channel = nil
      self.channels.each do |channel|
        if (aUser_input == channel.id) || (aUser_input == channel.name)
          return channel
        end
      end
      return found_channel
    end
    #----------------------------------------------------------------
    
    #sends message
    #input: aUser_message
    #return:response code (int)

    def send_message(aUser_message)
      response_code = nil
      if self.selected != nil
        #if true, prompt user: "what's your message"
    
         #then send message to selected
         payload = {
           :channel => self.selected.id, 
           :text => aUser_message, 
           :token => ENV['SLACK_TOKEN']
         }
         payload_options = { 
           :body => payload
         }
         url = ENV['BASE_URL'] + ENV['SUB_MESSAGE_URL']
         response = HTTParty.post(url, payload_options)
         return response.code
       #if it is nil, 
       else 
       #prompt user to select before a message can be sent
         puts "Select a user or channel before a message can be sent."
       end
      return response_code
    end 
  end #class
end #module

#test_workspace = SlackCli::Workspace.new
# test_workspace.users.each do |user|
#   puts user.real_name  
# end

#name = test_workspace.find_user("cheese")
#puts name

