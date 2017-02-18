# install useful plugins for zsh.
git clone https://github.com/zsh-users/zsh-completions.git ${CUSTOM_PLUGINS}/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${CUSTOM_PLUGINS}/zsh-syntax-highlighting

sed -i -r -e 's|.*export ZSH|export ZSH|' \
          -e 's|.*ZSH_THEME.*|ZSH_THEME="agnoster"|' \
          -e 's|.*COMPLETION_WAITING_DOTS|COMPLETION_WAITING_DOTS|' \
          -e 's|.*HIST_STAMPS.*|HIST_STAMPS="yyyy-mm-dd"|' \
          -e 's|^plugins.*|plugins=(zsh-completions zsh-syntax-highlighting z httpie git autojump)|' \
          ${ZSHRC}

echo 'alias jq="jq --indent 4"' >> ${ZSHRC}
echo 'alias vi="vim"' >> ${ZSHRC}