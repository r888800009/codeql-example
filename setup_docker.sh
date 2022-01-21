#!/bin/bash
docker build . -t codeql-docker

echo "Run the following command to run the container:"
echo "  docker run --rm -it codeql-docker"
echo "  mkdir -p codeql-db "
echo '  docker run --rm -it -v $(pwd)/codeql-db:/codeql-db codeql-docker'
