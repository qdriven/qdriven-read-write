#!/bin/bash

DIR=.
DIST_URL="http://resource.koderover.com/installer_dist"
KR_UTILS_FILE="koderover-utils.tar.gz"
KR_HOME=${HOME}/.koderover

k8sVersion="1.19.3"


GREEN='\033[0;32m'
RED='\033[0;31m'
NOCOLOR='\033[0m'
LIGHT_BLUE='\033[0;34m'
YELLOW='\033[0;33m'

LOGPATH=${DIR}/installer.log

logSuccess() {
  printf "${GREEN} $1${NOCOLOR}\n" 1>&2
  printf "[SUCCESS] $1 \n" >> "${LOGPATH}"
}

logPrompt() {
  printf " $1\n" 1>&2
  printf "[PROMPT] $1\n" >> "${LOGPATH}"
}

logInfo() {
  printf "[INFO] $1\n" 1>&2
  printf "[INFO] $1\n" >> "${LOGPATH}"
}

logWarn() {
  printf "${YELLOW} $1${NOCOLOR}\n" 1>&2
  printf "[WARN] $1\n" >> "${LOGPATH}"
}

logError() {
  printf "${RED}[ERROR] $1${NOCOLOR}\n" 1>&2
  printf "[ERROR] $1\n" >> "${LOGPATH}"
}

RunCommandWithlog() {
  local cmd=$@
  $cmd 2>&1 | tee -a ${LOGPATH}
}

printLogo() {
  printf "${YELLOW} _____          _ _       \n"
  printf "${YELLOW}/ _  / __ _  __| (_) __ _ \n"
  printf "${YELLOW}\// / / _. |/ _. | |/ _. |\n"
  printf "${YELLOW} / //\ (_| | (_| | | (_| |\n"
  printf "${YELLOW}/____/\__,_|\__,_|_|\__, |\n"
  printf "${YELLOW}                    |___/\n"
}
bail() {
    logError "$@"
    exit 1
}

confirmDefaultNo() {
  promptTimeout "$@"
  if [ "$PROMPT_RESULT" = "y" ] || [ "$PROMPT_RESULT" = "Y" ]; then
    return 0
  fi
  return 1
}

confirmDefaultYes() {
  promptTimeout "$@"
  if [ "$PROMPT_RESULT" = "n" ] || [ "$PROMPT_RESULT" = "N" ]; then
    return 1
  fi
  return 0
}

if [ -z "$READ_TIMEOUT" ]; then
    READ_TIMEOUT="-t 20"
fi

promptTimeout() {
  set +e
  read ${READ_TIMEOUT} PROMPT_RESULT < /dev/tty
  set -e
}

getInput() {
  set +e
  read PROMPT_RESULT < /dev/tty
  set -e
}

checkCmdExists() {
  command -v "$@" > /dev/null 2>&1
}

checkForRoot() {
  local user="$(id -un 2>/dev/null || true)"
  if [ "$user" != "root" ]; then
    bail "this installer needs to be run as root."
  fi
  FLAG_ROOTCHECK=true
}

render_yaml_file() {
  eval "echo \"$(cat $1)\""
}

loadImages() {
  find "$1" -type f | xargs -I {} bash -c "docker load < {}"
}

cleanUp() {
  logInfo "Cleaning up all the installation package..."
  logSuccess "Clean up success!"
}
getSystemInfos() {
  getDockerVersion
  getLsbInfo
  getPublicIp
  getPrivateIp
  #TODO: system spec verification

  KERNEL_MAJOR=$(uname -r | cut -d'.' -f1)
  KERNEL_MINOR=$(uname -r | cut -d'.' -f2)
}

getDockerVersion() {
  if ! checkCmdExists "docker" ; then
    return
  fi
  DOCKER_VERSION=$(docker -v | awk '{gsub(/,/, "", $3); print $3}')
}

