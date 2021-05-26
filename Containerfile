FROM registry.fedoraproject.org/fedora-toolbox as obs-v4l2sink-builder

RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
RUN dnf install -y obs-studio qt5-qtbase-devel obs-studio-devel cmake qt5-qtbase-private-devel
RUN dnf groupinstall -y "Development Tools"
WORKDIR /tmp/
RUN git clone --recursive https://github.com/obsproject/obs-studio.git && \
    git clone https://github.com/CatxFish/obs-v4l2sink.git && \
    cd obs-v4l2sink && \
    mkdir build && cd build && \
    cmake -DLIBOBS_INCLUDE_DIR="../../obs-studio/libobs" -DCMAKE_INSTALL_PREFIX=/usr ..  && \
    make -j$(nproc) && \
    make install

#-- Installing: /usr/lib64/obs-plugins/v4l2sink.so
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/zh-TW.ini
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/zh-CN.ini
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/it_IT.ini
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/es-ES.ini
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/en-US.ini
#-- Installing: /usr/share/obs/obs-plugins/v4l2sink/locale/de-DE.ini



FROM registry.fedoraproject.org/fedora-toolbox

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

RUN dnf install -y ansible tig vim v4l-utils pip freerdp telnet pwgen bind-utils \
                   fontawesome-fonts-web.noarch fontawesome-fonts.noarch \
                   powerline-fonts redhat-display-fonts.noarch \
                   redhat-text-fonts.noarch texlive-fontawesome.noarch

# Install hetzner stuff
RUN pip install hcloud

# Install timer-for-harvest
RUN dnf install -y \
    xdg-utils netsurf \
    https://github.com/frenkel/timer-for-harvest/releases/download/v0.3.6/fedora-33-timer-for-harvest-0.3.6-1.x86_64.rpm

# Install vscode
RUN rpm --import https://packages.microsoft.com/keys/microsoft.asc && \
    echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo && \
    dnf install -y code


# Install ffmpeg
RUN dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
                https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

RUN dnf install -y obs-studio ffmpeg mplayer

COPY --from=obs-v4l2sink-builder /usr/lib64/obs-plugins/v4l2sink.so /usr/lib64/obs-plugins/v4l2sink.so
COPY --from=obs-v4l2sink-builder /usr/share/obs/obs-plugins/v4l2sink /usr/share/obs/obs-plugins/v4l2sink

# Sometimes you need dig...
# bind-utils -> dig
# diffutils -> diff
# iputils -> ping
# iproute -> ip
#RUN dnf install -y bind-utils diffutils iputils iproute


# https://docs.docker.com/engine/reference/builder/#understand-how-cmd-and-entrypoint-interact
#ENTRYPOINT ["/bin/sh","-c"]
#CMD ["sleep infinity"]
