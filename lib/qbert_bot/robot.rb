require 'singleton'
require 'sinatra/base'
require 'yaml'
require 'rufus-scheduler'

module QbertBot
  Listener = Struct.new(:pattern, :proc)
  BlankListener = Listener.new(//, proc {})

  class Match
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
    attr_reader :config, :slack, :router, :scheduler, :plugins, :listeners

    def initialize
      @plugins = []
      @listeners = []
    end

    def load_config
      @config = YAML.load_file('qbert.yml')
    end

    def run!
      prepare_workers
      load_plugins
      start_workers
    end

    def hear(pattern, &block)
      @listeners << Listener.new(pattern, block)
    end

    def handle_web(method, request, params, response)
      if method == :post && request.path_info == @router.endpoint
        return handle_slack(params)
      end

      @router.exec_route(method, request, params, response)
    end

    def handle_slack(params)
      msg = Message.new(self, params)
      match = find_listener(msg)
      msg.matches = match.matches
      match.proc.call(msg)
      ''
    end

    def say(*args)
      @slack.say(*args)
    end

    private
    def prepare_workers
      @scheduler = Rufus::Scheduler.new
      @router = Router.new(config['http'])
      @slack = Slack.new(config['slack'])
    end

    def load_plugins
      Plugin.plugins.each do |klass|
        puts("Loading #{klass}")
        p = klass.new
        p.bot = self
        p.router = router
        p.slack = slack
        p.scheduler = scheduler
        p.register
        @plugins << p
      end
    end

    def start_workers
      Thread.new {
        @scheduler.join
      }
      Web.run!
    end

    def find_listener(msg)
      @listeners.each do |l|
        if match = msg.text.match(l.pattern)
          return Match.new(l, match)
        end
      end
      return Match.new(BlankListener, [])
    end
  end

  class Web < Sinatra::Base
    set :port, proc { Robot.instance.router.port }
    set :bind, proc { Robot.instance.router.bind }
    set :environment, :production
    set :root, proc { Dir.pwd }
    set :public_folder, Proc.new { File.join(root, "static") }
    disable :logging

    get(//) do
      Robot.instance.handle_web(:get, request, params, self)
    end

    post(//) do
      Robot.instance.handle_web(:post, request, params, self)
    end
  end
end
