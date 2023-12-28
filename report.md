# Report

## Benchmarking MySQL stand-alone vs. MySQL Cluster

Benchmarking is a process of comparing the performance of two systems or processes. In this case, we are comparing the performance of MySQL running as a stand-alone server versus MySQL running as a cluster. The benchmarking process involves running a series of tests on both setups and comparing the results to determine which one performs better under different workloads.

## Implementation of The Proxy Pattern

The Proxy pattern is a design pattern in software development where a class represents the functionality of another class. In our implementation, we have a Proxy server that acts as an intermediary for requests from clients seeking resources from the MySQL server. The Proxy server can handle requests, perform operations, and manage access to the MySQL server.

## Implementation of The Gatekeeper Pattern

The Gatekeeper pattern is a design pattern where a component controls access to a resource or system. In our implementation, we have a Gatekeeper server that validates and sanitizes requests before they reach the MySQL server. This adds an extra layer of security and control over the data being accessed.

## How the Implementation Works

Our implementation consists of a MySQL Cluster, a Proxy server, and a Gatekeeper server. Clients send requests to the Proxy server, which forwards them to the Gatekeeper server. The Gatekeeper server validates and sanitizes the requests before sending them to the MySQL Cluster. The MySQL Cluster processes the requests and sends the results back to the client through the Proxy and Gatekeeper servers.

## Summary of Results and Instructions to Run the Code

The results of our benchmarking tests show that MySQL Cluster performs better than MySQL stand-alone under heavy workloads. To run our code, follow the instructions in the README file. Make sure to install all necessary dependencies and set up the environment variables correctly.
