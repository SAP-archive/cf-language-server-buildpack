require 'java_buildpack/framework'
require 'java_buildpack/logging/logger_factory'
require 'json'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    # Installs ESLINT based LSP server component.
    class LanguageServerNodeESLINT < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, "ESLINT")
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
          additional_deps = @application.environment.key?(@env_prefix + ADDITIONAL_PACKAGES) &&
            @application.environment[@env_prefix + ADDITIONAL_PACKAGES]
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

      private

      ADDITIONAL_PACKAGES = 'additionalNpmPackages'.freeze

      private_constant :ADDITIONAL_PACKAGES

    end

  end
end
