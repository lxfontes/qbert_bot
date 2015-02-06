module QbertBot
  module Plugin
    def self.included(klass)
      @plugins ||= []
      @plugins << klass
    end

    def self.plugins
      @plugins
    end

    attr_accessor :bot, :slack, :router, :scheduler
    def register
    end

    def help
      [
        []
      ]
    end
  end
end
