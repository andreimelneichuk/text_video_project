#!/usr/bin/env bash

# wait-for-it.sh: wait for a TCP port to become available

set -e

HOST="$1"
PORT="$2"
shift 2
CMD="$@"

echo "Waiting for $HOST:$PORT to be available..."

# Проверка, что и HOST, и PORT заданы
if [ -z "$HOST" ] || [ -z "$PORT" ]; then
  echo "Error: HOST and PORT must be provided"
  exit 1
fi

# Ожидание доступности порта
while ! nc -z "$HOST" "$PORT"; do
  echo "Port $PORT on host $HOST is not available yet..."
  sleep 1
done

echo "$HOST:$PORT is available. Running command: $CMD"

# Выполнение команды и захват кода завершения
exec $CMD || {
  echo "Error: command $CMD failed with exit code $?"
  exit 1
}