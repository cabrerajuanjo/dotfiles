alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

alias szshconfig="source ~/.zshrc"
alias sohmyzsh="source ~/.oh-my-zsh"

# Gitman
alias gitman="node /Users/juanjosecabrera/cencosud/drb-cl-gitman/dist/index.js"

# Neovim
alias nvim10="~/nvim-macos-arm64/bin/nvim"
alias nvim="~/nvim-macos/bin/nvim"
alias n.="~/nvim-macos/bin/nvim ."

# Asume role
asumerole_path="~/cencosud/spid/utils/asume-role-aws-sh/asume-role-aws.sh"
alias asume="${asumerole_path}"
alias stgasume="${asumerole_path} --profile staging"
alias prodasume="${asumerole_path} --profile production"
alias tofilestgasume="${asumerole_path} --profile staging --print | grep "." | tail -n3 | sed 's/export //' > ~/cencosud/spid/.aws_env"
function toenvstgasume() {
	output=$(${asumerole_path} --profile staging --print)
	if [ $? -ne 0 ]; then
		echo "An error has occurred."
	else
		source <(echo "$(echo $output | grep "." | tail -n3)")
	fi
}

# VPN Connection script
vpnconnect_path="~/cencosud/spid/utils/vpnconnect/vpnconnect.sh"
alias uvpnconnect="${vpnconnect_path} --update-pass"
alias tvpnconnect="${vpnconnect_path} --update-totp"
alias cvpnconnect="${vpnconnect_path} --vpn-connect"
alias dvpnconnect="${vpnconnect_path} --vpn-disconnect"
alias svpnconnect="${vpnconnect_path} --vpn-status"

# Git
alias gurl='git remote get-url origin | awk -F/ "{gsub(/^git@/, \"https://\"); gsub(/\\.git$/, \"\"); gsub(/\.com:/, \".com/\"); print}"'

# NPM
alias n="npm"
alias ni="npm install"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrtw="npm run test:watch"

# TS-Loger
export ENABLED_LOGGER=true

function togglelogger() {
	if [ "$ENABLED_LOGGER" = false ]; then
		export ENABLED_LOGGER=true
		echo "Logger enabled"
	else
		export ENABLED_LOGGER=false
		echo "Logger disabled"
	fi
}

# Kubectl
alias k="kubectl"
alias minik="kubectl --kubeconfig ~/.kube/config.minikube"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# # Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# GO
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Zig
export ZIGPATH=$HOME/.zig
export PATH=$PATH:$ZIGPATH

# Helpers
alias deleteawscredentials="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID"
alias getawssecrets="aws secretsmanager get-secret-value --profile staging-reg-ccom-spid35app-tem --region us-east-1 --secret-id reg-ccom-spid35app-secret | jq .SecretString | sed 's/\\\//g'"

# Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Deno
export DENO_INSTALL="/Users/juanjosecabrera/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
