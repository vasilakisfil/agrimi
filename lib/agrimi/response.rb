module Agrimi
  # Class that holds an HTTP response
  # Follows HTTP protocol naming
  class Response
    STATUS_CODE = { 100 => "Continue", 101 => "Switching Protocols",
    102 => "Processing", 200 => "OK", 201 => "Created", 202 => "Accepted",
    203 => "Non-Authoritative Information", 204 => "No Content",
    205 => "Reset Content", 206 => "Partial Content", 207 => "Multi-Status",
    208 => "IM Used", 300 => "Multiple Choices", 301 => "Moved Permanently",
    302 => "Found", 303 => "See Other", 304 => "Not Modified",
    305 => "Use Proxy", 306 => "Switch Proxy", 307 => "Temporary Redirect",
    308 => "Permanent Redirect", 400 => "Bad Request", 401 => "Unauthorized",
    402 => "Payment Required", 403 => "Forbidden", 404 => "Not Found",
    405 => "Method Not Allowed", 406 => "Not Acceptable", 
    407 => "Proxy Authentication Required", 408 => "Request Timeout",
    409 => "Conflict", 410 => "Gone", 411 => "Length Required",
    412 => "Precondition Failed", 413 => "Request Entity Too Large",
    415 => "Unsupported Media Type", 416 => "Requested Range Not Satisfiable",
    417 => "Expectation Failed", 419 => "Authentication Timeout",
    420 => "Enhance Your Calm", 426 => "Upgrade Required",
    428 => "Precondition Required", 429 => "Too Many Requests",
    451 => "Unavailable For Legal Reasons", 500 => "Internal Server Error",
    501 => "Not Implemented", 502 => "Bad Gateway", 503 => "Service Unavailable",
    504 => "Gateway Timeout", 505 => "HTTP Version Not Supported" }

    attr_accessor :status_line, :http_version, :status_code, :header_field, :body

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
      @header_field[:Status] = @status_code =  "200 OK"
      @header_field[:'Strict-Transport-Security'] = ""
      @header_field[:Trailer] = ""
      @header_field[:'Transfer-Encoding'] = ""
      @header_field[:Vary] = ""
      @header_field[:Via] = ""
      @header_field[:Warning] = ""
      @header_field[:'WWW-Authenticate'] = ""

      @status_line = "#{@http_version} #{@status_code}"
    end

    # Returns a string version of the HTTP response
    def to_s
      response = "#{@http_version} #{@status_code} #{STATUS_CODE[@status_code]}\n"
      header_field.each do |field, value|
        response += "#{field}: #{value}\n" if !value.empty?
      end
      response += "\n"
      response += "#{@body}"
      return response
    end
  end
end
