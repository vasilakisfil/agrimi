module Agrimi::HTTP
  # This class handles the HTTP requests
  # It follows the HTTP protocol naming
  class Request
    attr_reader :method, :request_uri, :http_version, :header_fields

    # Initializes the request
    #
    # @param request [String] The request string
    def initialize(request)
      @full_request = request
      @valid = false
      method, request_uri, http_version = request.lines.first.split " "
      header_fields = request.split("\n")[1..-1]
      if method == "GET" || method == "POST"
        @method, @request_uri, @http_version, @valid = method, request_uri,
                                                      http_version, true
      end

      if @request_uri.include? '?'
        @path_info, @query_string = @request_uri.split('?', 2)
      else
        @path_info = @request_uri
        @query_string = ''
      end

      @header_fields = parse_header_fields(header_fields)
    end

    # @return [boolean] Boolean that indicates whether the request has a valid
    # structure
    def valid?
      @valid
    end

    def to_s
      @full_request
    end


    def rack_env
      env = Hash.new
      env['REQUEST_METHOD'] = @method
      env['SCRIPT_NAME'] = '' #@request_uri
      env['PATH_INFO'] = @path_info
      env['QUERY_STRING'] = @query_string
      env['SERVER_NAME'] = 'localhost'
      env['SERVER_PORT'] = '8000'

      rack_input = StringIO.new
      rack_input.set_encoding(Encoding::BINARY) if rack_input.respond_to?(:set_encoding)

      env.update({
        "rack.version" => Rack::VERSION,
        "rack.input" => rack_input,
        "rack.errors" => $stderr,

        "rack.multithread" => false,
        "rack.multiprocess" => false,
        "rack.run_once" => false,

        "rack.hijack?" => false,
      })
      return env
    end

    private

    # Method that parses all the HTTP header fields
    #
    # @params [Hash]
    def parse_header_fields(fields)
      header_fields = Hash.new
      fields.each do |line|
        if header = line.match(/^[A-Z]([a-zA-Z0-9\-\_]+:)/)
          header_fields[header[0].gsub(':','')] = line.split(header[0])[1]
        end
      end

      return header_fields
    end
  end
end
