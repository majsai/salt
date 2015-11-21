# pillar variables:
# --
# vimrc_repo: git@github.com:akarasz/vimrc.git

vim-nox:
  pkg:
    - installed

{% if pillar['vimrc_repo'] is defined %}
vim_config_from_git:
  git.latest:
    - name: {{ pillar['vimrc_repo'] }}
    - target: /etc/vim
{% endif %}
