require "qbert_bot/version"
require "qbert_bot/plugin"
require "qbert_bot/message"
require "qbert_bot/router"
require "qbert_bot/slack"
require "qbert_bot/robot"



module QbertBot
  def self.run!
    bot = Robot.instance
    bot.load_config

    Dir['plugins/*.rb'].each do |f|
      load f
    end

    bot.run!
  end
end
