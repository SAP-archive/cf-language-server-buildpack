# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/base_component'
require 'java_buildpack/framework'
require 'java_buildpack/util/dash_case'

module JavaBuildpack
  module Framework

    class NodeJS < JavaBuildpack::Component::BaseComponent
      include JavaBuildpack::Util
     
      # (see JavaBuildpack::Component::BaseComponent#detect)
      def detect
        enabled? ? NodeJS.to_s.dash_case : nil
      end

      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        print 'Compiling nodejs'
        version = "8.9.3"
        uri = "https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.3-linux-x64-3a0877a4.tgz"
        download_tar(version, uri)
        node_bin_path = "$PWD/#{(@droplet.sandbox + 'bin').relative_path_from(@droplet.root)}"
        @droplet.environment_variables
                .add_environment_variable "PATH", "$PATH:#{node_bin_path}"
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        print 'Releasing nodejs'
        #node_bin_path = "$PWD/#{(@droplet.sandbox + 'bin').relative_path_from(@droplet.root)}"
        #@droplet.environment_variables
                #.add_environment_variable "PATH", "$PATH:#{node_bin_path}"
      end
     
      private

      def enabled?
        @application.environment.key?(LSPSERVERS) &&
        (@application.environment[LSPSERVERS].split(',') & ["cdx", "eslint", "json", "jsts", "xml"]).any?
      end

      LSPSERVERS = 'lspservers'.freeze
      
      private_constant :LSPSERVERS

    end

  end
end
