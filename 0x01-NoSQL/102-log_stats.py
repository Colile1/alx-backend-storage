#!/usr/bin/env python3
"""
Script that provides stats about Nginx logs stored in MongoDB
"""

from pymongo import MongoClient


def log_stats(collection):
    """
    Display stats about Nginx logs stored in MongoDB:
    - total log count
    - counts per HTTP method
    - count of GET /status checks
    - top 10 IP addresses by request count
    """
    total = collection.count_documents({})
    print(f"{total} logs")

    print("Methods:")
    for method in ["GET", "POST", "PUT", "PATCH", "DELETE"]:
        count = collection.count_documents({"method": method})
        print(f"    method {method}: {count}")

    status_count = collection.count_documents({"method": "GET", "path": "/status"})
    print(f"{status_count} status check")

    print("IPs:")
    pipeline = [
        {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ]
    for doc in collection.aggregate(pipeline):
        print(f"    {doc['_id']}: {doc['count']}")


if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx = client.logs.nginx
    log_stats(nginx)
