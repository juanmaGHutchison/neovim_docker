ARG BASE_IMAGE="debian"
FROM BASE_IMAGE

# TODO engage with utils/scripts
ARG BUILDER_IMAGE=nvim-builder:latest

ARG USR_LOCAL="/usr/local"

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
	apt install -y --no-install-recommends ripgrep nodejs

COPY --from=${BUILDER_IMAGE} ${USR_LOCAL}/bin/nvim ${USR_LOCAL}/bin/nvim
COPY --from=${BUILDER_IMAGE} ${USR_LOCAL}/share/nvim ${USR_LOCAL}/share/nvim
COPY --from=${BUILDER_IMAGE} /root/.config/nvim $HOME/.config/nvim
COPY --from=${BUILDER_IMAGE} /root/.local $HOME/.local

CMD ["nvim"]

