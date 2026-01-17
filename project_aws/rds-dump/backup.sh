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

# 환경변수 sanitize (줄바꿈 제거)
DB_NAME=$(echo "$DB_NAME" | tr -d '\r\n')

# gcloud 인증
echo "🔐 GCP 서비스 계정 인증 중..." | tee -a "$LOG_FILE"
gcloud auth activate-service-account --key-file="$GOOGLE_APPLICATION_CREDENTIALS" 2>&1 | tee -a "$LOG_FILE"
if [ $? -ne 0 ]; then
  echo "❌ GCP 인증 실패!" | tee -a "$LOG_FILE"
  exit 1
fi

# mysqldump 실행
echo "📝 mysqldump 실행 중..." | tee -a "$LOG_FILE"
mysqldump --single-transaction --routines --triggers --column-statistics=0 \
  -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$FILENAME"


# 덤프 파일 확인
if [ ! -f "$FILENAME" ]; then
  echo "❌ mysqldump 실패: $FILENAME 생성 안됨" | tee -a "$LOG_FILE"
  exit 1
fi

FILESIZE=$(stat -c%s "$FILENAME")
if [ "$FILESIZE" -lt 3000 ]; then
  echo "⚠️ mysqldump 결과 비정상적으로 작음 ($FILESIZE bytes)" | tee -a "$LOG_FILE"
  head -n 20 "$FILENAME" | tee -a "$LOG_FILE"
fi

# gsutil 업로드
echo "☁️ gsutil 업로드 시작..." | tee -a "$LOG_FILE"
echo "🔧 명령어: gsutil cp $FILENAME gs://$GCP_BUCKET_NAME/" | tee -a "$LOG_FILE"

gsutil -h "Cache-Control:no-cache" cp "$FILENAME" gs://"$GCP_BUCKET_NAME"/ 2>&1 | tee -a "$LOG_FILE"
STATUS=${PIPESTATUS[0]}

if [ "$STATUS" -ne 0 ]; then
  echo "❌ gsutil 업로드 실패! 상태코드: $STATUS" | tee -a "$LOG_FILE"
  exit 1
fi

# 업로드 결과 확인
echo "📦 현재 버킷 상태:" | tee -a "$LOG_FILE"
gsutil ls -l gs://"$GCP_BUCKET_NAME"/ | tee -a "$LOG_FILE"

echo "✅ 백업 완료: $FILENAME ($FILESIZE bytes)" | tee -a "$LOG_FILE"




