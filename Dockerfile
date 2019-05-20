# docker build -t scaffolding:builder --target=builder .
from bitwalker/alpine-elixir-phoenix:1.8.1 as builder

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app
ENV MIX_ENV=prod

# docker build -t scaffolding:deps --target=deps .
FROM builder as deps

COPY mix.* /app/
RUN mix do deps.get --only prod, deps.compile

# docker build -t scaffolding:client-builder --target=client-builder .
FROM node:10.15.3-alpine as client-builder
WORKDIR /app
COPY assets/package.json /app/
COPY assets/yarn.lock /app/
COPY --from=deps /app/deps/phoenix /deps/phoenix
COPY --from=deps /app/deps/phoenix_html /deps/phoenix_html
RUN yarn install
COPY assets/ /app/
RUN yarn build

# docker build -t scaffolding:releaser --target=releaser .
FROM deps as releaser
COPY . /app/
COPY --from=client-builder /app/build /app/priv/static

RUN mix do phx.digest, release --env=prod --no-tar

# docker build -t scaffolding:runner --target=runner .
FROM elixir:1.8.1-alpine as runner
RUN addgroup -g 1000 scaffolding && \
adduser -D -h /app \
-G scaffolding \
-u 1000 \
scaffolding
RUN apk add -U bash
USER scaffolding
WORKDIR /app
COPY --from=releaser /app/_build/prod/rel/scaffolding /app
CMD trap 'exit' INT; /app/bin/scaffolding foreground
