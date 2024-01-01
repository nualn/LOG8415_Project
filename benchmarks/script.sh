#!/bin/bash

setup_env() {
    echo "Executing environment setup..."

    python3 setup.py
    ./deploy_dbs.sh
}

run_benchmark() {
    echo "Benchmarking..."
    args="$(< ./data/bench_args.txt)"
    ./run_benchmarks.sh $args
}

teardown_env() {
    echo "Tearing down environment..."

    python3 teardown.py
}

case "$1" in
    "setup")
        setup_env
        ;;
    "benchmark")
        run_benchmark
        ;;
    "teardown")
        teardown_env
        ;;
esac


