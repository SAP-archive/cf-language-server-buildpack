# Description

The `cf-language-server-buildpack`, based on `java-buildpack`, is a [Cloud Foundry](http://www.cloudfoundry.org) buildpack for running JVM-based [language servers wrapper](https://github.com/SAP/cloud-language-servers-container) together with language servers adhering to the [language server protocol](https://github.com/Microsoft/language-server-protocol).  The language servers are supported by configuration of custom components providing download of software together with creation of configuration environment variables per language.

# Requirements
There should be an available end point, org and space in CloudFoundry to deploy there the server as a Java application.

# Usage
To use this buildpack specify the URI of the repository when pushing the language servers wrapper application to Cloud Foundry:

```bash
$ cf push <APP-NAME> -p <ARTIFACT> -b https://github.com/SAP/cf-language-server-buildpack.git
```

The language servers wrapper application for the push can be taken from: https://github.com/SAP/cloud-language-servers-container

# Known Issues
* Each language server implementation is provided via component in the buildpack. It is currently not extensible from the outside.
* The configuration of each language server is based on enviroment variables which is a limited format.
* The location of the language server implementations to be downloaded by the buildpack is not final.

# How to obtain support
For bugs, questions and ideas for enhancement please open an issue in github.

# To-Do (upcoming changes)
* Add support for more [language server implementations](https://github.com/Microsoft/language-server-protocol/wiki/Protocol-Implementations) such as es6, eslint, scala, etc.
* Configuration to support multiple server instances in parallel.
* Support for language server implementation coming from behind a firewall.

# How to contribute new language server
Each language server is represented in the buildpack as a component. The components are described in [components.yml](config/components.yml). A component is composed by a configuration, resources folder and a site that has several versions of the packaged server.

The configuration is structured a yml format and contain the following attributes:
* Repository of packaged server versions
* Version of the packaged server to be used
* Working directory for the server
* Execution command
* Communication properties such as protocol and ports
An example of the component yml file could be found [here](config/language_server_bin_exec_jdt.yml).

The resources folder should contain any resources that should be part of the container when it is created for the use of the specific language server such as execution scripts, configuration files, etc'. For example see: [language_server_bin_exec_jdt](resources/language_server_bin_exec_jdt).

The component site repository contains version list under /index.yml, static file (Since component repository is a static Web site it can be easily deployed to CF as a static application via static build pack) and your server as a zip. To deploy your own component repository adjust version url to your own application name and "push" static CF application to CF space of your choice. See for example https://lsp-component-java.cfapps.eu10.hana.ondemand.com/index.yml. It holds several versions with their URL. The packaged server is a tar.gz with internal folder content and inside the executables.

To run component application in the build pack add script, see for example https://github.com/SAP/cf-language-server-buildpack/blob/master/lib/java_buildpack/framework/language_server_node_cdx.rb notice that the language should be added as supported language in the manifest.yml file in the container repository. see for example https://github.com/SAP/cloud-language-servers-container/blob/master/manifest.yaml - lspservers.

Currently Java and NodeJS implementation for language servers are supported. If need to implement new language server in NodeJS consider https://github.com/Microsoft/vscode-languageserver-node as a starting point.

# License
This buildpack is released under version 2.0 of the [Apache License](https://github.com/SAP/cf-language-server-buildpack/LICENSE).
