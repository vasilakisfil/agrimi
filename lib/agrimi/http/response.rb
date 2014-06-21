module Agrimi::HTTP
  # Class that holds an HTTP response
  # Follows HTTP protocol naming
  class Response
    attr_reader :status, :headers, :body

    def initialize(status, headers, body)
      @status = status
      @headers = headers
      @body = body
    end

    def header_fields
      headers_str = ''
      headers.each do |field, value|
        headers_str += "#{field}: #{value}\n" if !value.empty?
      end

      return headers_str
    end

    def http_version
      "HTTP/1.1"
    end

    def status_line
      "#{http_version} #{@status} #{STATUS_CODE[@status.to_i]}"
    end

    def full_body
      output = ''
      @body.each do |part|
        output << part
      end
      return output
    end

    def to_s
      response = "#{status_line}\n#{header_fields}\n#{full_body}"
    end



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
      501 => "Not Implemented", 502 => "Bad Gateway",
      503 => "Service Unavailable", 504 => "Gateway Timeout",
      505 => "HTTP Version Not Supported"
    }
  end
end
