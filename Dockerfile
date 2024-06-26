# Usa una imagen oficial de Go como imagen base para la construcción
FROM golang:latest AS builder

# Configura las variables de entorno necesarias
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Establece el directorio de trabajo en el contenedor
WORKDIR /app

# Copia los archivos go.mod y go.sum (si existe) primero para aprovechar el caché de Docker
COPY go.mod ./

# Descarga las dependencias
RUN go mod download

# Copia el resto de los archivos de la aplicación
COPY . .

# Compila la aplicación
RUN go build -o /go/bin/app

# Usa una imagen minimalista de scratch para ejecutar la aplicación
FROM scratch

# Copia el binario compilado desde la imagen builder
COPY --from=builder /go/bin/app /app

# Establece el punto de entrada de la aplicación
ENTRYPOINT ["/app"]
