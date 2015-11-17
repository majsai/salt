task_runner:
  user.present:
    - name: {{ pillar['users']['task_runner'] }}
    - createhome: False
