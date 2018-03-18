# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'fileutils'
require 'java_buildpack/logging/logger_factory'
require 'json'

module JavaBuildpack
  module Framework

    # Installs ESLINT based LSP server component.
    class LanguageServerNodeESLINT < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, ENV_PREFIX)
      end


      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile ESLINT" }
        download_zip strip_top_level = false

        # Install additional npm packages:
        # LSPESLINT_additionalNpmPackages environment variable is a json map that looks like the dependencies section
        # in the package.json.
        # For each additional package we run npm install <package>@<version>
        with_timing 'Installing additional npm packages' do
          additional_deps = @application.environment.key?(ENV_PREFIX + ADDITIONAL_PACKAGES) &&
            @application.environment[ENV_PREFIX + ADDITIONAL_PACKAGES]
          if additional_deps && !additional_deps.strip.empty?
            print "Additional dependencies JSON: #{additional_deps}\n"
            deps_hash = JSON.parse(additional_deps)
            Dir.chdir("#{@droplet.sandbox}/server"){
              nodedir = @droplet.sandbox + "../node_js"
              deps_hash.each do |key, value|
                install_dep_command = "#{nodedir}/bin/node #{nodedir}/lib/node_modules/npm/bin/npm-cli.js install #{key}@#{value}"
                print "Running #{install_dep_command}\n"
                command_output = `#{install_dep_command}`
                print "Result: #{command_output}\n"
              end
            }
          end
        end

        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release

        @logger.debug { "Release ESLINT" }
        environment_variables = @droplet.environment_variables
        myWorkdir = @configuration["env"]["workdir"]
        environment_variables.add_environment_variable(ENV_PREFIX + "workdir", myWorkdir)
        myExec = @configuration["env"]["exec"]
        environment_variables.add_environment_variable(ENV_PREFIX + "exec", myExec)
        
        myIpc = @configuration["env"]["ipc"]
        @logger.debug { "ESLINT Env vars IPC:#{myIpc}" }
        myIpc.each do |key, value|
          environment_variables.add_environment_variable(ENV_PREFIX + key, value)
        end

      end

      protected

      def sup?
        @application.environment.key?(LSPSERVERS) &&  @application.environment[LSPSERVERS].split(',').include?("eslint")
      end

      private

      LSPSERVERS = 'lspservers'.freeze

      private_constant :LSPSERVERS

      BINEXEC = 'exec'.freeze

      private_constant :BINEXEC

      ENV_PREFIX = 'LSPESLINT_'.freeze

      private_constant :ENV_PREFIX

      ADDITIONAL_PACKAGES = 'additionalNpmPackages'.freeze

      private_constant :ADDITIONAL_PACKAGES

      URI = 'URI'.freeze

      private_constant :URI
    end

  end
end
