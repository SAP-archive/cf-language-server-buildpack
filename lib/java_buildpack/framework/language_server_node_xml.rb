# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'fileutils'
require 'java_buildpack/util/qualify_path'
require 'java_buildpack/logging/logger_factory'

module JavaBuildpack
  module Framework

    # Installs XML based LSP server component.
    class LanguageServerNodeXML < JavaBuildpack::Component::VersionedDependencyComponent

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context)
        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger LanguageServerNodeXML
      end


      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile XML" }
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release

        @logger.debug { "Release XML" }
        environment_variables = @droplet.environment_variables
        myWorkdir = @configuration["env"]["workdir"]
        environment_variables.add_environment_variable(ENV_PREFIX + "workdir", myWorkdir)
        myExec = @configuration["env"]["exec"]
        environment_variables.add_environment_variable(ENV_PREFIX + "exec", myExec)

        myIpc = @configuration["env"]["ipc"]
        @logger.debug { "XML Env vars IPC:#{myIpc}" }
        myIpc.each do |key, value|
          environment_variables.add_environment_variable(ENV_PREFIX + key, value)
        end

        environment_variables.add_environment_variable 'PATH', "/home/vcap/app/.java-buildpack/#{@droplet.component_id}/nodejs/bin:$PATH"
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?
        @application.environment.key?(LSPSERVERS) &&  @application.environment[LSPSERVERS].split(',').include?("xml")
      end

      private

      LSPSERVERS = 'lspservers'.freeze

      private_constant :LSPSERVERS

      BINEXEC = 'exec'.freeze

      private_constant :BINEXEC

      ENV_PREFIX = 'LSPXML_'.freeze

      private_constant :ENV_PREFIX

    end

  end
end
