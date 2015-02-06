module QbertBot
  Route = Struct.new(:method, :path, :proc)

  class Router
    attr_reader :routes, :port, :bind, :endpoint

    def initialize(conf)
      @routes = []
      @bind = conf['bind']
      @port = conf['port']
      @endpoint = conf['endpoint']
    end

    def get(path, &block)
      add_route(:get, path, &block)
    end

    def post(path, &block)
      add_route(:post, path, &block)
    end

    def exec_route(method, request, params)
      @routes.each do |route|
        next unless route.method == method
        next unless match = request.path_info.match(route.path)
        return route.proc.call(request, params, match)
      end
      return 'no route'
    end

    private
    def add_route(method, path, &block)
      clean_path = nil

      if path.is_a?(Regexp)
        clean_path = path.source
      elsif path.is_a?(String)
        clean_path = Regexp.escape(path)
        clean_path = "/#{clean_path}" unless clean_path[0] == '/'
        clean_path = "#{clean_path}$" unless clean_path[-1, 1] == '$'
      end

      @routes << Route.new(method, Regexp.new(clean_path), block)
    end
  end
end