LSB_DIST=
DIST_VERSION=
DIST_VERSION_MAJOR=
getLsbInfo() {
  _dist=
  if [ -f /etc/centos-release ] && [ -r /etc/centos-release ]; then
    # CentOS 6 & 7
    _dist="$(cat /etc/centos-release | cut -d" " -f1)"
    _version="$(cat /etc/centos-release | sed 's/Linux //' | cut -d" " -f3 | cut -d "." -f1-2)"
  elif [ -f /etc/os-release ] && [ -r /etc/os-release ]; then
    _dist="$(. /etc/os-release && echo "$ID")"
    _version="$(. /etc/os-release && echo "$VERSION_ID")"
  elif [ -f /etc/redhat-release ] && [ -r /etc/redhad-release ]; then
    # RHEL 6
    _dist="rhel"
    _major_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f1)
    _minor_version=$(cat /etc/redhat-release | cut -d" " -f7 | cut -d "." -f2)
    _version=$_major_version
  else
    _err="Cannot determine what lsb is currently running."
  fi

  if [ -n "$_dist" ]; then
    _err="Detected lsb: ${_dist}"
    _dist="$(echo "$_dist" | tr '[:upper:]' '[:lower:]')"
    case "$_dist" in
      ubuntu)
        _err="$_err\nHowever detected version $_version is less than 12."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
        [ $1 -ge 12 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
      debian)
        _err="$_err\nHowever detected version $_version is less than 7."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS"
        [ $1 -ge 7 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
      centos)
        _error_msg="$_error_msg\nHowever detected version $_version is less than 6."
        oIFS="$IFS"; IFS=.; set -- $_version; IFS="$oIFS";
        [ $1 -ge 6 ] && LSB_DIST=$_dist && DIST_VERSION=$_version && DIST_VERSION_MAJOR=$1
        ;;
    esac
  fi

  if [ -z "$LSB_DIST" ]; then
    logError "$(echo | sed "i$_err")"
    logError "Quitting..."
    exit 1
  fi
}

getPrivateIp() {
    if [ -n "$PRIVATE_ADDRESS" ]; then
        return 0
    fi
    PRIVATE_ADDRESS=$(cat /etc/kubernetes/manifests/kube-apiserver.yaml 2>/dev/null | grep advertise-address | awk -F'=' '{ print $2 }')

    #This is needed on k8s 1.18.x as $PRIVATE_ADDRESS is found to have a newline
    PRIVATE_ADDRESS=$(echo "$PRIVATE_ADDRESS" | tr -d '\n')
}

getPublicIp() {
  PUBLIC_ADDRESS=$(dig +short myip.opendns.com @resolver1.opendns.com)
}

FLAG_ROOTCHECK=
FLAG_REQCHECK=
FLAG_DOCKER=
FLAG_KUBERNETES_INSTALLATION=
FLAG_CLUSTER_READY=
FLAG_KODEROVER=

trap reportStatus EXIT

reportStatus() {
  logPrompt "*****************************************"
  logPrompt "*    Koderover installer exit report    *"
  logPrompt "*****************************************"
  if [ -z "$FLAG_ROOTCHECK" ]; then
    logError "⚙ ROOT PRIVILEGE CHECK FAILED"
  else
    logSuccess "✔ ROOT PRIVILEGE CHECK SUCCESS"
  fi

  if [ -z "$FLAG_REQCHECK" ]; then
    logError "⚙ SYSTEM CHECK FAILED"
  else
    logSuccess "✔ SYSTEM CHECK SUCCESS"
  fi

  if [ -z "$FLAG_KUBERNETES_INSTALLATION" ]; then
    logError "⚙ DEPENDENCY INSTALLATION FAILED"
  else
    logSuccess "✔ DEPENDENCY INSTALLATION SUCCESS"
  fi

  if [ -z "$FLAG_CLUSTER_READY" ]; then
    logError "⚙ KUBERNETES CLUSTER INITIALIZATION FAILED"
  else
    logSuccess "✔ KUBERNETES CLUSTER INITIALIZATION SUCCESS"
  fi

  if [ -z "$FLAG_KODEROVER" ]; then
    logError "⚙ ZADIG INSTALLATION FAILED"
  else
    logSuccess "✔ ZADIG INSTALLATION SUCCESS"
  fi

  logPrompt "*****************************************"
  logPrompt "*            END OF REPORT              *"
  logPrompt "*****************************************"
}
reportTime() {
  local behavior=$1
  if (( $SECONDS > 3600 )) ; then
    let "hours=SECONDS/3600"
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    logSuccess "${behavior} completed in $hours hour(s), $minutes minute(s) and $seconds second(s)"
elif (( $SECONDS > 60 )) ; then
    let "minutes=(SECONDS%3600)/60"
    let "seconds=(SECONDS%3600)%60"
    logSuccess "${behavior} completed in $minutes minute(s) and $seconds second(s)"
else
    logSuccess "${behavior} completed in $SECONDS seconds"
fi
}

