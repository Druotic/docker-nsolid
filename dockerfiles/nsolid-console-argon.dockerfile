# This should be built after nsolid-argon.dockerfile to ensure this image inherits
# from the right base layers. We want the console that we are shipping to run
# on the version of N|Solid that was shipped with it
FROM nodesource/nsolid:argon
MAINTAINER NodeSource <https://nodesource.com/>

# Add and unpack the console tarball
COPY ./nsolid-bundle-*/nsolid-console*.tar.gz .

RUN groupadd -r nsolid \
 && useradd -m -r -g nsolid nsolid \
 && mkdir /usr/src/app \
 && tar -xzC /usr/src/app --strip-components 1 -f nsolid-console*.tar.gz \
 && chown -R nsolid:root /usr/src/app \
 && chmod -R 0770 /usr/src/app \
 && rm nsolid-console*.tar.gz

USER nsolid

WORKDIR /usr/src/app

ENV NODE_ENV production

ENTRYPOINT ["/usr/local/bin/dumb-init", "--", "nsolid", "bin/nsolid-console"]