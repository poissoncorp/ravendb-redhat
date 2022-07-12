## Official RavenDB IronBank Docker image

RavenDB is a easy, fast and reliable NoSQL Document Database with multi-document ACID transactions. 
The image is based on IronBank RedHat UBI 8.6

### Tags
- "5.3"

### Documentation

https://ravendb.net/docs/article-page/5.3

### Configuration

To configure RavenDB one can use (in order of precedence):

    - environment variables, 

    - `settings.json` configuration file, 

    - CLI arguments

#### Environment variables

Environment variables prefixed with `RAVEN_` can be used to configure RavenDB server. E.g. one can use:

```bash
RAVEN_Setup_Mode='None'
```

to disable RavenDB Setup Wizard.

#### FAQ

##### I'm using compose / doing automated installation. How do I disable setup wizard?
    
Set `Setup.Mode` configuration option to `None` like so:

```bash
RAVEN_Setup_Mode='None'
```

##### I want to try it out on my local / development machine. How do I run unsecured server?

Set env variables like so:

```bash
RAVEN_Setup_Mode='None'
RAVEN_Security_UnsecuredAccessAllowed='PrivateNetwork'
```

##### How can I pass command line arguments?

By modifying `RAVEN_ARGS` environment variable. It's passed as an CLI arguments line.

##### Can I see RavenDB logs by running `docker logs`?

To get logs available when running `docker logs` command, you need to turn that on for RavenDB server. Setting below environment variables like so is going to enable logging to console. Please note such behavior may have performance implications. Log level may be modified using `RAVEN_Logs_Mode` variable. 

```bash
RAVEN_ARGS='--log-to-console'
```
