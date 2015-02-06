require 'faraday'
require 'json'

module QbertBot
  class Slack
    attr_reader :hook, :default_name, :default_icon
    def initialize(conf)
      @hook = conf['hook']
      @default_name = conf['name']
      @default_icon = conf['icon']
    end

    def channel_or_dm(name)
      return name if name[0] == '#'
      return name if name[0] == '@'
      "##{name}"
    end


    def say(to, text, opts = {})
      payload = {
        text: text,
        channel: channel_or_dm(to),
        username: default_name,
        icon_emoji: default_icon,
      }
      payload[:icon_emoji] = opts[:icon] if opts.key?(:icon)
      payload[:icon_url] = opts[:icon_url] if opts.key?(:icon_url)
      payload[:username] = opts[:name] if opts.key?(:name)
      payload[:attachments] = opts[:attachments] if opts.key?(:attachments)

      puts("Saying: #{payload[:channel]} -> #{text}")
      Faraday.post(@hook, payload: payload.to_json)
    end

  end
end
