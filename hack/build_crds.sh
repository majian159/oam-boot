#!/bin/bash

currentDir=$(pwd)
crdsDir=${currentDir}/charts/oam-boot-catalog/crds

if [[ -d catalog ]]; then
    cd catalog
    git pull
else
    git clone https://github.com/oam-dev/catalog.git --depth=1
fi

cd $currentDir
mkdir -p $crdsDir
rm -f $crdsDir/*.yaml

cd catalog
for x in traits/*/; do
    crdDir="${x}config/crd"
    [[ -d "$crdDir" ]] || break
    name=${x%?}
    name=${name##*/}
    kubectl kustomize $crdDir >$crdsDir/${name}.yaml
done
