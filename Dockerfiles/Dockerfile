FROM opensuse/tumbleweed:latest

ARG UID=1000
ARG GID=1000

#These (esp the LANG variable) make sure tmux outputs UTF-8. Needed for special chars
ENV GDM_LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV XDG_CACHE_HOME=/home/app/.local/cache
ENV TASKRC=~/.config/task/.taskrc
ENV TASKDATA=~/.local/share/task/
ENV ZETTEL_BASE=/home/app/Documents/zettelkasten
ENV ORG_TEMPLATES_DIR=/home/app/.config/nvim/org-templates
ENV EDITOR=vim

RUN zypper -n refresh
RUN zypper -n install sudo tmux vim git lazygit \
                      python3-pip wl-clipboard \
                      openssh unzip stow wget \
                      task timewarrior cmake nim \
                      npm neovim lua53-luarocks \
                      ripgrep fzf fd mercurial \
                      dos2unix awk gcc-c++ libpcre1
RUN chmod 777 /tmp \
    && git clone https://github.com/jschlatow/taskopen.git /tmp/taskopen \
    && cd /tmp/taskopen && make PREFIX=/usr && make PREFIX=/usr install
COPY requirements.txt /tmp
RUN sed -i 's,root:x:0:0:root:/root:/bin/ash,root:x:0:0:root:/root:/bin/bash,g' /etc/passwd \
    && groupadd -g ${GID} app \
    && useradd -u ${UID} -g ${GID} app \
    && mkdir -p /run/tmux/1000 && chown app:app /run/tmux/1000 && chmod 700 /run/tmux/1000 \
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app \
    && touch /run/sshd.pid && chmod 777 /run/sshd.pid \
    && ssh-keygen -A && echo -e 'PasswordAuthentication yes\nPermitEmptyPasswords yes' >> /etc/ssh/sshd_config \
    && ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && python3 -m venv /home/app/.venvs/app && source /home/app/.venvs/app/bin/activate \
    && pip3 install --upgrade pip \
    && pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt \
    && pip3 install pynvim pylint tzdata vit \
    && npm i -g neovim \
    && mkdir -p /home/app/.local \
    && git clone https://github.com/tmux-plugins/tpm /home/app/.bin/tpm \
    && git clone https://github.com/jasonmb626/dotfiles-dev.git /home/app/.dotfiles \
    && curl -L -o /tmp/twtui.rpm  https://github.com/kdheepak/taskwarrior-tui/releases/download/v0.26.3/taskwarrior-tui-0.26.3-1.x86_64.rpm \
    && zypper -n install --allow-unsigned-rpm /tmp/twtui.rpm && rm /tmp/twtui.rpm \
    && mkdir -p /home/app/.config && touch /home/app/.bash_profile  && cd /home/app/.config && touch .want_timew_hook \
    && mkdir -p /home/app/Documents/zettelkasten && chown -R app:app /home/app && rm -fr /tmp/* \
    && cat >/home/app/.bash_profile <<EOF
if [ -n "\$BASH_VERSION" -a -n "\$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "\$HOME/.bashrc" ]; then
    . "\$HOME/.bashrc"
    fi
fi
export GDM_LANG=en_US.UTF-8
export LANG=en_US.UTF-8
export XDG_CACHE_HOME=/home/app/.local/cache
export TASKRC=~/.config/task/.taskrc
export TASKDATA=~/.local/share/task/
export ZETTEL_BASE=/home/app/Documents/zettelkasten
export ORG_TEMPLATES_DIR=/home/app/.config/nvim/org-templates
export EDITOR=vim
EOF

RUN echo "app:" | chpasswd -e && touch /home/app/.config/.want_docker_ssh

WORKDIR /home/app/Documents/zettelkasten
USER app:app
RUN cd ~/.dotfiles && stow bash && stow tmux && stow timew && stow taskw && stow vit && stow taskopen \
    && dos2unix /home/app/.bash_profile && mkdir -p /home/app/.config/nvim
#RUN touch /home/app/.config/.want_alt_tmux_prefix
CMD ["bash"]

#Consider limiting IP ssh access
#https://serverfault.com/questions/680780/block-all-but-a-few-ips-with-firewalld
#firewall-cmd --zone=internal --add-service=ssh
#firewall-cmd --zone=internal --add-source=192.168.56.105/32
#firewall-cmd --zone=internal --add-source=192.168.56.120/32
#firewall-cmd --zone=public --remove-service=ssh
