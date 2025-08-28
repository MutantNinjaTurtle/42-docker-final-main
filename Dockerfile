# Сборка приложения
FROM golang:1.22-alpine AS builder
# Установка рабочей директории
WORKDIR /app
# Копирование файлов зависимостей
COPY go.mod go.sum ./
# Скачивание зависимостей
RUN go mod download
# Копирование исходного кода
COPY . .
# Сборка приложения
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o tracker

# Запуск приложения
FROM alpine:latest
# Установка рабочей директории
WORKDIR /app
# Копирование исполняемого файла из этапа сборки
COPY --from=builder /app/tracker .
# Копирование базы данных
COPY --from=builder /app/tracker.db .
RUN apk add --no-cache sqlite
CMD ["./tracker"]