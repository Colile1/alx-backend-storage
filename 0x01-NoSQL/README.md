# 0x01-NoSQL
## MongoDB Tasks

This project contains tasks for learning and practicing NoSQL databases, specifically MongoDB.

### Requirements
* MongoDB (version 4.2)
* Python 3.7
* PyMongo (version 3.10)
* Ubuntu 18.04 LTS

### Tasks

#### 0. List all databases
* File: `0-list_databases`
* Description: Script that lists all databases in MongoDB.

#### 1. Create a database
* File: `1-use_or_create_database`
* Description: Script that creates or uses the database `my_db`.

#### 2. Insert document
* File: `2-insert`
* Description: Script that inserts a document in the collection `school` with attribute name="ALX".

#### 3. All documents
* File: `3-all`
* Description: Script that lists all documents in the collection `school`.

#### 4. All matches
* File: `4-match`
* Description: Script that lists all documents with name="ALX" in the collection `school`.

#### 5. Count
* File: `5-count`
* Description: Script that displays the number of documents in the collection `school`.

#### 6. Update
* File: `6-update`
* Description: Script that adds a new attribute to documents in the collection `school`.

#### 7. Delete by match
* File: `7-delete`
* Description: Script that deletes all documents with name="ALX School" in the collection `school`.

#### 8. List all documents in Python
* File: `8-all.py`
* Description: Python function that lists all documents in a collection.

#### 9. Insert a document in Python
* File: `9-insert_school.py`
* Description: Python function that inserts a new document in a collection based on kwargs.

#### 10. Change school topics
* File: `10-update_topics.py`
* Description: Python function that changes all topics of a school document based on the name.

#### 11. Where can I learn Python?
* File: `11-schools_by_topic.py`
* Description: Python function that returns the list of schools having a specific topic.

#### 12. Log stats
* File: `12-log_stats.py`
* Description: Python script that provides stats about Nginx logs stored in MongoDB.

### Advanced Tasks

#### 13. Regex filter
* File: `100-find`
* Description: Script that lists all documents with name starting by "ALX" in the collection school.

#### 14. Top students
* File: `101-students.py`
* Description: Python function that returns all students sorted by average score.

#### 15. Log stats - new version
* File: `102-log_stats.py`
* Description: Improved version of `12-log_stats.py` that adds the top 10 most present IPs in the Nginx logs.
