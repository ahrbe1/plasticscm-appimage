# This is free and unencumbered software released into the public domain.
# 
# Anyone is free to copy, modify, publish, use, compile, sell, or
# distribute this software, either in source code form or as a compiled
# binary, for any purpose, commercial or non-commercial, and by any
# means.
# 
# In jurisdictions that recognize copyright laws, the author or authors
# of this software dedicate any and all copyright interest in the
# software to the public domain. We make this dedication for the benefit
# of the public at large and to the detriment of our heirs and
# successors. We intend this dedication to be an overt act of
# relinquishment in perpetuity of all present and future rights to this
# software under copyright law.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
# IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
# OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
# OTHER DEALINGS IN THE SOFTWARE.
# 
# For more information, please refer to <http://unlicense.org/>

FROM ubuntu:18.04
WORKDIR /root

RUN apt-get update && apt-get install -y apt-transport-https apt-utils wget gpg
RUN sh -c "echo 'deb https://www.plasticscm.com/plasticrepo/stable/ubuntu/ ./' | tee /etc/apt/sources.list.d/plasticscm-stable.list"
RUN sh -c "wget https://www.plasticscm.com/plasticrepo/stable/ubuntu/Release.key -O - | apt-key add -"
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get install -y imagemagick file desktop-file-utils binutils
RUN wget https://raw.githubusercontent.com/AppImage/pkg2appimage/master/pkg2appimage && chmod +x pkg2appimage
COPY recipes /root/recipes
COPY AppRun /root/
ENV PATH=$PATH:/usr/lib/x86_64-linux-gnu/glib-2.0/
ENV ARCH=x86_64
RUN sh -c "./pkg2appimage recipes/client.yml 2>&1 | tee build.log"

