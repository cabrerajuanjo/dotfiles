alias zshconfig="nvim ~/.zshrc"
alias ohmyzsh="nvim ~/.oh-my-zsh"

alias szshconfig="source ~/.zshrc"
alias sohmyzsh="source ~/.oh-my-zsh"

# Gitman
alias gitman="node ~/Documents/Cencosud/SPID/gitman/dist/index.js"

# Neovim
alias nvim="~/nvim-macos/bin/nvim"
alias nv="~/nvim-macos/bin/nvim"

# Asume role
asumerole_path="~/Documents/Cencosud/SPID/_utils/asume-role-aws-sh/asume-role-aws.sh"
alias asume="${asumerole_path}"
alias stgasume="${asumerole_path} --profile staging"
alias prodasume="${asumerole_path} --profile production"
alias tofilestgasume="${asumerole_path} --profile staging --print | grep "." | tail -n3 | sed 's/export //' > ~/Documents/Cencosud/SPID/.aws_env"
function toenvstgasume () {
  output=$(${asumerole_path} --profile staging --print)
  if [ $? -ne 0 ]
  then
    echo "An error has occurred."
  else
    source <(echo "$(echo $output | grep "." | tail -n3 )")
  fi
}

# Git
alias gurl='git remote get-url origin | awk -F/ "{gsub(/^git@/, \"https://\"); gsub(/\\.git$/, \"\"); gsub(/\.com:/, \".com/\"); print}"'

# NPM
alias n="npm"
alias ni="npm install"
alias nrd="npm run dev"
alias nrb="npm run build"
alias nrt="npm run test"
alias nrtw="npm run test:watch"

# Kubectl
alias k="kubectl"
alias minik="kubectl --kubeconfig ~/.kube/config.minikube"
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# # Nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Helpers
alias deleteawscredentials="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID"

# Dotfiles
alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
