### Couchbase server repo

*WIP: this repository is a work-in-progress, probably never finished*

This repository contains dockerfiles for couchbase database deployments.
Couchbase promotes manual server setup (as well as most user-crafted Docker
images), so this repository serves two purposes:

- Provide fresh (4.0+) install of couchbase server
- Perform all initialization operations during container startup

Currently this repository holds just a single image (for couchbase 4.0
community version) for a single-node installation.

#### Common options

You won't have any need to tweak anything but ram size / username / password,
but anyway:

| Option                       | Default                    | Note                                |
|------------------------------|----------------------------|-------------------------------------|
| `COUCHBASE_CLUSTER_RAM_SIZE` | `1024`                     | Cluster RAM allocation in megabytes |
| `COUCHBASE_PORT`             | `8091`                     | Port to listen on (>= 1024)         |
| `COUCHBASE_DATA_PATH`        | `/var/lib/couchbase/data`  ||
| `COUCHBASE_INDEX_PATH`       | `/var/lib/couchbase/index` ||
| `COUCHBASE_NODE_HOSTNAME`    |                            ||
| `COUCHBASE_ADMIN_USERNAME`   | `couchbase`                | Admin login                         |
| `COUCHBASE_ADMIN_PASSWORD`   | `couchbase`                | Admin password                      |
| `COUCHBASE_SERVICES`         | `data,index,query`         | Couchbase services to be used       |
| `COUCHBASE_TIMEOUT`          | `30`                       | Timeout container will wait for Couchbase to bring itself up before termination |

#### TODOs

* Container restart support (don't run commands on already initialized server)
* Exit by Ctrl-C without intermediate menus
* Bucket creation