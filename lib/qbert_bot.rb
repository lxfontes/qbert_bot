require "qbert_bot/version"
require "qbert_bot/plugin"
require "qbert_bot/message"
require "qbert_bot/router"
require "qbert_bot/slack"
require "qbert_bot/robot"
require "qbert_bot/core/help"
require "qbert_bot/core/healthcheck"



module QbertBot
  def self.run!
    bot = Robot.instance
    bot.load_config

    Dir['plugin/*.rb'].each do |f|
      load f
    end

    bot.run!
  end
end
