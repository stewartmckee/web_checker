require "net/http"
require "uri"
require 'yaml/store'
require 'nokogiri'
require 'digest'

module WebChecker
  class Lookout
    def initialize(url, options={})
      @uri = URI.parse(url)
      @options = options
    end

    def changed?
      result = body_hash != archived_hash
      write_hash!
      result
    end

    private
    def get
      http = Net::HTTP.new(@uri.host, @uri.port)
      response = http.request(Net::HTTP::Get.new(@uri.request_uri))
      response
    end

    def body
      Nokogiri::HTML.parse(get.body).css(@options[:target] || "body").to_s
    end

    def body_hash
      Digest::MD5.hexdigest body
    end

    def archived_hash
      store.transaction(true) do
        store[@uri.to_s]
      end
    end

    def write_hash!
      store.transaction do
        store[@uri.to_s] = body_hash
      end
    end

    def store
      @store ||= YAML::Store.new "data.store"
    end



  end
end
