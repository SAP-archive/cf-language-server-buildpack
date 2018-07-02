# Encoding: utf-8

require 'java_buildpack/framework'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    # Installs JDT based LSP server component.
    class LanguageServerNodeJSTS < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, "JSTS")
      end

    end

  end
end
