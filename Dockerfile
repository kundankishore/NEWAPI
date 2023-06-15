#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["NEWAPI/NEWAPI.csproj", "NEWAPI/"]
RUN dotnet restore "NEWAPI/NEWAPI.csproj"
COPY . .
WORKDIR "/src/NEWAPI"
RUN dotnet build "NEWAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NEWAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
ENV PORT 5000
EXPOSE 5000

ENTRYPOINT dotnet $(cat /app/__assemblyname).dll --urls "http://*:5000"