TIMER_TIME=
setTimer() {
  TIMER_TIME=$SECONDS
}
preflightCheck() {
  check64Bit
  checkIfSupportedOS
  checkSwap
  checkIpv4Forwarding
  checkFirewalld
  checkSelinuxDisabled
  FLAG_REQCHECK=true
}

check64Bit() {
  case "$(uname -m)" in
    *64)
      ;;
    *)
      bail "This installer only works on 64 bit system"
      ;;
  esac
}

checkIfSupportedOS() {
  case "$LSB_DIST$DIST_VERSION" in
    ubuntu16.04|ubuntu18.04|ubuntu20.04|centos7.4|centos7.5|centos7.6|centos7.7|centos7.8|centos7.9|centos8.0|centos8.1|centos8.2|centos8.3)
      ;;
    *)
      bail "This installer does not support ${LSB_DIST} ${DIST_VERSION}"
      ;;
  esac
}

checkSwap() {
  if checkSwapOn || checkSwapEnabled ; then
    logWarn "The installer is incompatible with swap on, disable swap to continue installing? [y/N]"
    if confirmDefaultNo "t -20"; then
      logInfo "executing swapoff --all"
      swapoff --all
      if swapFstabEnabled; then
        disableSwapFstab
      fi
      if swapServiceEnabled; then
        disableSwapService
      fi
    fi
  fi
}

checkSwapOn() {
  swapon --summary | grep --quiet " "
}

checkSwapEnabled() {
  swapFstabEnabled || swapServiceEnabled
}

swapFstabEnabled() {
  cat /etc/fstab | grep --quiet --ignore-case --extended-regexp '^[^#]+swap'
}

swapServiceEnabled() {
  systemctl -q is-enabled temp-disk-swapfile 1>&/dev/null
}

disableSwapFstab() {
  logInfo "=> Commenting swap entries in /etc/fstab \n"
  sed --in-place=.bak '/\bswap\b/ s/^/#/' /etc/fstab
  logInfo "=> A backup of /etc/fstab has been made at /etc/fstab.bak\n\n"
  logInfo "\nChanges have been made to /etc/fstab. We recommend reviewing them after completing this installation to ensure mounts are correctly configured.${NC}\n\n"
  sleep 5
}

disableSwapService() {
  logInfo "Disabling temp-disk-swapfile service"
  systemctl disable temp-disk-swapfile
}

checkFirewalld() {
    if ! systemctl -q is-active firewalld; then
    return
  fi

  logWarn "Firewalld is active, do you want to disable it? [y/N]"
  if confirmDefaultNo; then
    systemctl stop firewalld
    systemctl disable firewalld
    return
  fi

  bail "The system cannot continue with firewalld on"
}

checkSelinuxDisabled() {
  if selinuxEnabled && selinuxEnforced; then
    logError "kubernetes is incompatible with selinux, disable it? [y/N]"
    if confirmDefaultNo; then
      setenforce 0
      sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/selinux/config
    else
      bail "disable selinux to continue"
    fi
  fi
}

selinuxEnabled() {
  if checkCmdExists "selinuxenabled"; then
    selinuxenabled
    return
  elif checkCmdExists "sestatus"; then
    ENABLED=$(sestatus | grep 'SELinux status' | awk '{ print $3 }')
    echo "$ENABLED" | grep --quiet --ignore-case enabled
    return
  fi

  return 1
}

selinuxEnforced() {
  if checkCmdExists "getenforce"; then
    ENFORCED=$(getenforce)
    echo $(getenforce) | grep --quiet --ignore-case enforcing
    return
  elif checkCmdExists "sestatus"; then
    ENFORCED=$(sestatus | grep 'SELinux mode' | awk '{ print $3 }')
    echo "$ENFORCED" | grep --quiet --ignore-case enforcing
    return
  fi

  return 1
}

