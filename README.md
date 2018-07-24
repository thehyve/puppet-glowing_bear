# Puppet module for Glowing Bear.

This is the repository containing a puppet module for deploying the _[Glowing Bear]_ application,
an [Angular] based front end for the _TranSMART_ application.
TranSMART is an open source data sharing and analytics platform for translational biomedical research, which
is maintained by the [tranSMART Foundation].

The module creates the system user `glowingbear`, downloads and installs
the Glowing Bear application, and configures Apache to serve the application
on the configured address.
The repository used to fetch the required Glowing Bear packages from is configurable and defaults to `repo.thehyve.nl`.


## Dependencies and installation

### Install Puppet
```bash
# Install Puppet
apt install puppet

# Check Puppet version, Puppet 4.8 and Puppet 5 should be fine.
puppet --version
```

### Puppet modules
The module depends on the `stdlib`, `archive` and `apache` modules.

The most convenient way is to run `puppet module install` as `root`:
```bash
sudo puppet module install puppetlabs-stdlib
sudo puppet module install puppet-archive
sudo puppet module install puppetlabs-apache
```

Check the installed modules:
```bash
sudo puppet module list --tree
```

### Install the `glowing_bear` module
Copy the `glowing_bear` module repository to the `/etc/puppetlabs/code/modules` directory:
```bash
cd /etc/puppetlabs/code/modules
git clone https://github.com/thehyve/puppet-glowing_bear.git glowing_bear
```

## Configuration

### The node manifest

For each node where you want to install Glowing Bear, the module needs to be included with
`include ::glowing_bear::complete`.

Here is an example manifest file `manifests/test.example.com.pp`:
```puppet
node 'test.example.com' {
    include ::glowing_bear::complete
}
```
The node manifest can also be in another file, e.g., `site.pp`.

### Configuring a node using Hiera

It is preferred to configure the module parameters using Hiera.

To activate the use of Hiera, configure `/etc/puppetlabs/code/hiera.yaml`. Example:
```yaml
---
:backends:
  - yaml
:yaml:
  :datadir: '/etc/puppetlabs/code/hieradata'
:hierarchy:
  - '%{::clientcert}'
  - 'default'
```
Defaults can then be configured in `/etc/puppetlabs/code/hieradata/default.yaml`, e.g.:
```yaml
---
glowing_bear::version: 0.0.1-SNAPSHOT
```

Machine specific configuration should be in `/etc/puppetlabs/code/hieradata/${hostname}.yaml`, e.g.,
`/etc/puppetlabs/code/hieradata/test.example.com.yaml`:
```yaml
---
glowing_bear::hostname: gb-vm.example.com
glowing_bear::app_url: https://glowingbear.example.com
glowing_bear::transmart_url: https://transmart.example.com
```

### Configuring a node in the manifest file

Alternatively, the node specific configuration can also be done with class parameters in the node manifest.
Here is an example:
```puppet
node 'test.example.com' {
    # Site specific configuration for Transmart
    class { '::glowing_bear::params':
        hostname      => 'gb-vm.example.com',
        app_url       => 'https://glowingbear.example.com',
        transmart_url => 'https://transmart.example.com',
    }

    include ::glowing_bear::complete
}
```

### Configuring the use of a proxy
```puppet
node 'test.example.com' {
    ...

    # Configure a proxy for fetching artefacts
    Archive::Nexus {
        proxy_server => 'http://proxyurl:80',
    }
    # Configure a proxy for fetching packages with yum
    Yumrepo {
        proxy => 'http://proxyurl:80',
    }
}
```


## Masterless installation
It is also possible to use the module without a Puppet master by applying a manifest directly using `puppet apply`.

There is an example manifest in `examples/complete.pp`.

```bash
cd /etc/puppetlabes/code/modules/glowing_bear
sudo puppet apply examples/complete.pp
```


## Development

### Test
There are some automated tests, run using [rake].

