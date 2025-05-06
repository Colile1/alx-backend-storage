#!/usr/bin/env python3
"""Script that provides stats about Nginx logs stored in MongoDB"""
from pymongo import MongoClient

if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    collection = client.logs.nginx
    n_logs = collection.count_documents({})
    print(f"{n_logs} logs")
    print("Methods:")
    for method in ["GET", "POST", "PUT", "PATCH", "DELETE"]:
        count = collection.count_documents({"method": method})
        print(f"\tmethod {method}: {count}")
    status_count = collection.count_documents({"method": "GET", "path": "/status"})
    print(f"{status_count} status check")
