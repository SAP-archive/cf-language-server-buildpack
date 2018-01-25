# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/versioned_dependency_component'
require 'java_buildpack/framework'
require 'fileutils'

module JavaBuildpack
  module Framework

    # Installs JDT based LSP server component.
    class NodeJS < JavaBuildpack::Component::VersionedDependencyComponent

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context)
        @logger = JavaBuildpack::Logging::LoggerFactory.instance.get_logger NodeJS
      end


      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile NodeJS" }
        # Install node js
        FileUtils.mkdir_p @droplet.root + "nodejs"
        nodedir = @droplet.sandbox + "nodejs"
        comp_version = @version
        comp_uri = @uri
        @version="8.9.3"
        @uri="https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.3-linux-x64-3a0877a4.tgz"
        download_tar( target_directory=nodedir )
        @version = comp_version
        @uri = comp_uri
        download_zip strip_top_level = false
        @droplet.copy_resources
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        @logger.debug { "Release NodeJS" }
        environment_variables = @droplet.environment_variables
        environment_variables.add_environment_variable 'PATH', "/home/vcap/app/.java-buildpack/#{@droplet.component_id}/nodejs/bin:$PATH"
      end

      protected

      # (see JavaBuildpack::Component::VersionedDependencyComponent#supports?)
      def supports?          
        @application.environment.key?(LSPSERVERS) &&
          (@application.environment[LSPSERVERS].split(',') & ["cdx", "eslint", "json", "xml"]).any?
      end

    end

  end
end
