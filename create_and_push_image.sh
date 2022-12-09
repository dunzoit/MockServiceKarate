# create a docker image and push to GCP Container Registry
NAME=karate-mock-server
VERSION=1.0.0
OWNER=asia.gcr.io/dev-application-294611/dunzo
docker build --platform=linux/amd64 -t $NAME:$VERSION .
docker tag $NAME:$VERSION $OWNER/$NAME:$VERSION
docker push $OWNER/$NAME:$VERSION