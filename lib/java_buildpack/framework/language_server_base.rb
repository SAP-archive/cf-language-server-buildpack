# Encoding: utf-8

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
      def initialize(context, lang)
        super(context)
        @lang = lang
        @env_prefix = "LSP" + lang + "_"
        if sup?
          @version = ''
          env_uri = @env_prefix + "URI"
          @uri = @application.environment[env_uri]
        else
          @version = nil
          @uri     = nil
        end

        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger LanguageServerBase
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile #{@lang}" }
        download_zip strip_top_level = false
        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release

        @logger.debug { "Release #{@lang}" }
        environment_variables = @droplet.environment_variables
        my_workdir = @configuration["env"]["workdir"]
        environment_variables.add_environment_variable(@env_prefix + "workdir", my_workdir)
        my_exec = @configuration["env"]["exec"]
        environment_variables.add_environment_variable(@env_prefix + "exec", my_exec)
        my_ipc = @configuration["env"]["ipc"]
        @logger.debug { "#{@lang} Env vars IPC:#{my_ipc}" }
        my_ipc.each do |key, value|
          environment_variables.add_environment_variable(@env_prefix + key, value)
        end

      end

      protected

      def sup?
        @application.environment.key?(LSPSERVERS) &&  @application.environment[LSPSERVERS].split(',').include?(@lang.downcase)
      end

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      # Not applicable when URI comes from environment variable
      def supports?
        false
      end

      private

      LSPSERVERS = 'lspservers'.freeze

      private_constant :LSPSERVERS

    end

  end
end
