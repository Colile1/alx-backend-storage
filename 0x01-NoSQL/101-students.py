#!/usr/bin/env python3
"""Module that returns all students sorted by average score"""


def top_students(mongo_collection):
    """Returns all students sorted by average score
    Args:
        mongo_collection: pymongo collection object
    Returns:
        sorted students by average score
    """
    return mongo_collection.aggregate([
        {
            "$project": {
                "name": "$name",
                "averageScore": {
                    "$avg": "$topics.score"
                }
            }
        },
        {
            "$sort": {
                "averageScore": -1
            }
        }
    ])
