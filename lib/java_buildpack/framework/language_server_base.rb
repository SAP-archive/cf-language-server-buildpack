# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'java_buildpack/logging/logger_factory'

module JavaBuildpack
  module Framework

    # Installs LSP server component.
    class LanguageServerBase < JavaBuildpack::Component::VersionedDependencyComponent

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context, envprefix)
        super(context)
        if sup?
          @version = ''
          @uri = @application.environment[envprefix + URI]
        else
          @version = nil
          @uri     = nil
        end

        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger LanguageServerBase
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      # Not applicable when URI comes from environment variable
      def supports?
        false
      end

      def sup?
        false
      end

      private

      URI = 'URI'.freeze

      private_constant :URI
    end

  end
end
