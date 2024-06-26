ARG FEDORA_VERSION=40
ARG FROM=registry.fedoraproject.org/fedora-toolbox:${FEDORA_VERSION}

FROM ${FROM}

RUN echo "===== Install grpcurl v1.7.0=====" \
 && curl -# -L -o /tmp/grpcurl.tar.gz https://github.com/fullstorydev/grpcurl/releases/download/v1.7.0/grpcurl_1.7.0_linux_x86_64.tar.gz \
 && tar xzvf /tmp/grpcurl.tar.gz -C /usr/local/bin/ grpcurl \
 && chmod +x /usr/local/bin/grpcurl \
 && rm /tmp/grpcurl.tar.gz

RUN echo "===== Install latest oc & kubectl =====" \
 && curl -# -L -o /tmp/openshift-client-linux.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz \
 && tar xzvf /tmp/openshift-client-linux.tar.gz -C /usr/local/bin/ oc kubectl \
 && chmod +x /usr/local/bin/oc /usr/local/bin/kubectl \
 && rm /tmp/openshift-client-linux.tar.gz

RUN echo "===== Install latest helm =====" \
 && curl -# -L -o /usr/local/bin/helm https://mirror.openshift.com/pub/openshift-v4/clients/helm/latest/helm-linux-amd64 \
 && chmod +x /usr/local/bin/helm

RUN echo "===== Install latest govc =====" \
 && curl -# -L -o /usr/local/bin/govc.gz https://github.com/vmware/govmomi/releases/download/v0.22.1/govc_linux_amd64.gz \
 && gzip -d /usr/local/bin/govc.gz \
 && chmod +x /usr/local/bin/govc

RUN echo "===== Install yq 4.9.5 =====" \
 && curl -# -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/v4.9.5/yq_linux_amd64\
 && chmod +x /usr/local/bin/yq

RUN echo "===== Install GRV v0.3.2" \
 && curl -# -L -o /usr/local/bin/grv https://github.com/rgburke/grv/releases/download/v0.3.2/grv_v0.3.2_linux64 \
 && chmod +x /usr/local/bin/grv

# https://github.com/ibraheemdev/modern-unix#----delta--
RUN echo "===== Install delta" \
 && curl -# -L -o /tmp/delta.tar.gz https://github.com/dandavison/delta/releases/download/0.8.3/delta-0.8.3-x86_64-unknown-linux-gnu.tar.gz \
 && tar --strip-components=1 -C /tmp/ -xzvf  /tmp/delta.tar.gz  '*/delta' \
 && install -m 755 -o root /tmp/delta /usr/local/bin/ \
 && rm /tmp/delta

# wget https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.16.0/kubeseal-linux-amd64 -O kubeseal
# sudo install -m 755 kubeseal /usr/local/bin/kubeseal

RUN chown root:root /usr/local/bin/*

RUN dnf install -y ansible tig vim v4l-utils pip freerdp telnet pwgen bind-utils \
                   fontawesome-fonts-web.noarch \
                   powerline-fonts redhat-display-fonts.noarch \
                   redhat-text-fonts.noarch texlive-fontawesome.noarch vim \
                   openssl figlet openldap-clients poppler-utils the_silver_searcher \
                   golang pre-commit ack

# poppler-utils  provides `pdftoppm -png` convert pdf to png

# Install gmail-yaml-filters
RUN dnf install -y libxml2-devel gcc libxslt-devel python3-devel
# Install my version unless PR [0] is merged
# [0] https://github.com/mesozoic/gmail-yaml-filters/pull/29
#RUN pip install gmail-yaml-filters
RUN pip install https://github.com/rbo/gmail-yaml-filters-1/archive/refs/heads/master.tar.gz

# Install github cli
RUN curl -L -o /etc/yum.repos.d/gh-cli.repo https://cli.github.com/packages/rpm/gh-cli.repo && \
    dnf install -y gh

# Install ffmpeg
RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y ffmpeg mplayer wf-recorder

# Sometimes you need dig...
# bind-utils -> dig
# diffutils -> diff
# iputils -> ping
# iproute -> ip
#RUN dnf install -y bind-utils diffutils iputils iproute


# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
#ENTRYPOINT ["/bin/sh","-c"]
#CMD ["sleep infinity"]
