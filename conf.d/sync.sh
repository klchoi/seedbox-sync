#!/usr/bin/env sh

RCLONE_BIN=$HOME/.local/bin/rclone
RCLONE_CONF=$HOME/.rclone.conf
RCLONE_LOG=$HOME/gsync.log
RCLONE_LOCAL_DIR=$HOME/drive/
RCLONE_REMOTE_DIR=gdrive:/
RCLONE_LOCK=$HOME/gsync.lock

if [ -f $RCLONE_LOCK ]; then
    echo SYNCING...
    exit 1
fi

touch $RCLONE_LOCK
trap "rm $RCLONE_LOCK" EXIT

$RCLONE_BIN \
    --config $RCLONE_CONF \
    --log-level INFO \
    move \
    --delete-empty-src-dirs \
    --drive-stop-on-upload-limit \
    --no-traverse \
    --order-by name \
    --stats=10s \
    --stats-file-name-length 0 \
    --exclude='**/.**' \
    --exclude='/.**' \
    --exclude='**.mp4' \
    --exclude='**.wmv' \
    --exclude='**.mov' \
    --exclude='**.m4v' \
    --exclude='**.avi' \
    --exclude='**.mkv' \
    --exclude='**.flv' \
    --exclude='**.f4v' \
    --transfers=8 \
    $RCLONE_LOCAL_DIR \
    $RCLONE_REMOTE_DIR \
    2>&1 | tee $RCLONE_LOG && \
$RCLONE_BIN \
    --config $RCLONE_CONF \
    --log-level INFO \
    move \
    --delete-empty-src-dirs \
    --drive-stop-on-upload-limit \
    --no-traverse \
    --order-by name \
    --stats=10s \
    --stats-file-name-length 0 \
    --exclude='**/.**' \
    --exclude='/.**' \
    --transfers=1 \
    $RCLONE_LOCAL_DIR \
    $RCLONE_REMOTE_DIR \
    2>&1 | tee $RCLONE_LOG
