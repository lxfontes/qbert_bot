module QbertBot::Core

  class Help
    include QbertBot::Plugin

    def help
      [
        ['help', 'Display all commands']
      ]
    end

    def register
      bot.hear(/^help$/) do |msg|
        commands = []
        bot.plugins.each do |plug|
          commands.concat plug.help.map{|i| i.join(' ')}
        end

        msg.reply "Available commands:\n#{commands.join("\n")}"
      end
    end
  end
end
