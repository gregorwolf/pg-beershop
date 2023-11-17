echo "VCAP_SERVICES":
echo $VCAP_SERVICES
cds env requires.db --for production
npm start