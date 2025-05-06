#!/usr/bin/env python3
"""Script that provides stats about Nginx logs stored in MongoDB"""
from pymongo import MongoClient


def print_nginx_stats(nginx_collection):
    """Prints stats about Nginx logs"""
    # Total logs
    total_logs = nginx_collection.count_documents({})
    print(f"{total_logs} logs")

    # Methods stats
    print("Methods:")
    methods = ["GET", "POST", "PUT", "PATCH", "DELETE"]
    for method in methods:
        count = nginx_collection.count_documents({"method": method})
        print(f"\tmethod {method}: {count}")

    # Status check stats
    status_check = nginx_collection.count_documents(
        {"method": "GET", "path": "/status"}
    )
    print(f"{status_check} status check")


if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx_collection = client.logs.nginx
    print_nginx_stats(nginx_collection)
