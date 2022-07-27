DIR="${HOME}/.zplug"
PLUGINS=(\
  "zsh-users/zsh-syntax-highlighting"\
  "zsh-users/zsh-completions"\
  "zsh-users/zsh-autosuggestions"\
)

if [[ ! -d $DIR ]];then
  git clone https://github.com/zplug/zplug "${DIR}" 
fi
source "${DIR}/init.zsh"

for _plugin in "${PLUGINS[@]}"
do
  zplug "${_plugin}"
done

if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi
zplug load

