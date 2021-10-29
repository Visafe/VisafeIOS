#!/bin/sh

git clone https://bit.Visafe.com/scm/Visafe-filters/dns-resolvers.git

cp dns-resolvers/output/providers.json ../VisafeExtension/VisafeApp/providers.json
cp dns-resolvers/output/providers_i18n.json ../VisafeExtension/VisafeApp/providers_i18n.json

rm -rf dns-resolvers