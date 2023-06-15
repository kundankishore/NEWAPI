FROM mcr.microsoft.com/dotnet/sdk:7.0 AS builder
WORKDIR /app

# caches restore result by copying csproj file separately
WORKDIR /src
COPY ["NEWAPI/NEWAPI.csproj", "NEWAPI/"]
RUN dotnet restore "NEWAPI/NEWAPI.csproj"

COPY . .
WORKDIR "/src/NEWAPI"
RUN dotnet build "NEWAPI.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "NEWAPI.csproj" -c Release -o /app/publish /p:UseAppHost=false

# Stage 2
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app
COPY --from=builder /app .

ENV PORT 5000
EXPOSE 5000

ENTRYPOINT dotnet $(cat /app/__assemblyname).dll --urls "http://*:5000"
