# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/base_component'
require 'java_buildpack/framework'
require 'fileutils'
require 'java_buildpack/util/dash_case'
require 'java_buildpack/util/qualify_path'

module JavaBuildpack
  module Framework

    # Installs JDT based LSP server component.
    class NodeJS < JavaBuildpack::Component::BaseComponent

      # (see JavaBuildpack::Component::BaseComponent#detect)
      def detect
        enabled? ? NodeJS.to_s.dash_case : nil
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        version="8.9.3"
        uri="https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.3-linux-x64-3a0877a4.tgz"
        download_tar(version, uri)
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        #@logger.debug { "Release NodeJS" }
        #environment_variables = @droplet.environment_variables
        #@droplet.environment_variables.add_environment_variable 'PATH', "/app/.java-buildpack/#{@droplet.component_id}/bin:$PATH"
        #@droplet.environment_variables.add_environment_variable('PATH', "$PATH:/app/.java-buildpack/node_js/bin")
        @droplet.environment_variables.add_environment_variable 'PATH', "#{@droplet.component_id}/bin:$PATH"
        #@droplet.environment_variables
        #.add_environment_variable 'PATH', "#{qualify_path(@droplet.component_id)}/bin:$PATH"
      end
     
      private

      def enabled?
        @application.environment.key?(LSPSERVERS) &&
        (@application.environment[LSPSERVERS].split(',') & ["cdx", "eslint", "json", "xml"]).any?
      end

      LSPSERVERS = 'lspservers'.freeze
      
      private_constant :LSPSERVERS

    end

  end
end
