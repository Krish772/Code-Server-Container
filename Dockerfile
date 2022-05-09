# Start from the code-server Debian base image
FROM codercom/code-server:4.4.0

USER coder
# Apply VS Code settings
COPY deploy-container/settings.json .local/share/code-server/User/settings.json

# Use bash shell
ENV SHELL=/bin/bash

# Install unzip + rclone (support for remote filesystem)
RUN sudo apt-get update && sudo apt-get install unzip -y
RUN curl https://rclone.org/install.sh | sudo bash

# Copy rclone tasks to /tmp, to potentially be used
COPY deploy-container/rclone-tasks.json /tmp/rclone-tasks.json

# Fix permissions for code-server
RUN sudo chown -R coder:coder /home/coder/.local

# You can add custom software and dependencies for your environment below
# -----------

# Install a VS Code extension:
COPY extensions.txt /tmp/extensions.txt
RUN code-server --install-extension tuto193.monokai-vibrant --install-extension esbenp.prettier-vscode --install-extension dbaeumer.vscode-eslint --install-extension vscode-icons-team.vscode-icons --install-extension oderwat.indent-rainbow --install-extension ritwickdey.LiveServer --install-extension jaspernorth.vscode-pigments
# Install apt packages:
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - \
&& sudo sh -c 'echo "deb https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
&& sudo apt-get update

RUN sudo apt install -y gcc g++ google-chrome-stable

# Copy files: 
# COPY deploy-container/myTool /home/coder/myTool

# -----------

# Port
ENV PORT=8080

# Use our custom entrypoint script first
COPY deploy-container/entrypoint.sh /usr/bin/deploy-container-entrypoint.sh
ENTRYPOINT ["/usr/bin/deploy-container-entrypoint.sh"]
