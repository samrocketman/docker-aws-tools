# Common AWS Dev Tools

This provides a neat package for having AWS development utilities on your
computer without having to install all of the heavy requirements directly.

Features:

* A full development environment for AWS infrastructure as code.
* Running VS Code IDE from inside of the docker container.

# Usage

Running `make` without arguments will give you the following usage.

```
The following make commands are available
    make cli   - CLI development environment.
    make gui   - shows a VS Code (requires X11 or XQuartz on Mac).
    make test  - runs infra tests against the aws-tools docker image.
    make clean - Removes docker image created.
```

# Getting started

* [CDK workshop](https://cdkworkshop.com/30-python/20-create-project/100-cdk-init.html)
* [CDK examples](https://github.com/aws-samples/aws-cdk-examples)

# What is available?

CentOS 8 is the operating system.

System tools:

* [Node JS][js] - dependency for CDK
* [Python 3][py] - dependency for AWS CLI and cfn-init
* [VS Code][code] - Microsoft VS Code for an IDE.
* [X11][X] - To run VS Code inside of the container.  On Mac OS X, you need to
  install [XQuartz][XQ] for this to work.
* [dumb-init][Yelp] - lightweight /sbin/init process
* [git][git]
* [goss][goss] - infrastructure test utility
* [jq][jq] - JSON parsing CLI utility
* vim - A CLI editor.  Run `vimtutor` to learn more.

AWS Tools Provided:

* [AWS CDK][cdk]
* [AWS CLI][cli]
* [cfn-lint][lint] - a CloudFormation stack linter.

[MIT Licensed](LICENSE.txt)

[XQ]: https://www.xquartz.org/
[X]: https://www.x.org/
[Yelp]: https://github.com/Yelp/dumb-init
[cdk]: https://aws.amazon.com/cdk/
[cli]: https://aws.amazon.com/cli/
[code]: https://code.visualstudio.com/
[git]: https://git-scm.com/
[goss]: https://github.com/aelsabbahy/goss
[jq]: https://stedolan.github.io/jq/
[js]: https://nodejs.org/
[lint]: https://github.com/aws-cloudformation/cfn-python-lint
[py]: https://www.python.org/
