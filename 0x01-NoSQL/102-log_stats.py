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

    # Top 10 IPs
    print("IPs:")
    pipeline = [
        {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ]
    top_ips = nginx_collection.aggregate(pipeline)
    for ip in top_ips:
        print(f"\t{ip.get('_id')}: {ip.get('count')}")


if __name__ == "__main__":
    client = MongoClient('mongodb://127.0.0.1:27017')
    nginx_collection = client.logs.nginx
    total_logs = nginx_collection.count_documents({})
    print(f"{total_logs} logs")
    print("Methods:")
    for method in ["GET", "POST", "PUT", "PATCH", "DELETE"]:
        count = nginx_collection.count_documents({"method": method})
        print(f"\tmethod {method}: {count}")
    status_check = nginx_collection.count_documents({"method": "GET", "path": "/status"})
    print(f"{status_check} status check")
    print("IPs:")
    pipeline = [
        {"$group": {"_id": "$ip", "count": {"$sum": 1}}},
        {"$sort": {"count": -1}},
        {"$limit": 10}
    ]
    for ip in nginx_collection.aggregate(pipeline):
        print(f"\t{ip.get('_id')}: {ip.get('count')}")
