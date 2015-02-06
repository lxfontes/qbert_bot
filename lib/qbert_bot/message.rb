module QbertBot
  class Message
    attr_accessor :token, :team_id, :channel_id, :channel_name, :timestamp,
      :user_id, :user_name, :raw_text, :trigger_word
    attr_accessor :matches

    def initialize(bot, post_data)
      @bot = bot
      [:token, :team_id, :channel_id, :channel_name, :timestamp,
       :user_id, :user_name, :trigger_word].each do |k|
        send("#{k.to_s}=", post_data[k])
      end
      self.raw_text = post_data[:text]
    end

    def say(*args)
      @bot.say(*args)
    end

    def reply(text, opts = {})
      say(channel_name, text, opts)
    end

    def text
      raw_text.sub(trigger_word, '').strip
    end
  end
end
