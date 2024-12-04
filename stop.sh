#!/bin/bash

echo "🧨 \033[1;31mCLEAN UP\033[0m\n"

echo "Stopping 'cassandra' container..."
docker kill cassandra

echo "Removing docker network 'cassandra'..."
docker network rm cassandra

echo "\033[1;32m\nDOCKER STOPPED\033[0m \n⏭️  Ready for next run..."