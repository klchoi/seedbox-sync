function sync -a cmd
  switch $cmd
    case stop
      pkill -P (cat ~/gsync.lock)
      pkill --pidfile ~/gsync.lock
    case copy
      rclone \
        --log-level INFO \
        $cmd \
        --drive-stop-on-upload-limit \
        --no-traverse \
        --order-by name \
        --stats=10s \
        --stats-file-name-length 0 \
        --exclude='**/.**' \
        --exclude='/.**' \
        --transfers=1 \
        ~/drive/ \
        gdrive:/ \
        2>&1 | tee ~/gsync.log
    case move \*
      ~/.config/fish/conf.d/sync.sh &
  end
end
