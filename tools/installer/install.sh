#!/bin/sh

echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d
apt-get update
apt-get install -y --fix-missing $*
