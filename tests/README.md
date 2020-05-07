# Testing

For image testing this project uses the
[Linaro Automated Validation Architecture(LAVA)](https://www.lavasoftware.org/).
The images are generate a gitlab-ci pipeline. This pipline builds the images and
sends them to the lava testlab.

## Test targets

following images are test:
- qemu-armhf
- qemu-arm64
- qemu-amd64
- x86-64-efi
- hikey
- beagle-bone-black

## Deploy test

After the [LAVA setup](#lava-setup) a test can be deploy with the lavacli tool, e.g.:
```
lavacli jobs run tests/jobs/xenomai-qemu-amd64.yml
```

# Tests

Currently the following tests are executed on each target:
- lava-smoketest
- xenomai-test-suite

### lava-smoketest

The lava smoke tests are part of http://git.linaro.org/lava-team/lava-functional-tests.git
and check machine data from the target.

### xenomai-test-suite

The xenomai test suite executes the xeno-test tool from xenomai/testsuite.

# Test Architecture

To test xenomai-images on the target hardware the following architecture
is used:
```
                                                               +----------+
                                                               | Target 1 |
                                                            /--|  beagle  |
+-----------+        +---------+       +---------+    /-----   |  bone    |
|           |  ssh   | LAVA    |       | LAVA    | ---         +----------+
| gitlab-   | ------ | master  |------ | Dis-    | --
| runner    | tunnel |         |       | patcher | \ \---      +----------+
+-----------+        +---------+       +---------+  \-   \---  | Target 2 |
                                                      \      \-| x86-64   |
                                                       \       |          |
                                                        \-     +----------+
                                                          \
                                                           \   +----------+
                                                            \- | Target n |
                                                              \| qemu     |
                                                               |          |
                                                               +----------+
```
A test is deployed in the following steps:
1. gitlab-runner: builds the artifacts
2. After the build is successful the build artifacts are deployed to the
   Lava master per scp.
3. The runner sends a lava job description to the LAVA master, who triggers the
job execution on LAVA Dispatcher.

The LAVA master selects the LAVA Dispatcher to execute the given job on a
target. Qemu targets are executed directly on the LAVA Dispatcher. For non-virtual
targets the payload (kernel,rootfs,...) is deployed via tftp to the selected
hardware.

The dispatcher executes the following steps:
1. Instrumentation of the rootfs. This will collect the necessary lavatools
and adds them to the rootfs
2. Power up the target
3. deploy the payload(kernel,rootfs,...) with help of the bootloader
4. trigger the payload boot
5. execute the tests
6. power off the target

# LAVA Setup

Setup a lava environment by following the
[installation guide](https://docs.lavasoftware.org/lava/first-installation.html)
or use [lava-docker](https://github.com/kernelci/lava-docker).

# CI Files

To support different ci setups all ci files are stored in `.ci`. `.gitlab-ci.yml` in
the repository root use the settings to build on gitlab.com. To use another setup adapt
the [Custom CI configuration path](https://code.siemens.com/help/ci/pipelines/settings#custom-ci-configuration-path)


## CI Variables

The following variables are used and set by the ci system:
- proxy settings:
  - `HTTP_PROXY`    : http proxy
  - `HTTPS_PROXY`   : https proxy
  - `FTP_PROXY`     : ftp proxy
  - `NO_PROXY`      : no proxy

- SSH settings:
  - `LAVA_SSH_USER` : ssh user to connect to the LAVA master
  - `LAVA_SSH_HOST` : ssh host name to connect to the LAVA master
  - `LAVA_SSH_PORT` : ssh port used for the ssh tunnel
  - `LAVA_SSH_UPLOAD_KEY`  :  private ssh key to connect to the LAVA master
  - `LAVA_SSH_KNOWN_HOSTS` : Known hosts to connect via ssh to the host given by `LAVA_SSH_HOST`

- LAVA settings:
  - `LAVA_MASTER_ACCOUNT`  : lava master account name to register lavacli for test execution
  - `LAVA_MASTER_TOKEN`    : token to connect with the lava master
  - `LAVA_DEPLOY_DIR`    : optional variable to define directory to store the build artifacts
  - `LAVA_ARTIFACTS_URL` : optional variable where to get the artifacts for testing
  - `LAVA_DEPLOY_DIR`: Directory to deploy the Artifacts in a build. Default /var/lib/lava/artifacts
  - `LAVA_MASTER_PORT`: PORT to access the LAVA Master

- General build settings
  - `BUILD_OPTIONS` : optional parameter. Used for triggers. Overwrite to build the newest ipipe together with xenomai or other combinations.
  - `DEPLOY_DIR_EXTENSION`: Extension path to store artifacts for the same target
  - `USE_GITLAB_ARTIFACTS`: If set this changes the deploy url to a gitlab api URL
  - `JOB_TEMPLATE_PATH`: Path to the test templates - Default tests/jobs/xenomai
  - `TARGET_EXTENSION`: Extension of the build job name
## LAVA Template variable

- `TARGET`: Name of the target in the LAVA Lab
- `BUILD_ARCH`: Architecture of the Target
- `DEPLOY_DIR`: Path to the test components will be generate by the script `scripts/run-lava-tests.sh`
- `ISAR_IMAGE`: Name of the ISAR image (e.g. demo-image)
- `ISAR_DISTRIBUTION`: Name of the ISAR DISTRIBUTION (e.g. xenomai-demo)
