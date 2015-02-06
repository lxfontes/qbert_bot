require 'singleton'

module QbertBot
  Listener = Struct.new(:pattern, :proc)

  BlankListener = Listener.new(//, proc {})

  class PatternMatch
    attr_reader :listener, :matches
    def initialize(listener, matches)
      @listener = listener
      @matches = matches
    end

    def proc
      @listener.proc
    end
  end

  class Robot
    include Singleton
    attr_reader :config
  end

  class Bota

    attr_reader :listeners, :default_name, :default_icon, :scheduler
    def initialize
      @listeners = []
    end

    def channel_or_dm(name)
      return name if name[0] == '#'
      return name if name[0] == '@'
      "##{name}"
    end

    def handle(post_data)
      msg = QbertMessage.new(self, post_data)
      match = find_listener(msg)
      msg.matches = match.matches
      match.proc.call(msg)
      ''
    end

    def hear(pattern, &block)
      puts("Adding pattern #{pattern.source}")
      listeners << Listener.new(pattern, block)
    end

    def say(to, text, opts = {})
      payload = {
        text: text,
        channel: channel_or_dm(to),
        username: default_name,
        icon_emoji: default_icon
      }
      payload[:icon_emoji] = opts[:icon] if opts.key?(:icon)
      payload[:icon_url] = opts[:icon_url] if opts.key?(:icon_url)
      payload[:username] = opts[:name] if opts.key?(:name)

      puts("Saying: #{payload[:channel]} -> #{text}")
      Faraday.post(@hook, payload: payload.to_json)
    end

    private
    def find_listener(msg)
      puts("Checking '#{msg.text}'")
      listeners.each do |l|
        if match = msg.text.match(l.pattern)
          puts("Found '#{l.pattern.source}'")
          return PatternMatch.new(l, match)
        end
      end
      return PatternMatch.new(BlankListener, [])
    end
  end
end
