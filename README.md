# Cloud Foundry Java Buildpack

The `cf-language-server-buildpack`, based on `java-buildpack`, is a [Cloud Foundry][] buildpack for running JVM-based [language servers wrapper](https://github.com/SAP/cloud-language-servers-container) together with language servers adhering to the [language server protocol](https://github.com/Microsoft/language-server-protocol).  The language servers are supported by configuration of custom components.

## Usage
To use this buildpack specify the URI of the repository when pushing the language servers wrapper application to Cloud Foundry:

```bash
$ cf push <APP-NAME> -p <ARTIFACT> -b https://github.com/SAP/cf-language-server-buildpack.git
```


The language servers wrapper application for the push can be taken from: https://github.com/SAP/cloud-language-servers-container


## Configuration and Extension
The buildpack supports extension through the use of Git repository forking. The easiest way to accomplish this is to use [GitHub's forking functionality][] to create a copy of this repository.  Make the required extension changes in the copy of the repository. Then specify the URL of the new repository when pushing Cloud Foundry applications. If the modifications are generally applicable to the Cloud Foundry community, please submit a [pull request][] with the changes.

Buildpack configuration can be overridden with an environment variable matching the configuration file you wish to override minus the `.yml` extension and with a prefix of `JBP_CONFIG`. It is not possible to add new configuration properties and properties with `nil` or empty values will be ignored by the buildpack. The value of the variable should be valid inline yaml, referred to as `flow style` in the yaml spec ([Wikipedia] has a good description of this yaml syntax). For example, to change the default version of Java to 7 and adjust the memory heuristics apply this environment variable to the application.

```bash
$ cf set-env my-application JBP_CONFIG_OPEN_JDK_JRE '{ jre: { version: 1.8.0_+ }, memory_calculator: { stack_threads: 200 } }'
```

If the key or value contains a special character such as `:` it should be escaped with double quotes. For example, to change the default repository path for the buildpack.

```bash
$ cf set-env my-application JBP_CONFIG_REPOSITORY '{ default_repository_root: "http://repo.example.io" }'
```

If the key or value contains an environment variable that you want to bind at runtime you need to escape it from your shell. For example, to add command line arguments containing an environment variable to a [Java Main](docs/container-java_main.md) application.

```bash
$ cf set-env my-application JBP_CONFIG_JAVA_MAIN '{ arguments: "-server.port=\$PORT -foo=bar" }'
```

Environment variable can also be specified in the applications `manifest` file. For example, to specify an environment variable in an applications manifest file that disables Auto-reconfiguration.

```bash
  env:
    JBP_CONFIG_SPRING_AUTO_RECONFIGURATION: '{ enabled: false }'
```

This final example shows how to change the version of Tomcat that is used by the buildpack with an environment variable specified in the applications manifest file.

```bash
  env:
    JBP_CONFIG_TOMCAT: '{ tomcat: { version: 8.0.+ } }'
```

See the [Environment Variables][] documentation for more information.

To learn how to configure various properties of the buildpack, follow the "Configuration" links below. More information on extending the buildpack is available [here](docs/extending.md).


### Package Versioning
Keeping track of different versions of the buildpack can be difficult.  To help with this, the rake `package` task puts a version discriminator in the name of the created package file.  The default value for this discriminator is the current Git hash (e.g. `cfd6b17`).  To change the version when creating a package, use the `VERSION=<VERSION>` argument:

```bash
$ bundle install
$ bundle exec rake package VERSION=2.1
...
Creating build/java-buildpack-2.1.zip
```

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
[Running Cloud Foundry locally]: http://docs.cloudfoundry.org/deploying/boshlite/index.html
[Spring Boot]: http://projects.spring.io/spring-boot/
[Wikipedia]: https://en.wikipedia.org/wiki/YAML#Basic_components_of_YAML
