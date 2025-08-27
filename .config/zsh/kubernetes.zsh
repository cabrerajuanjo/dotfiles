inv-ede-kube () {
  NAME_SPACE=edenor-investment
  PROFILE="Developers-ReadOnlyAndEKS-065526474534"
  NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  NEED_LOGIN=true

  # if [ -d "$HOME/.aws/sso" ] && [ "$(ls -A $HOME/.aws/sso/cache)" ]; then
  #   echo "file present"
  #   for file in ~/.aws/sso/cache/*.json; do
  #     # Check if the cached token file belongs to the profile
  #     START_URL=$(aws configure get sso_start_url --profile "$PROFILE")
  #     FILE_URL=$(jq -r '.startUrl // empty' "$file" 2>/dev/null)
  #     EXPIRATION=$(jq -r '.expiresAt // empty' "$file" 2>/dev/null)
  #
  #     if [[ "$FILE_URL" == "$START_URL" ]] && [[ "$EXPIRATION" > "$NOW" ]]; then
  #       NEED_LOGIN=false
  #       break
  #     fi
  #   done
  # fi

  if $NEED_LOGIN; then
    echo "SSO token expired or not found, logging in..."
    aws sso login --profile "$PROFILE" || return 1
  else
    echo "SSO token is still valid for profile $PROFILE."
  fi

  kubectl config set-context --current --namespace="$NAME_SPACE"
}
