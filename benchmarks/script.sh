#!/bin/bash

setup() {
    echo "Executing environment setup..."

    python3 setup.py
    ./deploy_dbs.sh
}

benchmark() {
    echo "Benchmarking..."

    ./benchmark.sh
}

case "$1" in
    "setup")
        setup
        ;;
    "benchmark")
        benchmark
        ;;
esac


