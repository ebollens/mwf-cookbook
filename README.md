# MWF

## Description

The cookbook provides the ability to manage deployments of the Mobile Web
Framework (MWF) through either Apache vhosts or aliases. More details on MWF 
may be found at https://github.com/ucla/mwf

## Requirements

This cookbook requires the following cookbooks:

* apache2
* git
* php

This cookbook includes the `apache2`, `apache2::mod_php5`, `php`, 
`php::module_curl` and `php::module_gd` recipes and leverages the `git` 
deploy resource.

## Usage

The `default` recipe is used to deploy vhost and alias configurations of MWF 
instances. This recipe installs dependencies, syncs MWF Git repository, sets up 
the Apache alias or vhost, defining the document root and configures the MWF 
`var` directory.

See "Attributes" for more details about configuration and "Definitions" for 
an explanation of the `mwf\_instance` used by this recipe.

## Attributes

### mwf['dedicated']

This set of attributes control vhost-based Apache configurations of MWF.

To enable vhost functionality:

```js
{
    "mwf" : {
        "dedicated": {
            "enable": false
        }
    }
}
```

By default when enabled, this will lead to the cookbook deploying an instance 
of MWF on a wildcard `*` vhost. However, there are a number of customizations 
that may be made to change this single vhost deployment of MWF. The following 
example details the available attributes for the single vhost configuration 
(with their default values set except for `enable`, which defaults to false):

```js
{
    "mwf" : {
        "dedicated": {
            "enable": true,
            "hostname": "*",
            "directory": "/var/www/mwf_dedicated",
            "repository": "https://github.com/ucla/mwf.git",
            "reference": "master",
            "owner": node['apache']['user'],
            "group": node['apache']['group'],
            "mode": "0755",
            "hosts": {
                "default": {
                    "directory" => "default"
                }
            }
        }
    }
}
```

This will deploy an instance of MWF from `github.com:ucla/mwf:master` to the
directory `/var/www/mwf_dedicated/default` for all names that the host responds 
to.

One may also specify multiple vhosts. When using this approach, any attribute 
not set within `mwf['dedicated']['hosts']` is inherited from the set 
above in `mwf['dedicated']`. As such, one can modify a value in the 
above set to affect all vhosts except those that explicitly set the
value. The `enable` bit may be used, for a particular name, to disable it 
(removes the Apache configuration for it, as well as its web root).


```js
{
    "mwf": {
        "dedicated": {
            "enable": true,
            "hosts": {
                "default": {
                    "enable": false
                },
                "production": {
                    "enable": true,
                    "hostname": "example.com",
                    "directory": "production"
                },
                "stage": {
                    "enable": true,
                    "hostname": "stage.example.com",
                    "branch": "stage",
                    "directory": "stage"
                },
                "fork": {
                    "enable": true,
                    "hostname": "fork.example.com",
                    "repository": "https://github.com/ORG/mwf.git",
                    "directory": "fork"
                }
            }
        }
    }
}
```

This will deploy three instances of MWF. The first will be from 
`github.com:ucla/mwf:master` to the directory 
`/var/www/mwf_dedicated/production` for the hostname `example.com`. The second 
will be from `github.com:ucla/mwf:stage` to the directory 
`/var/www/mwf_dedicated/stage` for the hostname `stage.example.com`. Finally, 
the third will be from `https://github.com/ORG/mwf.git` to the directory
`/var/www/mwf_dedicated/fork` for the hostname `fork.example.com`.

### mwf['alias']

This set of attributes control alias-based Apache configurations of MWF.

To enable vhost functionality:

```js
{
    "mwf" : {
        "alias": {
            "enable": false
        }
    }
}
```

By default when enabled, this will lead to the cookbook deploying an instance 
of MWF under the aliased `/mwf`. However, there are a number of customizations 
that may be made to change this single aliased deployment of MWF. The following 
example details the available attributes for the single vhost configuration 
(with their default values set except for `enable`, which defaults to false):

```js
{
    "mwf" : {
        "alias": {
            "enable": true,
            "path": "mwf",
            "directory": "/var/www/mwf",
            "repository": "https://github.com/ucla/mwf.git",
            "reference": "master",
            "owner": node['apache']['user'],
            "group": node['apache']['group'],
            "mode": "0755",
            "instances": {
                "default": {
                    "directory": "mwf"
                }
            }
        }
    }
}
```

This will deploy an instance of MWF from `github.com:ucla/mwf:master` to the
directory `/var/www/mwf/mwf` and alias it to the path `/mwf`.

As with vhosts, one may specify multiple aliases. When using this approach, any 
attribute not set within `mwf['alias']['instances']` is inherited from the 
set above in `mwf['alias']`. As such, one can modify a value in the above 
set to affect all aliases except those that explicitly set the value. The 
`enable` bit may be used, for a particular name, to disable it (removes the 
Apache configuration for it, as well as its web root).

```js
{
    "mwf" : {
        "alias": {
            "enable": true,
            "instances": {
                "default": {
                    "enable": false,
                    "directory": "mwf"
                },
                "production": {
                    "enable": true,
                    "directory": "production",
                    "path": "mwf"
                },
                "stage": {
                    "enable": true,
                    "branch": "stage",
                    "directory": "stage",
                    "path": "stage"
                },
                "fork": {
                    "enable": true,
                    "repository": "https://github.com/ORG/mwf.git",
                    "directory": "fork",
                    "path": "fork"
                }
            }
        }
    }
}
```

## Definitions

### mwf\_instance

This definition can be used to manage a Git clone of an MWF instance.

The definition takes the following parameters:

* `enable`: true checks out the specified Git repository, while false deletes 
  the repository specified by name [default: `true`].
* `path`: specifies the web-accessible path to the MWF `root` directory 
  [default: `/`].
* `git_repository`: specifies the Git repository from whence MWF should be
  cloned, allowing for a fork of the MWF to be cloned [default: 
  `https://github.com/ucla/mwf.git`].
* `git_reference`: specifies a Git branch, tag or commit ID that the Git 
  repository from MWF will be synced to [default: `master`].
* `owner`: specifies the web user that will write temporary files to the MWF 
   `var` directory [default: `node['apache']['user']`].
* `group`: specifies the web group that will write temporary files to the MWF 
   `var` directory [default: `node['apache']['group']`].
* `mode`: specifies the mode of the temporary files directory for MWF 
  [default: `0755`].

## License and Author

Author:: Eric Bollens (<ebollens@ucla.edu>)

Copyright (c) 2013, Eric Bollens
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:

  * Redistributions of source code must retain the above copyright notice, 
    this list of conditions and the following disclaimer.

  * Redistributions in binary form must reproduce the above copyright notice, 
    this list of conditions and the following disclaimer in the documentation 
    and/or other materials provided with the distribution.

  * Neither the name of the University of California nor the names of its 
    contributors may be used to endorse or promote products derived from this 
    software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
 ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES 
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; 
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON 
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS 
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
