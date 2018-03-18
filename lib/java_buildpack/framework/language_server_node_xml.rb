require 'java_buildpack/framework'
require 'fileutils'
require 'java_buildpack/logging/logger_factory'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    # Installs XML based LSP server component.
    class LanguageServerNodeXML < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, ENV_PREFIX)
      end


      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile XML" }
        download_zip strip_top_level = false
        @droplet.copy_resources
      end

      protected

      def sup?
        @application.environment.key?(LSPSERVERS) &&  @application.environment[LSPSERVERS].split(',').include?("xml")
      end

      private

      LSPSERVERS = 'lspservers'.freeze

      private_constant :LSPSERVERS

      ENV_PREFIX = 'LSPXML_'.freeze

      private_constant :ENV_PREFIX

    end

  end
end
