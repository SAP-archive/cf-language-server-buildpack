require 'java_buildpack/framework'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    # Installs XML based LSP server component.
    class LanguageServerNodeXML < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, "XML")
      end

    end

  end
end
