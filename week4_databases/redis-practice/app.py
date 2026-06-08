from fastapi import FastAPI
from pymongo import MongoClient
import redis
import json

app = FastAPI()

# -------------------
# Redis (cache)
# -------------------
cache = redis.Redis(host="localhost", port=6379, decode_responses=True)

# -------------------
# MongoDB (database)
# -------------------
mongo_client = MongoClient("mongodb://admin:password@localhost:27017")
db = mongo_client["test_db"]
users_collection = db["users"]


@app.post("/users/{user_id}")
def create_user(user_id: str, name: str, age: int):
    user = {
        "_id": user_id,
        "name": name,
        "age": age
    }

    # save in MongoDB
    users_collection.insert_one(user)

    # store in Redis cache
    cache.set(
     f"user:{user_id}",
     json.dumps(user),
     ex=60
    )

    return {"message": "User created", "user": user}


@app.get("/users/{user_id}")
def get_user(user_id: str):
    cache_key = f"user:{user_id}"

    # 1. check Redis
    cached = cache.get(cache_key)
    if cached:
        return {
            "source": "redis",
            "data": json.loads(cached)
        }

    # 2. fallback MongoDB
    user = users_collection.find_one({"_id": user_id}, {"_id": 0})

    if user:
        cache.set(cache_key, json.dumps(user), ex=60)

    return {
        "source": "mongodb",
        "data": user
    }

