ARG DOTNET_ARCH=

FROM node:lts AS build-node
WORKDIR /app
COPY ASF-ui .
RUN echo "node: $(node --version)" && \
    echo "npm: $(npm --version)" && \
    npm ci && \
    npm run deploy

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-dotnet
ARG ASF_ARCH=x64
ARG STEAM_TOKEN_DUMPER_TOKEN
ENV CONFIGURATION Release
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
ENV DOTNET_NOLOGO 1
ENV NET_CORE_VERSION netcoreapp3.1
ENV STEAM_TOKEN_DUMPER_NAME ArchiSteamFarm.OfficialPlugins.SteamTokenDumper
WORKDIR /app
COPY --from=build-node /app/dist ASF-ui/dist
COPY ArchiSteamFarm ArchiSteamFarm
COPY ArchiSteamFarm.OfficialPlugins.SteamTokenDumper ArchiSteamFarm.OfficialPlugins.SteamTokenDumper
COPY resources resources
COPY Directory.Build.props Directory.Build.props
RUN dotnet --info && \
    # TODO: Remove workaround for https://github.com/microsoft/msbuild/issues/3897 when it's no longer needed
    if [ -f "ArchiSteamFarm/Localization/Strings.zh-CN.resx" ]; then ln -s "Strings.zh-CN.resx" "ArchiSteamFarm/Localization/Strings.zh-Hans.resx"; fi && \
    if [ -f "ArchiSteamFarm/Localization/Strings.zh-TW.resx" ]; then ln -s "Strings.zh-TW.resx" "ArchiSteamFarm/Localization/Strings.zh-Hant.resx"; fi && \
    if [ -n "${STEAM_TOKEN_DUMPER_TOKEN-}" ] && [ -f "${STEAM_TOKEN_DUMPER_NAME}/SharedInfo.cs" ]; then sed -i "s/STEAM_TOKEN_DUMPER_TOKEN/${STEAM_TOKEN_DUMPER_TOKEN}/g" "${STEAM_TOKEN_DUMPER_NAME}/SharedInfo.cs"; fi && \
    dotnet publish "${STEAM_TOKEN_DUMPER_NAME}" -c "$CONFIGURATION" -f "$NET_CORE_VERSION" -o "out/${STEAM_TOKEN_DUMPER_NAME}/${NET_CORE_VERSION}" -p:SelfContained=false -p:UseAppHost=false -r "linux-${ASF_ARCH}" --nologo && \
    dotnet clean ArchiSteamFarm -c "$CONFIGURATION" -f "$NET_CORE_VERSION" -p:SelfContained=false -p:UseAppHost=false -r "linux-${ASF_ARCH}" --nologo && \
    dotnet publish ArchiSteamFarm -c "$CONFIGURATION" -f "$NET_CORE_VERSION" -o "out/result" -p:ASFVariant=docker -p:SelfContained=false -p:UseAppHost=false -r "linux-${ASF_ARCH}" --nologo && \
    if [ -d "ArchiSteamFarm/overlay/generic" ]; then cp "ArchiSteamFarm/overlay/generic/"* "out/result"; fi && \
    if [ -f "out/${STEAM_TOKEN_DUMPER_NAME}/${NET_CORE_VERSION}/${STEAM_TOKEN_DUMPER_NAME}.dll" ]; then mkdir -p "out/result/plugins/${STEAM_TOKEN_DUMPER_NAME}"; cp "out/${STEAM_TOKEN_DUMPER_NAME}/${NET_CORE_VERSION}/${STEAM_TOKEN_DUMPER_NAME}.dll" "out/result/plugins/${STEAM_TOKEN_DUMPER_NAME}"; fi

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim${DOTNET_ARCH} AS runtime
ENV ASPNETCORE_URLS=
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1
ENV DOTNET_NOLOGO 1
LABEL maintainer="JustArchi <JustArchi@JustArchi.net>"
EXPOSE 1242
WORKDIR /app
COPY --from=build-dotnet /app/out/result .
VOLUME ["/app/config", "/app/logs"]
HEALTHCHECK CMD ["pidof", "-q", "dotnet"]
ENTRYPOINT ["./ArchiSteamFarm.sh", "--no-restart", "--process-required", "--system-required"]
