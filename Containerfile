FROM registry.fedoraproject.org/f33/fedora-toolbox:33

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

# Not need intalled on host
# RUN echo "===== Install jq 1.6 =====" \
#  && curl -# -L -o /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 \
#  && chmod +x /usr/local/bin/jq

RUN echo "===== Install yq 3.4.1 =====" \
 && curl -# -L -o /usr/local/bin/yq https://github.com/mikefarah/yq/releases/download/3.4.1/yq_linux_amd64\
 && chmod +x /usr/local/bin/yq

RUN echo "===== Install Harvest v0.9.8" \
 && curl -# -L -o /tmp/linux_386.zip https://github.com/jamesburns-rts/harvest-go-cli/releases/download/v0.9.8/linux_386.zip \
 && unzip -d /usr/local/bin/ /tmp/linux_386.zip harvest \
 && chmod +x /usr/local/bin/harvest \
 && rm /tmp/linux_386.zip

RUN echo "===== Install GRV v0.3.2" \
 && curl -# -L -o /usr/local/bin/grv https://github.com/rgburke/grv/releases/download/v0.3.2/grv_v0.3.2_linux64 \
 && chmod +x /usr/local/bin/grv


RUN chown root:root /usr/local/bin/*

RUN dnf install -y ansible tig

# Sometimes you need dig...
# bind-utils -> dig
# diffutils -> diff
# iputils -> ping
# iproute -> ip
#RUN dnf install -y bind-utils diffutils iputils iproute


# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
#ENTRYPOINT ["/bin/sh","-c"]
#CMD ["sleep infinity"]