#-------------------------------------------------------------------------------
# Copyright (C) 2018 Atos and others
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Eclipse Public License 2.0
# which accompanies this distribution, and is available at
# https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
# 
# Contributors:
#     Atos - initial API and implementation
#-------------------------------------------------------------------------------
#ARG BASEIMAGE_BUILD=resin/raspberry-pi3-node:7.8.0-20170426
#ARG BASEIMAGE_BUILD=resin/intel-nuc-node:7.8.0-20170506
#ARG BASEIMAGE_DEPLOY=resin/raspberry-pi3-node:7.8.0-slim-20170426
#ARG BASEIMAGE_DEPLOY=resin/intel-nuc-node:7.8.0-slim-20170506

ARG BASEIMAGE_BUILD
ARG BASEIMAGE_DEPLOY

FROM $BASEIMAGE_DEPLOY

RUN apt-get update
#
# Only for rpi: vcgencmd support
# https://forums.resin.io/t/cant-run-vcgencmd/39
#
RUN apt-get install -y libraspberrypi-bin || echo "libraspberrypi-bin not available"

RUN npm install -g node-red

WORKDIR /opt/lib

ARG TESSERACT=node-red-contrib-tesseract
ARG DEPLOYER=node-red-contrib-agile-deployer

COPY $TESSERACT $TESSERACT
COPY $DEPLOYER $DEPLOYER

WORKDIR /usr/local/lib/node_modules/node-red/node_modules

RUN npm install /opt/lib/$TESSERACT
RUN npm install /opt/lib/$DEPLOYER
RUN npm install node-red-contrib-cpu


#FROM $BASEIMAGE_DEPLOY
#COPY --from=0 /opt/secure-nodered /opt/secure-nodered
#WORKDIR /opt/secure-nodered

EXPOSE 1880

CMD DEBUG=cloud-link node-red
