FROM centos:8

################################################################################
# VS Code Visual Studio IDE
RUN set -ex; \
rpm --import https://packages.microsoft.com/keys/microsoft.asc; \
sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'; \
dnf install -y libX11-xcb code; \
dnf clean all; \
rm -rf /tmp/*

################################################################################
# Install system packages
RUN set -ex; \
dnf install -y bind-utils bzip2 ca-certificates curl-devel nmap-ncat openssl \
openssl-devel psmisc python3 rsyslog sudo wget which vim man git; \
# fix locale
dnf install -y glibc-locale-source glibc-langpack-en intltool; \
localedef -i en_US -f UTF-8 en_US.UTF-8; \
tee /etc/sysconfig/i18n <<<'"LANG=en_US.UTF-8"'; \
yum clean all; \
rm -rf /tmp/*

################################################################################
# Install Go binaries
# install dumb-init
RUN set -ex; \
version=1.2.2; \
hash=37f2c1f0372a45554f1b89924fbb134fc24c3756efaedf11e07f599494e0eff9; \
curl -fLo /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v"$version"/dumb-init_"$version"_amd64; \
echo "$hash  /usr/local/bin/dumb-init" | sha256sum -c -; \
chmod 755 /usr/local/bin/dumb-init

# Install jq utility
RUN set -ex; \
SHASUM=af986793a515d500ab2d35f8d2aecd656e764504b789b66d7e1a0b727a124c44; \
INSTALL=/usr/local/bin/jq; \
URL=https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64; \
curl -sfLo "${INSTALL}" "${URL}"; \
sha256sum -c - <<< "${SHASUM}  ${INSTALL}"; \
chmod 755 "${INSTALL}"


# Install goss utility
RUN set -ex; \
SHASUM=53dd1156ab66f2c4275fd847372e6329d895cfb2f0bcbec5f86c1c4df7236dde; \
INSTALL=/usr/local/bin/goss; \
URL=https://github.com/aelsabbahy/goss/releases/download/v0.3.6/goss-linux-amd64; \
curl -sfLo "${INSTALL}" "${URL}"; \
sha256sum -c - <<< "${SHASUM}  ${INSTALL}"; \
chmod 755 "${INSTALL}"

################################################################################
# Install AWS Tools
RUN set -ex; \
pip3 install awscli cfn-lint

# Install AWS CDK
RUN set -ex; \
version=v12.16.1; \
hash=b826753f14df9771609ffb8e7d2cc4cb395247cb704cf0cea0f04132d9cf3505; \
curl --fail --compressed -q -L -C - --progress-bar https://nodejs.org/dist/"$version"/node-"$version"-linux-x64.tar.xz -o /tmp/node.tar.xz; \
#sha256sum /tmp/node.tar.xz; \
sha256sum -c - <<< "$hash  /tmp/node.tar.xz"; \
cd /opt; \
tar -xf /tmp/node.tar.xz; \
rm /tmp/node.tar.xz; \
ls -1d node* | xargs -n1 -I{} ln -s '{}' node; \
for x in node npm npx; do \
update-alternatives --install /usr/local/bin/"$x" "$x" /opt/node/bin/"$x" 1; \
update-alternatives --set "$x" /opt/node/bin/"$x"; \
done; \
npm install -g aws-cdk; \
update-alternatives --install /usr/local/bin/cdk cdk /opt/node/bin/cdk 1; \
update-alternatives --set cdk /opt/node/bin/cdk; \
rm -rf /tmp/*

################################################################################
# Create and configure user account
RUN useradd -m -s /bin/bash -G wheel -d /home/aws-user aws-user && \
chown -R aws-user. /usr/local; \
echo '%wheel         ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

USER aws-user
WORKDIR /home/aws-user

RUN set -ex; \
mkdir -p ~/usr/share ~/usr/bin ~/git; \
cd ~/git; \
git clone https://github.com/samrocketman/home.git; \
cd home; \
./setup.sh; \
cd ~/usr/share; \
git clone https://github.com/samrocketman/git-identity-manager.git; \
cd git-identity-manager; \
ln -s "$PWD"/git-idm ~/usr/bin/git-idm

################################################################################
# Default Docker runtime
ENTRYPOINT ["/usr/local/bin/dumb-init", "--"]
CMD /bin/bash
