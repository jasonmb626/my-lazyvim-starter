FROM alpine:edge

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

COPY requirements.txt /tmp
RUN apk add -U py3-pip npm bash \
         git \ 
         lua-dev luarocks stylua \
         lazygit openssh \
         tmux neovim neovim-doc \
         procps \
         tmux \
         ripgrep \
         alpine-sdk \
         tree-sitter tree-sitter-cli \
         wl-clipboard cmake \
         stow sudo task \
         unzip gzip fd mercurial wget \
    && chmod 777 /tmp \
    && curl -o /tmp/timew.tgz -L -O https://github.com/GothenburgBitFactory/timewarrior/releases/download/v1.7.1/timew-1.7.1.tar.gz \
    && cd /tmp && tar xzf timew.tgz && cd /tmp/timew-1.7.1 && cmake -DCMAKE_BUILD_TYPE=Release . && make && make install \
    && sed -i 's,root:x:0:0:root:/root:/bin/ash,root:x:0:0:root:/root:/bin/bash,g' /etc/passwd \
    && addgroup -g ${GID} app \
    && adduser -D -u ${UID} -G app -s /bin/bash app \
    && echo "app:" | chpasswd -e \
    && mkdir -p /etc/sudoers.d && echo 'app ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers.d/app \
    && touch /run/sshd.pid && chmod 777 /run/sshd.pid \
    && ssh-keygen -A && echo -e 'PasswordAuthentication yes\nPermitEmptyPasswords yes' >> /etc/ssh/sshd_config \
    && ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime \
    && python3 -m venv /home/app/.venvs/app && source /home/app/.venvs/app/bin/activate \
    && pip3 install --upgrade pip \
    && pip3 install -r /tmp/requirements.txt && rm /tmp/requirements.txt \
    && pip3 install pynvim pylint tzdata vit \
    && mkdir -p /home/app/.local \
    && git clone https://github.com/tmux-plugins/tpm /home/app/.bin/tpm \
    && git clone https://github.com/jasonmb626/dotfiles-dev.git /home/app/.dotfiles \
    && curl -s https://ohmyposh.dev/install.sh | bash -s -- -d /home/app/.bin \
    && git clone https://github.com/dracula/oh-my-posh.git /tmp/oh-my-posh-dracula
RUN mkdir -p /home/app/.themes && cp /tmp/oh-my-posh-dracula/dracula.omp.json /home/app/.themes && touch /home/app/.bash_profile  \
    && mkdir -p /home/app/.config && touch /home/app/.config/.want_alt_tmux_prefix && touch /home/app/.config/.want_docker_ssh && touch /home/app/.config/.want_timew_hook \
    && chown -R app:app /home/app && rm -fr /tmp/* \
    && cat >/home/app/.bash_profile <<EOF
if [ -n "\$BASH_VERSION" -a -n "\$PS1" ]; then
    # include .bashrc if it exists
    if [ -f "\$HOME/.bashrc" ]; then
    . "\$HOME/.bashrc"
    fi
fi
EOF

WORKDIR /home/app/Documents/zettelkasten
USER app:app
RUN cd ~/.dotfiles && stow bash && stow tmux && stow timew && stow taskw && stow vit \
    && mkdir -p /home/app/Documents/zettelkasten
CMD ["bash"]
