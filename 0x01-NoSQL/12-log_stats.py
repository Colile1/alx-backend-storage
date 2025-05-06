#!/usr/bin/env python3
"""
12-log_stats.py

Provides statistics on Nginx logs stored in MongoDB:
- total number of logs
- number of requests per HTTP method
- number of GET /status requests
"""

from pymongo import MongoClient


def log_stats():
    """
    Connects to the "logs" database, "nginx" collection, and prints:
      - total number of logs
      - counts per HTTP method GET, POST, PUT, PATCH, DELETE
      - count of GET /status checks
    """
    client = MongoClient('mongodb://127.0.0.1:27017')
    collection = client.logs.nginx

    total = collection.count_documents({})
    print(f"{total} logs")

    print("Methods:")
    for method in ["GET", "POST", "PUT", "PATCH", "DELETE"]:
        count = collection.count_documents({"method": method})
        print(f"    method {method}: {count}")

    status = collection.count_documents({"method": "GET", "path": "/status"})
    print(f"{status} status check")


if __name__ == "__main__":
    log_stats()
