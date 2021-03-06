# pillar variables
# --
# minecraft:
#   version: 1.8.8
#   online_mode: true
#   enable_command_bock: false

{% set version = pillar['minecraft']['version'] %}

curl:
  pkg:
    - installed

screen:
  pkg:
    - installed

openjdk-8-jre-headless:
  pkg:
    - installed

/srv/minecraft:
  file:
    - directory

/srv/minecraft/eula.txt:
  file.managed:
    - user: root
    - group: root
    - mode: 644

    - source: salt://minecraft_server/eula.txt

    - require:
      - file: /srv/minecraft

/srv/minecraft/server.properties:
  file.managed:
    - user: root
    - group: root
    - mode: 644

    - source: salt://minecraft_server/server.properties
    - template: jinja
    - context:
      online_mode: {{ pillar['minecraft']['online_mode'] }}
      enable_command_block: {{ pillar['minecraft']['enable_command_block'] }}

    - require:
      - file: /srv/minecraft

download-minecraft-server:
  cmd.run:
    - name: curl -L https://s3.amazonaws.com/Minecraft.Download/versions/{{ version }}/minecraft_server.{{ version }}.jar -o /srv/minecraft/server.jar
    - creates: /srv/minecraft/server.jar

    - require:
      - pkg: curl
      - file: /srv/minecraft

/usr/local/bin/start-minecraft-server.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755

    - source: salt://minecraft_server/start-minecraft-server.sh

    - require:
      - cmd: download-minecraft-server
      - pkg: openjdk-8-jre-headless
      - pkg: screen
