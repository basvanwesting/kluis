FROM elixir:1.10 as build

#ARG APP_NAME=kluis
#ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ARG PHOENIX_SUBDIR=.

# install build dependencies
RUN apt-get update && apt-get install -y \
      build-essential \
      nodejs \
      npm

#RUN npm update -g
RUN npm install npm@latest -g

WORKDIR /opt/app

RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

COPY assets/package.json assets/package-lock.json ${PHOENIX_SUBDIR}/assets/
RUN npm --prefix ${PHOENIX_SUBDIR}/assets install

COPY priv priv
COPY assets assets
RUN npm run --prefix ${PHOENIX_SUBDIR}/assets deploy
RUN mix phx.digest

COPY lib lib
RUN mix do compile, release
    #&& mv _build/prod/rel/${APP_NAME} /opt/release \
    #&& mv /opt/release/bin/${APP_NAME} /opt/release/bin/phx_server

FROM debian:buster AS release

RUN apt-get update && apt-get install -y \
      openssl \
    && rm -rf /var/lib/apt/lists/*

#ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN groupadd -g 1500 app \
  && useradd --create-home -u 1500 -g app app

RUN mkdir -p /opt/app \
 && chown -R app:app /opt/app

WORKDIR /opt/app
USER app:app

#COPY --from=build /opt/release .
COPY --from=build --chown=app:app /opt/app/_build/prod/rel/kluis ./

ENV HOME=/opt/app

CMD ["/opt/app/bin/kluis", "start"]
