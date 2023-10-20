FROM debian
LABEL org.opencontainers.image.source=https://github.com/noose/kops

# install glibc compatibility for alpine
RUN apt update \
    && apt install --no-install-recommends -y unzip curl ca-certificates jq \
    && curl -sL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip \
    && unzip awscliv2.zip \
    && aws/install \
    && rm -rf \
        awscliv2.zip \
        aws \
        /usr/local/aws-cli/v2/*/dist/aws_completer \
        /usr/local/aws-cli/v2/*/dist/awscli/data/ac.index \
        /usr/local/aws-cli/v2/*/dist/awscli/examples \
        /var/lib/apt/lists/*

ARG KOPS_VERSION=1.28.0
ARG KUBECTL_VERSION=v1.27.7
ARG HELM_VERSION=v3.13.0

RUN  curl -sLo /usr/local/bin/kops https://github.com/kubernetes/kops/releases/download/${KOPS_VERSION}/kops-linux-amd64
RUN curl -sLo /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl
RUN curl -L https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xvz && mv linux-amd64/helm /usr/local/bin/helm
RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp && mv /tmp/eksctl /usr/local/bin/eksctl
RUN chmod +x /usr/local/bin/kops /usr/local/bin/kubectl /usr/local/bin/helm /usr/local/bin/eksctl

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
