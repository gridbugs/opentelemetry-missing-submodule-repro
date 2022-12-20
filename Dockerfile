FROM alpine

RUN apk update

RUN apk add musl-dev make gcc pkgconf opam rsync git bash neovim

RUN adduser -D user
USER user
ENV HOME=/home/user
WORKDIR $HOME

RUN opam init --disable-sandboxing --auto-setup

RUN opam install -y opam-monorepo
RUN opam repository add dune-universe git+https://github.com/dune-universe/opam-overlays.git

COPY --chown=user:user . src
WORKDIR src

RUN opam monorepo lock
RUN opam monorepo pull

# Uncomment the next line to clone opentelemetry's submodule
#RUN rm -rf duniverse/ocaml-opentelemetry && git clone https://github.com/AestheticIntegration/ocaml-opentelemetry duniverse/ocaml-opentelemetry && cd duniverse/ocaml-opentelemetry && git submodule init && git submodule update

RUN . ~/.profile && dune build
