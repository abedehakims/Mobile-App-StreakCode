# Dockerfile untuk backend_absensi_api
# Image golang
FROM golang:1.25-alpine

# Setting work directory
WORKDIR /app

# Copy go.mod dan go.sum
COPY go.mod go.sum ./
RUN go mod download

# Melakukan copy ke semua sumber
COPY . .

# Building aplikasi
RUN go build -o main main.go

# PORT
EXPOSE 3000

# Running command
CMD ["./main"]