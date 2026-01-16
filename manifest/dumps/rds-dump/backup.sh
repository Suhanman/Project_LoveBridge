#!/bin/bash

LOG_FILE="/tmp/backup.log"
TIMESTAMP=$(date +"%Y%m%d%H%M%S")
FILENAME="rds-backup.sql"

echo "📅 $(date) -- 백업 시작" | tee -a "$LOG_FILE"

# 환경변수 확인
echo "🔍 환경변수 확인:" | tee -a "$LOG_FILE"
echo "  DB_HOST=$DB_HOST" | tee -a "$LOG_FILE"
echo "  DB_USER=$DB_USER" | tee -a "$LOG_FILE"
echo "  DB_NAME=$DB_NAME" | tee -a "$LOG_FILE"
echo "  GCP_BUCKET_NAME=$GCP_BUCKET_NAME" | tee -a "$LOG_FILE"
echo "  GOOGLE_APPLICATION_CREDENTIALS=$GOOGLE_APPLICATION_CREDENTIALS" | tee -a "$LOG_FILE"

# gcloud 인증
echo "🔐 GCP 서비스 계정 인증 중..." | tee -a "$LOG_FILE"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS" 2>&1 | tee -a "$LOG_FILE"
if [ $? -ne 0 ]; then
  echo "❌ GCP 인증 실패!" | tee -a "$LOG_FILE"
  exit 1
fi

# mysqldump
echo "📝 mysqldump 실행 중..." | tee -a "$LOG_FILE"
mysqldump -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$FILENAME" 2>>"$LOG_FILE"

if [ ! -f "$FILENAME" ]; then
  echo "❌ mysqldump 실패: $FILENAME 생성 안됨" | tee -a "$LOG_FILE"
  exit 1
fi

# gsutil 업로드
echo "☁️ gsutil 업로드 시작..." | tee -a "$LOG_FILE"
echo "🔧 명령어: gsutil cp $FILENAME gs://$GCP_BUCKET_NAME/" | tee -a "$LOG_FILE"

gsutil cp "$FILENAME" gs://"$GCP_BUCKET_NAME"/ 2>&1 | tee -a "$LOG_FILE"
STATUS=${PIPESTATUS[0]}

if [ "$STATUS" -ne 0 ]; then
  echo "❌ gsutil 업로드 실패! 상태코드: $STATUS" | tee -a "$LOG_FILE"
  exit 1
fi

# 업로드 결과 확인
echo "📦 현재 버킷 상태:" | tee -a "$LOG_FILE"
gsutil ls gs://"$GCP_BUCKET_NAME"/ | tee -a "$LOG_FILE"

echo "✅ 백업 완료: $FILENAME" | tee -a "$LOG_FILE"



