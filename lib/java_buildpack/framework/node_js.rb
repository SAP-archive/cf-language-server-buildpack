# Encoding: utf-8
# TODO License.

require 'java_buildpack/component/base_component'
require 'java_buildpack/framework'
require 'java_buildpack/util/dash_case'

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
        version = "8.9.3"
        uri = "https://buildpacks.cloudfoundry.org/dependencies/node/node-8.9.3-linux-x64-3a0877a4.tgz"
        download_tar(version, uri)
      end

      # (see JavaBuildpack::Component::BaseComponent#release)
      def release
        
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