`ruby >= 2.3` is required. [rvm] can be used to install a specific version of `ruby`.
Use `rvm install 2.4` to use `ruby` version `2.4`.

The tests are automatically run on our Bamboo server: [PUPPET-GB](https://ci.ctmmtrait.nl/browse/PUPPET-GB).

#### Rake tests
Install rake using the system-wide `ruby`:
```bash
yum install ruby-devel
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
or using `rvm`:
```bash
rvm install 2.4
gem install bundler
export PUPPET_VERSION=4.8.2
bundle
```
Run the test suite:
```bash
rake test
```

### Classes

Overview of the classes defined in this module.

| Class name | Description |
|------------|-------------|
| `::glowing_bear` | Creates the system user. |
| `::glowing_bear::assets` | Downloads the requires assets. |
| `::glowing_bear::config` | Generates the application configuration. |
| `::glowing_bear::vhost`  | Configures an Apache virtual host. |
| `::glowing_bear::complete` | Installs all of the above. |


### Module parameters

Overview of the parameters that can be used in Hiera to configure the module.
Alternatively, the parameters of the `::glowing_bear::params` class can be used to configure these settings.

| Hiera key | Default value | Description |
|-----------|---------------|-------------|
| `glowing_bear::version`       | `0.0.1-SNAPSHOT` | The version of Glowing Bear to install. |
| `glowing_bear::nexus_url`     | `https://repo.thehyve.nl` | The Nexus/Maven repository server. |
| `glowing_bear::repository`    | `snapshots` | The repository to use. [`snapshots`, `releases`] |
| `glowing_bear::user`          | `glowingbear` | System user that owns the application assets. |
| `glowing_bear::user_home`     | `/home/${user}` | The user home directory |
| `glowing_bear::hostname`      | | The hostname of the virtual host that hosts the application (e.g., the name of the virtual machine where it is deployed). |
| `glowing_bear::port`          | 80 | The port Apache should listen to. |
| `glowing_bear::app_url`       | | The address where the Glowing Bear application will be available. |
| `glowing_bear::transmart_url` | | The address of the TranSMART back end application. |
| `glowing_bear::env`           | `dev` | The Glowing Bear environment to use. [`default`, `dev`, `transmart`] |
| `glowing_bear::show_observation_counts` | `true` | Show both subject counts and observation counts. |
| `glowing_bear::include_data_table` | `true` | Show a data table below data selection. |
| `glowing_bear::include_query_subscription` | `false` | Enable query subscription. |
| `glowing_bear::tree_node_counts_update` | Glowing Bear default | Flag is tree node counts should be automatically updated. |
| `glowing_bear::autosave_subject_sets` | Glowing Bear default | Flag if subject selection should be automatically persisted. |
| `glowing_bear::export_data_view` | Glowing Bear default | Set data view for exports [`default`, `surveyTable`] |
| `glowing_bear::authentication_service_type` | `transmart` | Authentication service type [`transmart`, `oidc`] |
| `glowing_bear::oidc_server_url` | | Identity provider URL for when OpenID Connect is used for authentication. |
| `glowing_bear::oidc_client_id` | `glowingbear-js` | Client ID for OpenID Connect. |

Note that the modules only serves the application over plain HTTP, by configuring a simple Apache virtual host.
For enabling HTTPS, a separate Apache instance needs to be setup as a proxy.
Typically, the application should be installed in a small virtual machine where this module is applied,
with an SSL proxy installed on the host machine.


## License

Copyright &copy; 2017&ndash;2018 &nbsp; The Hyve.

The puppet module for Glowing Bear is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the [GNU General Public License](LICENSE) along with this program. If not, see https://www.gnu.org/licenses/.


[Glowing Bear]: https://github.com/thehyve/glowing-bear
[tranSMART Foundation]: http://transmartfoundation.org
[Angular]: https://angular.io/
[rake]: https://github.com/ruby/rake
[rvm]: https://rvm.io/
