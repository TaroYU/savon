require "savon/qualified_message"
require "gyoku"

module Savon
  class Message

    def initialize(message_tag, namespace_identifier, types, used_namespaces, message, element_form_default, key_converter, unwrap,delete_root)
      @message_tag = message_tag
      @namespace_identifier = namespace_identifier
      @types = types
      @used_namespaces = used_namespaces

      @message = message
      @element_form_default = element_form_default
      @key_converter = key_converter
      @unwrap = unwrap
      @delete_root = delete_root
    end

    def to_s
      return @message.to_s unless @message.kind_of? Hash

      if @element_form_default == :qualified
        @message = QualifiedMessage.new(@types, @used_namespaces, @key_converter).to_hash(@message, [@message_tag.to_s])
      end

      gyoku_options = {
        :element_form_default => @element_form_default,
        :namespace            => @namespace_identifier,
        :key_converter        => @key_converter,
        :unwrap               => @unwrap
      }

      res = Gyoku.xml(@message, gyoku_options)
      if @delete_root && root_key = @message.keys.first
        res = res.gsub("<#{root_key}>",'').gsub("</#{root_key}>",'')
      end
      res
    end

  end
end