checkIpv4Forwarding() {
  if [ -n "$(cat /etc/sysctl.conf | grep net.ipv4.ip_forward)" ]; then
    logWarn "Installer cannot initialize kubernetes cluster with net.ipv4.ip_forward in your /etc/sysctl.conf, turn it on? [y/N]"
    if confirmDefaultNo "t -20"; then
      sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
    else
      bail "set net.ipv4.ip_forward = 1 in your /etc/sysctl.conf file"
    fi
  fi
}

# TODO: currently only docker is supported, will include containerd if necessary
installCri() {
  if ! checkCmdExists docker; then
    logInfo "fetching docker..."
    installDocker
  fi
  printf "\n"
  FLAG_DOCKER=true
}

installDocker() {
  cgroupToSystemd
  downloadDockerPackage
  runDockerInstall
  systemctl enable docker
  systemctl start docker
}

cgroupToSystemd() {
  if [ -f /var/lib/kubelet/kubeadm-flags.env ] || [ -f /etc/docker/daemon.json ]; then
    return
  fi

  mkdir -p /etc/docker
  cat > /etc/docker/daemon.json <<EOF
{
    "exec-opts": ["native.cgroupdriver=systemd"]
}
EOF

  mkdir -p /etc/systemd/system/docker.service.d
}

downloadDockerPackage() {
  local version="19.03.10"
  # TODO: add more docker dist package and make it available to customer choice
  curl -# -LO "$DIST_URL/docker-${version}.tar.gz" 2>&1
  tar xf docker-${version}.tar.gz
  rm docker-${version}.tar.gz
}

