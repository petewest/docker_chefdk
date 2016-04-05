# Docker image with ChefDK

Docker image, based on ubuntu:14.04, with ChefDK installed.

## Volumes

Mount your Chef code to /repo with:

    docker run -it -v /path/to/chef/repo:/repo petewest/chefdk

Then you can run `knife` commands as normal.

## Using in CI

This image can be used to deploy cookbooks direct from your CI.

1. Create a new chef user for deploying from CI (e.g.: use
`chef-server-ctl user-create ...` if you're using chef on-premises).
2. Set environment variables for `CHEF_SERVER`, `CHEF_USER` and `CHEF_KEY`
to be your chef organisation URL, username and private key respectively.
This should be done through your CI settings so they're hidden variables.
3. Your script to upload to Chef will look something like:
~~~bash
# Create a temporary folder
tmp_dir=$(mktemp -d)
# Clean it up on exit
trap 'rm -fr "$tmp_dir"' EXIT
tmp_key="$tmp_dir/key"
cookbook_dir="$tmp_dir/cookbooks"
# Copy the key to a temporary file
echo "$CHEF_KEY" > "$tmp_key"
# Create a cookbook folder (cookbook commands NEED a cookbook folder and will
# search all sub folders for cookbooks to upload so we create a temporary
# area just for this commit to ensure it can't possibly find any other
# cookbooks and upload those instead
mkdir -p "$cookbook_dir"
# Link the current repo in to the cookbook folder
ln -s "$(pwd)" "$cookbook_dir"
# Upload the cookbook to the server
knife cookbook upload cookbook_name --server-url "$CHEF_SERVER" -k "$tmp_key" -u "$CHEF_USER" -o "$cookbook_dir"
~~~
Remember to replace cookbook_name with the name of your cookbook.

## SSL errors

If you get SSL errors when using `knife` commands you can use `knife ssl fetch`
if you're running with a self-signed certificate.
If you're running with a local CA-signed certificate copy your CA file over
(you can add it to the repo, or use `curl` in your script, etc) and set
`SSL_CERT_FILE` environment variable before running your `knife` commands.

