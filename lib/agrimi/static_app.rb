module Agrimi
  # Class that holds an HTTP response
  # Follows HTTP protocol naming
  class StaticApp

    attr_accessor :status_line, :http_version, :status_code, :header_field,
      :body

    # Initializes the most basic fields of the HTTP response
    # (Any field can be re-configured through header_field method)
    def initialize
      current_time = Time.new.utc.strftime("%a, %d %b %Y %H:%M:%S")
      @http_version = "HTTP/1.1"
      @header_field = Hash.new
      @header_field[:'Access-Control-Origin'] = "*"
      @header_field[:'Accept-Ranges'] = "bytes"
      @header_field[:Age] = "0"
      @header_field[:Allow] = "GET"
      @header_field[:'Cache-Control'] = "private, max-age=0"
      @header_field[:Connection] = ""
      # fix that
      @header_field[:'Content-Encoding'] = ""
      @header_field[:'Content-Language'] = "en"
      # fix that
      @header_field[:'Content-Length'] = ""
      # fix that
      @header_field[:'Content-MD5'] = ""
      @header_field[:'Content-Disposition'] = ""
      @header_field[:'Content-Range'] = ""
      @header_field[:'Content-Type'] = "text/html; charset=utf-8"
      @header_field[:Date] = "#{current_time} GMT"
      @header_field[:ETag] = ""
      @header_field[:Expires] = "-1"
      @header_field[:'Last-Mmodified'] = "#{current_time} GMT"
      @header_field[:Link] = ""
      @header_field[:Location] = ""
      @header_field[:P3P] = ""
      @header_field[:Pragma] = ""
      @header_field[:'Proxy-Authenticate'] = ""
      @header_field[:Refresh] = ""
      @header_field[:'Retry-After'] = "60"
      @header_field[:Server] = "GoatServer 0.0001 (Unix)"
      @header_field[:'Set-Cookie'] = ""
      @header_field[:Status] = @status_code =  "200"
      @header_field[:'Strict-Transport-Security'] = ""
      @header_field[:Trailer] = ""
      @header_field[:'Transfer-Encoding'] = ""
      @header_field[:Vary] = ""
      @header_field[:Via] = ""
      @header_field[:Warning] = ""
      @header_field[:'WWW-Authenticate'] = ""

      @status_line = "#{@http_version} #{@status_code} #{STATUS_CODE[@status_code.to_i]}"
    end

    def header_fields
      @header_fields = ""
      @header_field.each do |field, value|
        @header_fields += "#{field}: #{value}\n" if !value.empty?
      end
      return @header_fields
    end

    # Returns a string version of the HTTP response
    def to_s
      response = "#{@status_line}\n#{@header_fields}\n#{@body}"
    end

    # Creates a new respons according to the given request
    # @param request [String] The HTTP request string
    # @return [Response] The HTTP response as a string
    def create_response(request)
      response = Response.new
      filepath = "#{@server_root}#{request.request_uri}"
      if File.exists? filepath
        case request.request_uri
        when /\.(?:html)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/html; charset=utf-8"
          file.close
        when /\.(?:css)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/css"
          file.close
        when /\.(?:js)$/i
          file = File.open filepath
          response.body = file.read
          response.header_field[:'Content-Type'] = "text/javascript"
          file.close
        when /\.(?:jpg)$/i
          file = File.open(filepath, "rb")
          response.body = file.read
          response.header_field[:'Accept-Ranges'] = "bytes"
          response.header_field[:'Content-Type'] = "image/jpeg"
          file.close
        when /\.(?:png)$/i
          file = File.open(filepath, "rb")
          response.body = file.read
          response.header_field[:'Accept-Ranges'] = "bytes"
          response.header_field[:'Content-Type'] = "image/png"
          file.close
        else
          response.body = "Wrong file!"
        end
      else
        response.body = "Could not find file!"
      end

      return response
    end
  end
end
