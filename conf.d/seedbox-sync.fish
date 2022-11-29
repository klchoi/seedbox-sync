function _seedbox_sync_install -e seedbox-sync_install
  abbr -aU s 'tmux new-window -n sync sync'
  abbr -aU l 'logs'

  echo '0 */12 * * * $HOME/.config/fish/conf.d/sync.sh' | crontab -u $USER -
end
