module QbertBot::Core

  class Healthcheck
    include QbertBot::Plugin

    def register
      router.get('ping') do
        'pong'
      end
    end
  end
end
