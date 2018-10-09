# Description

The `cf-language-server-buildpack`, based on `java-buildpack`, is a [Cloud Foundry](http://www.cloudfoundry.org) buildpack for running JVM-based [language servers wrapper](https://github.com/SAP/cloud-language-servers-container) together with language servers adhering to the [language server protocol](https://github.com/Microsoft/language-server-protocol).  The language servers are supported by configuration of custom components providing download of software together with creation of configuration environment variables per language.

# Requirements
There should be an available end point, org and space in CloudFoundry to deploy there the server as a Java application.

```bash
$ cf push <APP-NAME> -p <ARTIFACT> -b https://github.com/cloudfoundry/java-buildpack.git
```

## Examples
The following are _very_ simple examples for deploying the artifact types that we support.

* [Embedded web server](docs/example-embedded-web-server.md)
* [Grails](docs/example-grails.md)
* [Groovy](docs/example-groovy.md)
* [Java Main](docs/example-java_main.md)
* [Play Framework](docs/example-play_framework.md)
* [Servlet](docs/example-servlet.md)
* [Spring Boot CLI](docs/example-spring_boot_cli.md)

## Configuration and Extension
The buildpack default configuration can be overridden with an environment variable matching the configuration file you wish to override minus the `.yml` extension and with a prefix of `JBP_CONFIG`. It is not possible to add new configuration properties and properties with `nil` or empty values will be ignored by the buildpack (in this case you will have to extend the buildpack, see below). The value of the variable should be valid inline yaml, referred to as "flow style" in the yaml spec ([Wikipedia][] has a good description of this yaml syntax). For example, to change the default version of Java to 7 and adjust the memory heuristics apply this environment variable to the application.
<<<<<<< HEAD
=======

```bash
$ cf set-env my-application JBP_CONFIG_OPEN_JDK_JRE '{ jre: { version: 1.7.0_+ }, memory_calculator: { stack_threads: 200 } }'
```

If the key or value contains a special character such as `:` it should be escaped with double quotes. For example, to change the default repository path for the buildpack.
>>>>>>> v4.16

```bash
$ cf set-env my-application JBP_CONFIG_OPEN_JDK_JRE '{ jre: { version: 1.7.0_+ }, memory_calculator: { stack_threads: 200 } }'
```

The language servers wrapper application for the push can be taken from: https://github.com/SAP/cloud-language-servers-container

# Known Issues
* Each language server implementation is provided via component in the buildpack. It is currently not extensible from the outside.
* The configuration of each language server is based on enviroment variables which is a limited format.
* The location of the language server implementations to be downloaded by the buildpack is not final.

# How to obtain support
For bugs, questions and ideas for enhancement please open an issue in github.

```bash
env:
  JBP_CONFIG_SPRING_AUTO_RECONFIGURATION: '{ enabled: false }'
```

# How to contribute new language server
Each language server is represented in the buildpack as a component. The components are described in [components.yml](config/components.yml). A component is composed by a configuration, resources folder and a site that has several versions of the packaged server.

```bash
env:
  JBP_CONFIG_TOMCAT: '{ tomcat: { version: 8.0.+ } }'
```

See the [Environment Variables][] documentation for more information.

To learn how to configure various properties of the buildpack, follow the "Configuration" links below.

The buildpack supports extension through the use of Git repository forking. The easiest way to accomplish this is to use [GitHub's forking functionality][] to create a copy of this repository.  Make the required extension changes in the copy of the repository. Then specify the URL of the new repository when pushing Cloud Foundry applications. If the modifications are generally applicable to the Cloud Foundry community, please submit a [pull request][] with the changes. More information on extending the buildpack is available [here](docs/extending.md).

## Additional Documentation
* [Design](docs/design.md)
* [Security](docs/security.md)
* Standard Containers
  * [Dist ZIP](docs/container-dist_zip.md)
  * [Groovy](docs/container-groovy.md) ([Configuration](docs/container-groovy.md#configuration))
  * [Java Main](docs/container-java_main.md) ([Configuration](docs/container-java_main.md#configuration))
  * [Play Framework](docs/container-play_framework.md)
  * [Ratpack](docs/container-ratpack.md)
  * [Spring Boot](docs/container-spring_boot.md)
  * [Spring Boot CLI](docs/container-spring_boot_cli.md) ([Configuration](docs/container-spring_boot_cli.md#configuration))
  * [Tomcat](docs/container-tomcat.md) ([Configuration](docs/container-tomcat.md#configuration))
* Standard Frameworks
  * [AppDynamics Agent](docs/framework-app_dynamics_agent.md) ([Configuration](docs/framework-app_dynamics_agent.md#configuration))
  * [AspectJ Weaver Agent](docs/framework-aspectj_weaver_agent.md) ([Configuration](docs/framework-aspectj_weaver_agent.md#configuration))
  * [Client Certificate Mapper](docs/framework-client_certificate_mapper.md) ([Configuration](docs/framework-client_certificate_mapper.md#configuration))
  * [Container Customizer](docs/framework-container_customizer.md) ([Configuration](docs/framework-container_customizer.md#configuration))
  * [Container Security Provider](docs/framework-container_security_provider.md) ([Configuration](docs/framework-container_security_provider.md#configuration))
  * [Contrast Security Agent](docs/framework-contrast_security_agent.md) ([Configuration](docs/framework-contrast_security_agent.md#configuration))
  * [Debug](docs/framework-debug.md) ([Configuration](docs/framework-debug.md#configuration))
  * [Dyadic EKM Security Provider](docs/framework-dyadic_ekm_security_provider.md) ([Configuration](docs/framework-dyadic_ekm_security_provider.md#configuration))
  * [Dynatrace Appmon Agent](docs/framework-dynatrace_appmon_agent.md) ([Configuration](docs/framework-dynatrace_appmon_agent.md#configuration))
  * [Dynatrace SaaS/Managed OneAgent](docs/framework-dynatrace_one_agent.md) ([Configuration](docs/framework-dynatrace_one_agent.md#configuration))
  * [Google Stackdriver Debugger](docs/framework-google_stackdriver_debugger.md) ([Configuration](docs/framework-google_stackdriver_debugger.md#configuration))
  * [Google Stackdriver Profiler](docs/framework-google_stackdriver_profiler.md) ([Configuration](docs/framework-google_stackdriver_profiler.md#configuration))
  * [Introscope Agent](docs/framework-introscope_agent.md) ([Configuration](docs/framework-introscope_agent.md#configuration))
  * [JaCoCo Agent](docs/framework-jacoco_agent.md) ([Configuration](docs/framework-jacoco_agent.md#configuration))
  * [Java Memory Assistant](docs/framework-java_memory_assistant.md) ([Configuration](docs/framework-java_memory_assistant.md#configuration))
  * [Java Options](docs/framework-java_opts.md) ([Configuration](docs/framework-java_opts.md#configuration))
  * [JProfiler Profiler](docs/framework-jprofiler_profiler.md) ([Configuration](docs/framework-jprofiler_profiler.md#configuration))
  * [JRebel Agent](docs/framework-jrebel_agent.md) ([Configuration](docs/framework-jrebel_agent.md#configuration))
  * [JMX](docs/framework-jmx.md) ([Configuration](docs/framework-jmx.md#configuration))
  * [Luna Security Provider](docs/framework-luna_security_provider.md) ([Configuration](docs/framework-luna_security_provider.md#configuration))
  * [MariaDB JDBC](docs/framework-maria_db_jdbc.md) ([Configuration](docs/framework-maria_db_jdbc.md#configuration)) (also supports MySQL)
  * [Multiple Buildpack](docs/framework-multi_buildpack.md)
  * [Metric Writer](docs/framework-metric_writer.md) ([Configuration](docs/framework-metric_writer.md#configuration))
  * [New Relic Agent](docs/framework-new_relic_agent.md) ([Configuration](docs/framework-new_relic_agent.md#configuration))
  * [PostgreSQL JDBC](docs/framework-postgresql_jdbc.md) ([Configuration](docs/framework-postgresql_jdbc.md#configuration))
  * [ProtectApp Security Provider](docs/framework-protect_app_security_provider.md) ([Configuration](docs/framework-protect_app_security_provider.md#configuration))
  * [Riverbed AppInternals Agent](docs/framework-riverbed_appinternals_agent.md) ([Configuration](docs/framework-riverbed_appinternals_agent.md#configuration))
  * [Spring Auto Reconfiguration](docs/framework-spring_auto_reconfiguration.md) ([Configuration](docs/framework-spring_auto_reconfiguration.md#configuration))
  * [Spring Insight](docs/framework-spring_insight.md)
  * [SkyWalking Agent](docs/framework-sky_walking_agent.md) ([Configuration](docs/framework-sky_walking_agent.md#configuration))
  * [Takipi Agent](docs/framework-takipi_agent.md) ([Configuration](docs/framework-takipi_agent.md#configuration))
  * [YourKit Profiler](docs/framework-your_kit_profiler.md) ([Configuration](docs/framework-your_kit_profiler.md#configuration))
* Standard JREs
  * [Azul Zulu](docs/jre-zulu_jre.md) ([Configuration](docs/jre-zulu_jre.md#configuration))
  * [IBM® SDK, Java™ Technology Edition](docs/jre-ibm_jre.md) ([Configuration](docs/jre-ibm_jre.md#configuration))
  * [OpenJDK](docs/jre-open_jdk_jre.md) ([Configuration](docs/jre-open_jdk_jre.md#configuration))
  * [Oracle](docs/jre-oracle_jre.md) ([Configuration](docs/jre-oracle_jre.md#configuration))
  * [SapMachine](docs/jre-sap_machine_jre.md) ([Configuration](docs/jre-sap_machine_jre.md#configuration))
* [Extending](docs/extending.md)
  * [Application](docs/extending-application.md)
  * [Droplet](docs/extending-droplet.md)
  * [BaseComponent](docs/extending-base_component.md)
  * [VersionedDependencyComponent](docs/extending-versioned_dependency_component.md)
  * [ModularComponent](docs/extending-modular_component.md)
  * [Caches](docs/extending-caches.md) ([Configuration](docs/extending-caches.md#configuration))
  * [Logging](docs/extending-logging.md) ([Configuration](docs/extending-logging.md#configuration))
  * [Repositories](docs/extending-repositories.md) ([Configuration](docs/extending-repositories.md#configuration))
  * [Utilities](docs/extending-utilities.md)
* [Debugging the Buildpack](docs/debugging-the-buildpack.md)
* [Buildpack Modes](docs/buildpack-modes.md)
* Related Projects
  * [Java Buildpack Dependency Builder](https://github.com/cloudfoundry/java-buildpack-dependency-builder)
  * [Java Buildpack Memory Calculator](https://github.com/cloudfoundry/java-buildpack-memory-calculator)
  * [Java Test Applications](https://github.com/cloudfoundry/java-test-applications)
  * [Java Buildpack System Tests](https://github.com/cloudfoundry/java-buildpack-system-test)
  * [jvmkill](https://github.com/cloudfoundry/jvmkill)

## Building Packages
The buildpack can be packaged up so that it can be uploaded to Cloud Foundry using the `cf create-buildpack` and `cf update-buildpack` commands.  In order to create these packages, the rake `package` task is used.

Note that this process is not currently supported on Windows. It is possible it will work, but it is not tested, and no additional functionality has been added to make it work.

### Online Package
The online package is a version of the buildpack that is as minimal as possible and is configured to connect to the network for all dependencies.  This package is about 50K in size.  To create the online package, run:

```bash
$ bundle install
$ bundle exec rake clean package
...
Creating build/java-buildpack-cfd6b17.zip
```

To run component application in the build pack add script, see for example https://github.com/SAP/cf-language-server-buildpack/blob/master/lib/java_buildpack/framework/language_server_node_cdx.rb notice that the language should be added as supported language in the manifest.yml file in the container repository. see for example https://github.com/SAP/cloud-language-servers-container/blob/master/manifest.yaml - lspservers.

Currently Java and NodeJS implementation for language servers are supported. If need to implement new language server in NodeJS consider https://github.com/Microsoft/vscode-languageserver-node as a starting point.

```bash
$ bundle install
$ bundle exec rake clean package OFFLINE=true PINNED=true
...
Creating build/java-buildpack-offline-cfd6b17.zip
```

## Phase 1 - Update the repository with the new changes
1. Bring the changes to the master brnach or any other branch of this repository
2. Make sure that each component yml file point to the desired version
3. In the pom.xml under project>version : update to the version number - increment by one (example : from 0.0.1 to 0.0.2).

```bash
$ bundle install
$ bundle exec rake clean package VERSION=2.1
...
Creating build/java-buildpack-2.1.zip
```

## Phase 3 - deploy to CF
1. Go to Jass Project ls_buildpack_deploy : https://jaas.wdf.sap.corp:50311/job/lsp_deploy_buidpack/
2. Press Build with Parameters and fill in the parameters.
3. Press build and wait to see that the build succeeded.
4. You can enter your space in cf and check that {APP_NAME}-{your version} was deployed.

*Congratulations! you just deployed new version of cf-language-server-buildpack now you can consume it by updating your destention to point to the app newly created buildpack (make sure it will point https://{you app genrete url}/ls-buildpack.git)*

[Running Cloud Foundry locally][] is useful for privately testing new features.

## Contributing
[Pull requests][] are welcome; see the [contributor guidelines][] for details.

## License
This buildpack is released under version 2.0 of the [Apache License][].

[`config/` directory]: config
[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
[Cloud Foundry]: http://www.cloudfoundry.org
[contributor guidelines]: CONTRIBUTING.md
[disables `remote_downloads`]: docs/extending-caches.md#configuration
[Environment Variables]: http://docs.cloudfoundry.org/devguide/deploy-apps/manifest.html#env-block
[GitHub's forking functionality]: https://help.github.com/articles/fork-a-repo
[Grails]: http://grails.org
[Groovy]: http://groovy.codehaus.org
[Play Framework]: http://www.playframework.com
[pull request]: https://help.github.com/articles/using-pull-requests
[Pull requests]: http://help.github.com/send-pull-requests
[Running Cloud Foundry locally]: https://github.com/cloudfoundry/cf-deployment/tree/master/iaas-support/bosh-lite
[Spring Boot]: http://projects.spring.io/spring-boot/
[Wikipedia]: https://en.wikipedia.org/wiki/YAML#Basic_components_of_YAML
