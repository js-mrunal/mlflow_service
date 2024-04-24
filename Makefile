include .env

# Create an environment file .env with following variables:
# IMAGE_NAME: Name of the container image
# GCP_PROJECT: Project Name on GCP
# AR_REGISTRY_NAME: Name of the artifact registry/directory on GCP
# AR_REGION: Default region of the GCP Project
# VERSION: version of container image/ tag -> usually set as latest
# SERVICE_ACCOUNT: Email-id of the service account
# SQL_INSTANCE: Instance name of GCP SQL

clean-env:
	pipenv --rm

format:
	pipenv run isort .
	pipenv run black .

init:
	pipenv install --dev

build:
	docker build -t "${IMAGE_NAME}" .

build-m1:
	docker build --platform linux/amd64 -t "${IMAGE_NAME}" .

gcp-push: build-m1
	docker tag "${IMAGE_NAME}" "${AR_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REGISTRY_NAME}/${IMAGE_NAME}:${VERSION}"
	docker push "${AR_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REGISTRY_NAME}/${IMAGE_NAME}:${VERSION}"

gcp-run: gcp-push
	gcloud run deploy --image="${AR_REGION}-docker.pkg.dev/${GCP_PROJECT}/${AR_REGISTRY_NAME}/${IMAGE_NAME}:${VERSION}" \
	--allow-unauthenticated --region="${AR_REGION}" --memory="4Gi" --service-account="${SERVICE_ACCOUNT}" \
	--add-cloudsql-instances="${SQL_INSTANCE}" --project="${GCP_PROJECT}"

gcp-deploy:
	gcloud beta builds submit --project=gcp-ml-dive \
	--config=./cloudbuild.yaml  \
	--substitutions=_SERVICE_ACCOUNT="${SERVICE_ACCOUNT}",_SQL_INSTANCE="${SQL_INSTANCE}" .