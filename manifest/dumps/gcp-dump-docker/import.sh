#!/bin/bash
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS"

gcloud sql import sql "$INSTANCE_NAME" \
  "gs://$GCP_BUCKET_NAME/rds-backup.sql" \
  --database="$DB_NAME" \
  --project="$PROJECT_ID"