runDockerInstall() {
  local version="19.03.10"
  case "$LSB_DIST" in
  ubuntu)
    RunCommandWithlog dpkg --install --force-depends-version $DIR/packages/docker/${version}/ubuntu-${DIST_VERSION}/*.deb
    return 0
    ;;
  centos|rhel)
    RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/docker/${version}/rhel-7/*.rpm
    return 0
    ;;
  esac

  bail "Docker installation is currently not supported on ${LSB_DIST} ${DIST_VERSION_MAJOR}"
}
## TODO: get local k8s version as a local variable
installKubernetesHost() {
  local k8sVersion="1.19.3"
  configKubernetesSysctl

  getKubernetesPackageOnline
  configKubernetesSysctl
  installKubernetesPackage
  loadImages $DIR/packages/kubernetes/${k8sVersion}/images
  printf "\n"

  FLAG_KUBERNETES_INSTALLATION=true
}

configKubernetesSysctl() {
  echo "net.ipv4.conf.all.rp_filter = 1" > /etc/sysctl.d/k8s.conf
  echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.d/k8s.conf
  case "$LSB_DIST" in
  centos|rhel)
    echo "net.bridge.bridge-nf-call-ip6tables = 1" >> /etc/sysctl.d/k8s.conf
    echo "net.bridge.bridge-nf-call-iptables = 1" >> /etc/sysctl.d/k8s.conf
    echo "net.ipv4.conf.all.forwarding = 1" >> /etc/sysctl.d/k8s.conf
    ;;
  esac
  RunCommandWithlog sysctl --system
}

getKubernetesPackageOnline() {
  logInfo "Downloading kubernetes binary....."
  curl -LO -# "$DIST_URL/kubernetes-${k8sVersion}.tar.gz" 2>&1
  tar xf kubernetes-${k8sVersion}.tar.gz
  rm kubernetes-${k8sVersion}.tar.gz
}

installKubernetesPackage() {
  logInfo "Installing kubelet, kubeadm, kubectl and cni host packages"
  if checkHostHasKubernetes "$k8sVersion"; then
    logSuccess "Kubernetes host packages already installed"
    return
  fi

  case "$LSB_DIST" in
  ubuntu)
    # TODO: what this env does?
    export DEBIAN_FRONTEND=noninteractive
    RunCommandWithlog dpkg --install --force-depends-version $DIR/packages/kubernetes/${k8sVersion}/ubuntu-${DIST_VERSION}/*.deb
    ;;
  centos)
    case "$LSB_DIST$DIST_VERSION_MAJOR" in
    centos8)
      RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/kubernetes/${k8sVersion}/rhel-8/*.rpm
      ;;
    *)
      RunCommandWithlog rpm --upgrade --force --nodeps $DIR/packages/kubernetes/${k8sVersion}/rhel-7/*.rpm
      ;;
    esac
  ;;
  esac

  RunCommandWithlog systemctl enable kubelet && systemctl start kubelet
  logSuccess "kubernetes host packages installed"
}

prepareKubernetes() {
  RunCommandWithlog kubeadm init --kubernetes-version=${k8sVersion}
  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config
  RunCommandWithlog kubectl taint nodes --all node-role.kubernetes.io/master-
  RunCommandWithlog kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
  FLAG_CLUSTER_READY=true
}

checkHostHasKubernetes() {
  local k8sVersion="$1"
  if ! checkCmdExists kubelet; then
    logWarn "kubelet command missing"
    return 1
  fi
  if ! checkCmdExists kubeadm; then
    logWarn "kubeadm command missing"
    return 1
  fi
  if ! checkCmdExists kubectl; then
    logWarn "kubectl command missing"
    return 1
  fi
}
getKRInstallParam() {
  getDomain "-t 60"
}


# This script is meant for quick & easy install via:
# $ curl -fsSL https://resources.koderover.com/install_opensource.bash | bash
# Legal environments:
# NAMESPACE: the namespace to install zadig. default value: zadig
# DOMAIN: the hostname of website. default value: poc.example.com
# IP:     the ip of the website, if domain is not applicable. one of DOMAIN and IP and ONLY ONE must be provided at the same time.
# NGINX_INGRESS_SERVICE_TYPE: the service type of nginx ingress service,
#   could be ClusterIP/LoadBalancer. works only when INGRESS_CLASS is not set.  default value: NodePort
# INGRESS_CLASS: use custom ingress class name when ingress controller already exists,
#   used as value of kubernetes.io/ingress.class in ingress metadata. default value: ""
# INSECURE_REGISTRY: The host of trusted registry (can only be accessed via http) you use. default value: ""
# STORAGE_CLASS: the storage class name to create pvc for persistence services.
#   when not provided, the data could be lost after a reboot of persistence service. default value: ""
# STORAGE_SIZE: the size of storage used by persistence services. default value: 20Gi
# MONGO_URI: The mongo database to store the pipeline and environment data. ie, mongodb://user:pass@mongo:27017/mongo .
#   Default Value: ""
# MONGO_DB: The database of zadig system
#   Default Value: "zadig"
# ENCRYPTION_KEY: The system-wide AES encryption key
# DRY_RUN: check install log without real installation

KODEROVER_HOME=${HOME}/.koderover
KODEROVER_BIN=${KODEROVER_HOME}/bin
PATH=${KODEROVER_BIN}:$PATH
ZADIG_VALUE_FILE=${KODEROVER_HOME}/values_zadig.yaml

PREFIX=${1:-${NAMESPACE:-zadig}}
HELM_REPO=${HELM_REPO:-https://koderover.tencentcloudcr.com/chartrepo/chart}
NGINX_INGRESS_SERVICE_TYPE=${NGINX_INGRESS_SERVICE_TYPE:-NodePort}
STORAGE_SIZE=${STORAGE_SIZE:-20Gi}
AES_KEY=${ENCRYPTION_KEY}

declare -a MONGO_PARAMS

update_values() {
  mkdir -p $KODEROVER_HOME
  cat > $ZADIG_VALUE_FILE <<EOF
aurora:
  apiProxyImage:
    repository: "ccr.ccs.tencentyun.com/koderover-rc/aurora-api-proxy"
    tag: "20210514134045-7-main"
poetry:
  cronImage:
    repository: ccr.ccs.tencentyun.com/koderover-rc/poetry-job
    tag: 20190726184342-v0.6.2
  image:
    repository: ccr.ccs.tencentyun.com/koderover-rc/pd-web
    tag: "20210525182640-14-pr-2"
portal:
  image:
    repository: "ccr.ccs.tencentyun.com/koderover-rc/zadig-portal"
    tag: "20210525202304-19-main"
zadig-core:
  aslan:
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/aslan"
      tag: "20210525202308-19-main"
  cron:
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/cron"
      tag: "20210525202309-19-main"
  jenkins:
    image:
      repository: ccr.ccs.tencentyun.com/koderover-rc/jenkins-plugin
      tag: "20210421163000"
  predator:
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/predator-plugin"
      tag: "20210513140017-2-ko6"
  reaper:
    binaryUrl: "http://resource.koderover.com/reaper-20210517100718-release"
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/reaper-plugin"
      tag: "20210506120000-v4.0.0"
  kodespace:
    version: "v1.0.0"
  warpdrive:
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/warpdrive"
      tag: "20210525202306-19-main"
  podexec:
    image:
      repository: "ccr.ccs.tencentyun.com/koderover-rc/podexec"
      tag: "20210525202302-19-main"
EOF
}

run() {
  if dry_run; then
    echo "$@" 1>&2
  else
    $@
  fi
}

install_helm() {
  HELM_DIR=$KODEROVER_HOME/helm
  mkdir -p $KODEROVER_BIN
  mkdir -p $HELM_DIR

  if [ -x $KODEROVER_BIN/helm ]; then
    return
  fi

  echo "installing helm client..."
  if [ $(uname -s) == "Darwin" ]; then
    curl -fsSL -o $HELM_DIR/helm.tar.gz "https://resources.koderover.com/tools/helm-v3.0.0-darwin-amd64.tar.gz"
    tar -xzf $HELM_DIR/helm.tar.gz -C $HELM_DIR
  else
    curl -fsSL -o $HELM_DIR/helm.tar.gz "https://resources.koderover.com/tools/helm-v3.0.0-linux-amd64.tar.gz"
    tar -xzf $HELM_DIR/helm.tar.gz -C $HELM_DIR
  fi

  mv $(find ${HELM_DIR} -type f -name helm) $KODEROVER_BIN/helm
  chmod +x $KODEROVER_BIN/helm
  rm -rf $HELM_DIR
  echo "succeed to install helm client: $(helm version)"
}

ensure_ingress_controller() {
  echo "installing nginx-ingress..."
  run helm upgrade --timeout=20m  --install ${PREFIX}-nginx-ingress --namespace ${PREFIX} --set  controller.ingressClass=${PREFIX}-nginx --set controller.service.type=${NGINX_INGRESS_SERVICE_TYPE} --version 1.4.1 koderover-chart/nginx-ingress > /dev/null
  ENDPOINT_PORT=$(kubectl -n ${PREFIX} get svc/${PREFIX}-nginx-ingress-controller -o jsonpath="{.spec.ports[?(@.name=='http')].nodePort}")
  echo "succeed to install nginx ingress controller"
  MAIN_INGRESS_CLASS=${PREFIX}-nginx
  # use system
  if [ -n "${INGRESS_CLASS}" ]; then
    if [ ${INGRESS_CLASS} == "SYSTEM_DEFAULT" ]; then
      INGRESS_CLASS=""
    fi
    DEFAULT_INGRESS_CLASS=${INGRESS_CLASS:-system}
  else
    DEFAULT_INGRESS_CLASS=${PREFIX}-nginx
  fi
}

dry_run() {
  test -n "$DRY_RUN"
}

export_ip() {
  if dry_run; then
    IP="[persistence_service_ip]"
  else
    IP=$(kubectl -n ${PREFIX} get service -l "app.kubernetes.io/name=storage,app.kubernetes.io/instance=${PREFIX}-storage" -o jsonpath="{.items[0].spec.clusterIP}")
  fi
}

install_persistence_services() {
  # skip to install persistence service when mongo  existsed
  if [ -n "${MONGO_URI}" ]; then
    return 0
  fi

  args=""

  [ -n "${MONGO_URI}" ] && args="${args} --set disableMongo=true"

  echo "installing persistence services..."
  if [ -z "${STORAGE_CLASS}" ]; then
   install_database --set-string persistence.directory=/zadig --set-string persistence.storageSize=${STORAGE_SIZE} $args
  else
   install_database --set-string persistence.storageClassName=${STORAGE_CLASS} \
     --set-string persistence.storageSize=${STORAGE_SIZE} $args
  fi
  export_ip
  echo "succeed to install persistence services"
}

check_installed() {
  helm -n ${PREFIX} list -a|grep ${PREFIX}-zadig 2>&1 >/dev/null
}

install_database() {
  run helm upgrade --timeout=20m \
    --install ${PREFIX}-storage \
    --namespace ${PREFIX} $@ \
    --version 1.0.0 koderover-chart/storage --wait > /dev/null
}

RED='\033[0;31m'
NOCOLOR='\033[0m'
generate_aes_key() {
  if [ -z "$AES_KEY" ]; then
    AES_KEY=$(openssl enc -aes-128-cbc -k secret -P -md sha1 | grep key | cut -d "=" -f2-)
    printf "${RED}NO ENCRYPTION KEY PROVIDED, ZADIG HAS GENERATED AN ENCRYPTION KEY${NOCOLOR}\n" 1>&2
    printf "${RED}${AES_KEY}${NOCOLOR}\n"
    printf "${RED}THIS KEY WILL BE USED FOR POSSIBLE FUTURE REINSTALLATION, PLEASE SAVE THIS KEY CAREFULLY${NOCOLOR}\n"
  fi
}

parse_url() {
  # turn off error
  set +e
  proto="$(echo $1 | grep :// | sed -e's,^\(.*://\).*,\1,g')"
  # remove the protocol
  url="$(echo ${1/$proto/})"
  proto="$(echo $proto|sed -e 's,://,,g')"
  # extract the user (if any)
  userpass="$(echo $url | grep @ | cut -d@ -f1)"
  pass="$(echo $userpass | grep : | cut -d: -f2)"
  if [ -n "$pass" ]; then
    user="$(echo $userpass | grep : | cut -d: -f1)"
  else
    user=$userpass
  fi

  # extract the host
  host="$(echo ${url/$user:$pass@/} | cut -d/ -f1)"
  # by request - try to extract the port
  port="$(echo $host | sed -e 's,^.*:,:,g' -e 's,.*:\([0-9]*\).*,\1,g' -e 's,[^0-9],,g')"
  domain=$(echo $host|cut -d ":" -f 1)
  # extract the path (if any)
  path="$(echo $url | grep / | cut -d/ -f2-)"
  set -e

  eval "$2[0]=$proto"
  eval "$2[1]=$user"
  eval "$2[2]=$pass"
  eval "$2[3]=$domain"
  eval "$2[4]=$port"
  eval "$2[5]=$path"
  eval "$2[6]=$host"
}

install_zadig() {
  echo "installing zadig..."

  args=""

  args="${args} --set zadig-core.aslan.encryption.key=${AES_KEY}"
  DEFAULT_MONGO_URI="mongodb://${IP}:27017/zadig"
  DEFAULT_MONGO_DB="zadig"
  args="${args} --set global.mongo.connectionString=${MONGO_URI:-${DEFAULT_MONGO_URI}}  --set global.mongo.db=${MONGO_DB:-${DEFAULT_MONGO_DB}}"

  DEFAULT_S3_ENDPOINT=${IP}:9000
  args="${args} --set zadig-core.s3Storage.endpoint=${DEFAULT_S3_ENDPOINT}"
  args="${args} --set sonar.minimalInstall=true"

  [ -n "${HA}" ] && args="${args} $(ha_args)"

  HELM_DEBUG_ARGS=""
  if [ -n "${HELM_DEBUG_LEVEL}" ]; then
    HELM_DEBUG_ARGS="-v ${HELM_DEBUG_LEVEL} --debug"
  fi

  run helm upgrade $HELM_DEBUG_ARGS --timeout=20m --install ${PREFIX}-zadig \
      --namespace ${PREFIX} --version 1.0.0 koderover-chart/zadig \
      $args \
      --set global.host=${SYSTEM_ENDPOINT} \
      --set zadig-core.defaultIngressClass=$DEFAULT_INGRESS_CLASS \
      --set ingressClassName=$MAIN_INGRESS_CLASS \
      --set zadig-core.insecureRegistry=${INSECURE_REGISTRY} \
      -f ${ZADIG_VALUE_FILE} \
      > /dev/null

  if ! dry_run; then
    echo "waiting the core of zadig to start..."
    while ! test "$(kubectl -n ${PREFIX} get deploy/aslan -o jsonpath='{.status.readyReplicas}')" -gt 0 2>/dev/null; do
      sleep 5
    done
  fi
  echo "succeed to install zadig..."
}

install() {
  generate_aes_key
  ensure_ingress_controller
  ensure_system_endpoint
  echo "going to install zadig on namespace [${PREFIX}] with endpoint [${SYSTEM_ENDPOINT}]"
  install_persistence_services
  install_zadig
}

ha_args() {
  echo " --set global.replicas=2 --set zadig-core.dindReplicas=3 --set zadig-core.warpdrive.replicas=10 "
}

upgrade() {
  echo "upgrading zadig..."
  [ -n "${HA}" ] && args="${args} $(ha_args)"


  if [ -n "${MONGO_URI}" ]; then
    args="${args} --set global.mongo.connectionString=${MONGO_URI}"
    collie_args="${collie_args} --set mongoURL=${MONGO_URI}"
    plutus_args="${plutus_args} --set global.mongo.connectionString=${MONGO_URI}"
  fi

  if [ -n "${AES_KEY}" ]; then
    args="${args} --set zadig-core.aslan.encryption.key=${AES_KEY}"
  fi

  if [ -n "${UPDATE_ENDPOINT}" ]; then
    args="${args} --set global.host=${UPDATE_ENDPOINT}"
  fi

  run helm upgrade --timeout=20m ${PREFIX}-zadig \
      --namespace ${PREFIX} --version 1.0.0 koderover-chart/zadig \
      --reuse-values $args \
      -f ${ZADIG_VALUE_FILE} \
      > /dev/null

  echo "succeed to upgrade zadig to the latest version"
}

prepare() {
  if [ -n "${MONGO_URI}" ]; then
    export MONGO_URI=$(echo ${MONGO_URI}|sed 's/,/\\,/g')
  fi
}

ensure_system_endpoint() {
  if ([ -z "${IP}" ] && [ -z "${DOMAIN}" ]) || ([ -n "${IP}" ] && [ -n "${DOMAIN}" ]); then
    printf "${RED}Either IP or DOMAIN shoule be${NOCOLOR}\n"
    exit 1
  fi
  if [ -n "${IP}" ]; then
    SYSTEM_ENDPOINT=${IP}
  else
    SYSTEM_ENDPOINT=${DOMAIN}
  fi
  if [ "${NGINX_INGRESS_SERVICE_TYPE}" == "NodePort" ]; then
    SYSTEM_ENDPOINT=${SYSTEM_ENDPOINT}:${ENDPOINT_PORT}
  elif [ "${NGINX_INGRESS_SERVICE_TYPE}" == "LoadBalancer" ]; then
    printf "waiting for ingress controller to get an external ip from loadBalancer\n"
    EXTERNAL_IP=
    i=0
    while [ -z "${EXTERNAL_IP}" ] && [ $i -lt 120 ]; do
      EXTERNAL_IP=$(kubectl -n ${PREFIX} get svc/${PREFIX}-nginx-ingress-controller -o jsonpath="{.status.loadBalancer.ingress[0].ip}")
      i=$((i+1))
      sleep 1
    done
    SYSTEM_ENDPOINT=${EXTERNAL_IP}
  fi
}

validate_parameter() {
  if [ "${NGINX_INGRESS_SERVICE_TYPE}" != "NodePort" ] && [ "${NGINX_INGRESS_SERVICE_TYPE}" != "LoadBalancer" ]; then
    echo "Only NodePort and LoadBalancer type nginx ingress service is supported now."
    exit 1
  fi
}

installZadig() {
  validate_parameter
  update_values
  install_helm
  prepare
  helm repo add koderover-chart ${HELM_REPO}

  if check_installed; then
    echo "zadig has already been installed. Upgrading to lastest version..."
    upgrade
  else
    if dry_run; then
      echo -n ""
    else
      kubectl create ns $PREFIX 2>/dev/null >/dev/null && echo namespace ${PREFIX} has been created || true
    fi
    install
  fi
}

postInstallZadig() {
  logSuccess "Zadig installation complete."
  FLAG_KODEROVER=true
}
main() {
  printLogo
  logSuccess "Welcome to the Koderover Installer"
  logInfo "Checking system for requirements..."
  setTimer
  checkForRoot
  getSystemInfos
  preflightCheck
  reportTime "preflight check"
  setTimer
  mkdir -p ${KR_HOME}/mypkg
  reportTime "install preparation"
  setTimer
  installCri
  installKubernetesHost
  prepareKubernetes
  reportTime "infrastructure installation"
  setTimer
  installZadig
  postInstallZadig
  reportTime "zadig installation"
}

main
