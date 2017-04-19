# Ansible Role: Apt

Manages the configuration of Apt in addition to the various available apt-transports.

[![Build Status](https://travis-ci.org/arc-ts/ansible-role-apt.svg?branch=master)](https://travis-ci.org/arc-ts/ansible-role-apt)

Index
----------
* [Requirements](#requirements)
* [Dependencies](#dependencies)
* [Usage](#usage)
  * [Apt-Key Management](#apt-key-management)
  * [Apt Sources List](#apt-sources-list)
  * [Additional Apt Sources](#additional-apt-sources)
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

The apt role has several components, and execution order can matter e.g. don't want to restrict sources to a transport that has not yet been installed.

Configuration Order:
* Apt-Keys
* Main sources.list (`/etc/apt/sources.list`)
* Additional sources (`/etc/apt/sources.list.d/*`)
* Install additional apt transports
* Configure apt itself


### Apt-Key Management
To enable apt-key management, `apt_manage_keys` should be set to `true` (default). The array `apt_keys` acts as a list of hashes with keys matching the available options in the [Ansible apt_key module](https://docs.ansible.com/ansible/apt_key_module.html).

```
apt_manage_keys: true
apt_keys:
  - id: '0x8D81803C0EBFCD88'
    keyserver: 'sks-keyservers.net'
  - url: 'https://ftp-master.debian.org/keys/archive-key-6.0.as'
    validate_certs: true
```


### Apt Sources List

Apt sources list management is enabled by setting `apt_manage_sources_list` to `true` (default). It will then Overwrite the original source file (`/etc/apt/sources.list`) with the array of entries in the `apt_sources_list` variable.

```
apt_manage_sources_list: true
apt_sources_list:
  - 'deb http://httpredir.debian.org/debian jessie main'
  - 'deb-src http://httpredir.debian.org/debian jessie main'
  - 'deb http://security.debian.org/ jessie/updates main'
  - 'deb-src http://security.debian.org/ jessie/updates main'
  - 'deb http://httpredir.debian.org/debian jessie-updates main'
  - 'deb-src http://httpredir.debian.org/debian jessie-updates main'
```

### Apt Additional Sources

Additional sources can be controlled by via `apt_manage_additional_sources` and setting it to `true` (default). The `apt_additional_sources` variable can then be populated with an array of hashes consisting of `{ "name": <name>, "entries": [<array of entries>] }` where `name` will become the name of the list file in `/etc/apt/sources.list.d/<name>.list` and the entries will be added to the file.


```
apt_manage_additional_sources: true
apt_additional_sources:
  - name: docker-ce
    entries:
      - 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'
  - name: oracle-ppa
    entries:
      - 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main'
      - 'deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main'
```

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


|           Variable Name           |   Default   |                                                     Description                                                     |
|:---------------------------------:|:-----------:|:-------------------------------------------------------------------------------------------------------------------:|
|    `external_dependency_delay`    |     `20`    |                  The time in seconds between external dependency retries. (repos, keyservers, etc)                  |
|   `external_dependnecy_retries`   |     `6`     |                          The number of retries to attempt accessing an external dependency.                         |
|         `apt_manage_keys`         |    `true`   |                                                                                                                     |
|     `apt_manage_sources_list`     |    `true`   |                                                                                                                     |
|  `apt_manage_additional_sources`  |    `true`   |                                                                                                                     |
|      `apt_manage_transports`      |    `true`   |                                Enables or Disables the management of apt transports.                                |
|        `apt_manage_config`        |    `true`   |                                Enables or Disables the management of the apt config.                                |
|             `apt_keys`            |             |     Array of hashes containing key information to be added to apt. See [apt-key management](#apt-key-management)    |
|         `apt_sources_list`        |             |                 Array of entries to be added to the main sources.list file (`/etc/apt/sources.list`)                |
|      `apt_additional_sources`     |             | Array of hashes containing additional sources to be added to the sources list directory (`/etc/apt/sources.list.d`) |
|            `apt_config`           |             |   A hash containing the apt config. See the [apt-configuration](#apt-configuration) section for more information.   |
|          `apt_transports`         | `[ https ]` |       An array of names of apt transports to install. Options include: `https`, `s3`, `spacewalk`, and `tor`.       |
|   `apt_transport_https_version`   |             |                             The version of the `apt-transport-https` package to install.                            |
|     `apt_transport_s3_version`    |             |                              The version of the `apt-transport-s3` package to install.                              |
| `apt_transport_spacewalk_version` |             |                           The version of the `apt-transport-spacewalk` package to install.                          |
|    `apt_transport_tor_version`    |             |                              The version of the `apt-transport-tor` package to install.                             |



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

**NOTE** Testing for apt-key management is ONLY done on the keyserver/ID scenario.

License
----------

MIT



Author Information
----------

Created by Bob Killen, maintained by the Department of [Advanced Research Computing and Technical Services](http://arc-ts.umich.edu/) of the University of Michigan.
