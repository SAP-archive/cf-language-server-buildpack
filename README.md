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

## License
This buildpack is released under version 2.0 of the [Apache License][LICENSE].
