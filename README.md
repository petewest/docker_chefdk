# Docker image with ChefDK

Docker image, based on ubuntu:14.04, with ChefDK installed.

## Volumes

Mount your Chef code to /repo with:

    docker run -it -v /path/to/chef/repo:/repo petewest/chefdk

Then you can run `knife` commands as normal.

