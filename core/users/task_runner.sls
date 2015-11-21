# pillar variables
# --
# users:
#   task_runner: task-runner-user

task_runner:
  user.present:
    - name: {{ pillar['users']['task_runner'] }}
    - createhome: False
