# Encoding: utf-8

require 'java_buildpack/framework'
require 'java_buildpack/logging/logger_factory'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    class LanguageServerNodeI18n < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, "I18N")
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile I18N" }
        download_tar
        # Install LSP Server bin from from repository as a Versioned component
        @droplet.copy_resources
      end

    end

  end
end
