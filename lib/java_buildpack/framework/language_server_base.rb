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
      def initialize(context, env_prefix)
        super(context)
        @env_prefix = env_prefix
        if sup?
          @version = ''
          @uri = @application.environment[env_prefix + URI]
        else
          @version = nil
          @uri     = nil
        end

        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger LanguageServerBase
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release

        @logger.debug { "Release #{@env_prefix}" }
        environment_variables = @droplet.environment_variables
        my_workdir = @configuration["env"]["workdir"]
        environment_variables.add_environment_variable(@env_prefix + "workdir", my_workdir)
        my_exec = @configuration["env"]["exec"]
        environment_variables.add_environment_variable(@env_prefix + "exec", my_exec)

        my_ipc = @configuration["env"]["ipc"]
        @logger.debug { "#{@env_prefix} Env vars IPC:#{my_ipc}" }
        my_ipc.each do |key, value|
          environment_variables.add_environment_variable(@env_prefix + key, value)
        end

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
