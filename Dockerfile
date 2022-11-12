ARG baseImage="unityci/editor:ubuntu-2021.3.1f1-linux-il2cpp-1.0.1"
FROM $baseImage
ARG hubVersion="3.0.0"

# Hub dependencies
RUN apt-get -q update \
 && apt-get -q install -y --no-install-recommends --allow-downgrades zenity libgbm1 gnupg \
 && apt-get clean
 
 # Install Unity Hub
# https://docs.unity3d.com/hub/manual/InstallHub.html#install-hub-linux
RUN sh -c 'echo "deb https://hub.unity3d.com/linux/repos/deb stable main" > /etc/apt/sources.list.d/unityhub.list' \
 && wget -qO - https://hub.unity3d.com/linux/keys/public | apt-key add - \
 && apt-get -q update \
 && apt-get -q install -y "unityhub=$hubVersion" \
 && apt-get clean
 
 # Alias to "unity-hub" with default params
RUN echo '#!/bin/bash\nxvfb-run -ae /dev/stdout /opt/unityhub/unityhub-bin --no-sandbox --headless "$@"' > /usr/bin/unity-hub \
 && chmod +x /usr/bin/unity-hub
