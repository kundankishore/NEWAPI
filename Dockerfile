#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5000

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
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "NEWAPI.dll"]