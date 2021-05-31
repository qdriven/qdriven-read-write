#!/bin/bash

# ENV NAMESPACE is mandatory
[[ -z "${NAMESPACE}" ]] && { echo "ENV NAMESPACE is missing."; exit 1; }

PREFIX=${NAMESPACE}
KODEROVER_BIN=$HOME/.koderover/bin
export PATH=$KODEROVER_BIN:$PATH

echo "Start to delete Zadig in namespace [${NAMESPACE}]."

echo "Removing zadig..."
helm uninstall -n "$PREFIX" "${PREFIX}"-zadig
echo "Removing ingress controller..."
helm uninstall -n "$PREFIX" "${PREFIX}"-nginx-ingress
echo "Removing storage..."
helm uninstall -n "$PREFIX" "${PREFIX}"-storage

echo "Removing cluster resources..."
kubectl delete clusterroles "${PREFIX}"-nginx-ingress >/dev/null 2>&1
kubectl delete clusterrolebindings "${PREFIX}"-nginx-ingress >/dev/null 2>&1
kubectl delete clusterroles admin-role-"${PREFIX}"-zadig >/dev/null 2>&1
kubectl delete clusterrolebindings admin-bind-"${PREFIX}"-zadig >/dev/null 2>&1

echo "Removing namespace ${NAMESPACE}..."
kubectl delete ns "${PREFIX}"

echo "Successfully deleted Zadig."
