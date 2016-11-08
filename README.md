# Ansible Role: Apt

Manages the configuration of Apt in addition to the various available apt-transports.

Index
----------
* [Requirements](#requirements)
* [Dependencies](#dependencies)
* [Usage](#usage)
  * [Apt Transports](#apt-transports)
  * [Apt Configuration](#apt-configuration)
* [Role Variables](#role-variables)
* [Example Playbook](#example-playbook)
* [Testing and Contributing](#testing-and-contributing)
* [License](#license)
* [Author Information](#author-information)

----------

Requirements
----------

None



Dependencies
----------

None



Usage
----------

The apt role has two components. One that manages the installation of available apt transports, and one that manages the apt configuration.

### Apt Transports

To enable apt transport management, the variable `apt_manage_transports` should be set to `true` (default), and the array `apt_transports` appended with the name of the transport(s) you wish to have installed.

```
apt_transports:
  - https
  - s3
```

**Transport Availability**

|               | Debian 8 | Ubuntu 14.04 | Ubuntu 16.04 |
|:-------------:|:--------:|:------------:|:------------:|
|   **https**   |     x    |       x      |       x      |
|     **s3**    |          |              |       x      |
| **spacewalk** |     x    |       x      |       x      |
|    **tor**    |          |              |       x      |

Specific package versions may be installed by specifying the version via variables that adhere to the following schema: `apt_transport_<transport name>_version`.
See the [Example Playbook](#example-playbook) for an example.


### Apt Configuration

The apt configuration can be enabled by setting the variable `apt_manage_config` to `true` (default), and populating the hash `apt_config` with the appropriate configuration information. Please note that supplying the config information via `apt_config` will **OVERWRITE** the original config file, it will not append.

The `apt_config` hash uses the below schema:
```
apt_config:
  <config filename>:
    "<quoted string of apt variable name>":
      - <value>
      - <value>
```

#### Example

```
apt_config:
  50unattended-upgrades:
    "Unattended-Upgrade::Allowed-Origins":
      - "${distro_id}:${distro_codename}-security"
    "Unattended-Upgrade::Remove-Unused-Dependencies":
      - true
  99timeout:
    "Acquire::ftp::Timeout":
      - 10
    "Acquire::http::Timeout":
      - 10
    "Acquire::https::Timeout":
      - 10
```

#### Generated Configs:

**/etc/apt/apt.conf.d/50unattended-upgrades**
```
Unattended-Upgrade::Remove-Unused-Dependencies {
"True";
};
Unattended-Upgrade::Allowed-Origins {
"${distro_id}:${distro_codename}-security";
};
```

**/etc/apt/apt.conf.d/99timeout**
```
Acquire::ftp::Timeout {
"10";
};
Acquire::http::Timeout {
"10";
};
Acquire::https::Timeout {
"10";
};
```



Role Variables
----------


|           Variable Name           |   Default   |                                                   Description                                                   |
|:---------------------------------:|:-----------:|:---------------------------------------------------------------------------------------------------------------:|
|      `apt_manage_transports`      |    `true`   |                              Enables or Disables the management of apt transports.                              |
|        `apt_manage_config`        |    `true`   |                              Enables or Disables the management of the apt config.                              |
|            `apt_config`           |             | A hash containing the apt config. See the [apt-configuration](#apt-configuration) section for more information. |
|          `apt_transports`         | `[ https ]` |     An array of names of apt transports to install. Options include: `https`, `s3`, `spacewalk`, and `tor`.     |
|   `apt_transport_https_version`   |             |                           The version of the `apt-transport-https` package to install.                          |
|     `apt_transport_s3_version`    |             |                            The version of the `apt-transport-s3` package to install.                            |
| `apt_transport_spacewalk_version` |             |                         The version of the `apt-transport-spacewalk` package to install.                        |
|    `apt_transport_tor_version`    |             |                            The version of the `apt-transport-tor` package to install.                           |



Example Playbook
----------

```yaml
---
- name: apt
  hosts: all
  connection: local
  gather_facts: true
  roles:
    - apt
  vars:
    apt_manage_transports: true
    apt_manage_config: true
    apt_transports:
      - https
      - spacewalk
    apt_transport_spacewalk_version: '1.0.6'
    apt_config:
      50unattended-upgrades:
        "Unattended-Upgrade::Allowed-Origins":
          - "${distro_id}:${distro_codename}-security"
        "Unattended-Upgrade::Remove-Unused-Dependencies":
          - true
      99timeout:
        "Acquire::ftp::Timeout":
          - 10
        "Acquire::http::Timeout":
          - 10
        "Acquire::https::Timeout":
          - 10

```



Testing and Contributing
----------

Please see the [CONTRIBUTING.md](CONTRIBUTING.md) document in the repo for information regarding testing and contributing.


License
----------

BSD



Author Information
----------

Created by Bob Killen, maintained by the Department of [Advanced Research Computing and Technical Services](http://arc-ts.umich.edu/) of the University of Michigan.