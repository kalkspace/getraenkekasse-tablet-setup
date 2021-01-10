#!/bin/sh

apt-get update && apt-get install -y apt-utils

cat > /config-deb <<EOF

# A config-deb file.

# Points to where the unpacked DVD-1 is.
Dir {
    ArchiveDir "/data";
};

# Sets the top of the .deb directory tree.
TreeDefault {
   Directory "pool/";
};

# The location for a Packages file.                
BinDirectory "pool/main" {
   Packages "dists/bullseye/main/binary-amd64/Packages";
};

# We are only interested in .deb files (.udeb for udeb files).                                
Default {
   Packages {
       Extensions ".deb";
    };
};
EOF

apt-ftparchive generate config-deb
sed -i '/MD5Sum:/,$d' /data/dists/bullseye/Release
apt-ftparchive release /data/dists/bullseye >> /data/dists/bullseye/Release