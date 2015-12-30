# pillar variables
# --
# dst_server:
#   server_token: aaa
#   
#   network:
#     server_name: Server 
#     server_description: DST Server
#     server_password: 
#     game_mode: survival
#     server_intention: cooperative

{% if grains['cpuarch'] == 'x86_64' %}

dpkg-add-architecture:
  cmd.run:
    - name: dpkg --add-architecture i386; apt-get update
    - unless: dpkg --print-foreign-architectures | grep i386

    - require_in:
      - steamcmd.packages

{% endif %}

steam:
  user.present:
    - createhome: True
    - home: /home/steam

  group:
    - present

/home/steam/steamcmd:
  file.directory:
    - user: steam
    - group: steam
    
    - makedirs: True

    - require:
      - user: steam

/home/steam/.klei/DoNotStarveTogether:
  file.directory:
    - user: steam
    - group: steam

    - makedirs: True
 
    - require:
      - user: steam

{% if pillar['dst'] is defined and pillar['dst']['server_key'] is defined %}
/home/steam/.klei/DoNotStarveTogether/server_token.txt:
  file.managed:
    - user: steam
    - group: steam
    - mode: 644

    - contents_pillar: dst_server:server_token

    - require:
      - file: /home/steam/.klei/DoNotStarveTogether
{% endif %}

/home/steam/.klei/DoNotStarveTogether/settings.ini:
  file.managed:
    - user: steam
    - group: steam
    - mode: 644

    - source: salt://dst_server/settings.ini
    - template: jinja

    - require:
      - user: steam
      - file: /home/steam/.klei/DoNotStarveTogether

steamcmd.packages:
  pkg.installed:
    - pkgs:
      - lib32gcc1
      - lib32stdc++6
      - libgcc1
      - libcurl4-gnutls-dev:i386

curl:
  pkg:
    - installed

steamcmd.download:
  cmd.run:
    - name: curl -L http://media.steampowered.com/installer/steamcmd_linux.tar.gz -o /home/steam/steamcmd/steamcmd_linux.tar.gz
    - unless: ls -la /home/steam/steamcmd/steamcmd_linux.tar.gz

    - user: steam
    - group: steam

    - require:
      - file: /home/steam/steamcmd
      - pkg: curl
      - user: steam
      - group: steam

    - require_in:
      - steamcmd.install

steamcmd.install:
  cmd.run:
    - name: tar -xvzf steamcmd_linux.tar.gz
    - unless: ls -la /home/steam/steamcmd/steamcmd.sh

    - user: steam
    - group: steam
    - cwd: /home/steam/steamcmd

expect:
  pkg:
    - installed

dst.install:
  cmd.script:
    - source: salt://dst_server/steamcmd-install-dst.exp
    - unless: ls -la /home/steam/steamapps/DST/bin/dontstarve_dedicated_server_nullrenderer
   
    - user: steam
    - group: steam
    - cwd: /home/steam/steamcmd

    - require:
      - pkg: expect
      - cmd: steamcmd.install

screen:
  pkg:
    - installed

/usr/local/bin/start-dst-server.sh:
  file.managed:
    - user: root
    - group: root
    - mode: 755
    
    - source: salt://dst_server/start-dst-server.sh

    - require:
      - cmd: dst.install
      - pkg: screen
