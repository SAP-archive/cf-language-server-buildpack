# Encoding: utf-8

require 'java_buildpack/framework'
require 'fileutils'
require 'java_buildpack/logging/logger_factory'
require 'java_buildpack/framework/language_server_base'

module JavaBuildpack
  module Framework

    # Installs JDT based LSP server component.
    class LanguageServerBinExecJDT < LanguageServerBase

      # Creates an instance
      #
      # @param [Hash] context a collection of utilities used the component
      def initialize(context)
        super(context, "JAVA")
      end


      # (see JavaBuildpack::Component::BaseComponent#compile)
      def compile
        @logger.debug { "Compile JDT"}
        download_tar
        # Install LSP Server bin from from repository as a Versioned component
        @droplet.copy_resources
        FileUtils.mkdir_p @droplet.root + '.m2'
        FileUtils.cp_r(@droplet.sandbox + '.m2/.', @droplet.root + '.m2' )
        FileUtils.mkdir_p @droplet.root + 'di_ws_root'
        FileUtils.mkdir_p @droplet.root + 'jdt_ws_root'
        ipcval = @configuration["env"]["IPC"]
        @logger.debug { "IPC VAL:#{ipcval}"}
      end

    end

  end
end
