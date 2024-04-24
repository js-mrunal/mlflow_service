set -e

# Verify that all required variables are set
if [[ -z "${GCP_PROJECT}" ]]; then
    echo "Error: GCP_PROJECT not set"
    exit 1
fi

export ARTIFACT_URL="$(python3 get_authentication.py --project="${GCP_PROJECT}" --secret=mlflow_artifact_url)"
export DATABASE_URL="$(python3 get_authentication.py --project="${GCP_PROJECT}" --secret=mlflow_database_url)"

if [[ -z "${ARTIFACT_URL}" ]]; then
    echo "Error: ARTIFACT_URL not set"
    exit 1
fi

if [[ -z "${DATABASE_URL}" ]]; then
    echo "Error: DATABASE_URL not set"
    exit 1
fi

if [[ -z "${PORT}" ]]; then
    export PORT=8080
fi

if [[ -z "${HOST}" ]]; then
    export HOST=0.0.0.0
fi

export _MLFLOW_SERVER_ARTIFACT_ROOT="${ARTIFACT_URL}"
export _MLFLOW_SERVER_FILE_STORE="${DATABASE_URL}"

exec uvicorn fastapi_app:app --host "${HOST}" --port "${PORT}" --workers 1

