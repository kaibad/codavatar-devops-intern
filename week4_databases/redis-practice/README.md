# FastAPI + Redis + MongoDB Caching Project

This project demonstrates a **real-world backend architecture** using:

- FastAPI (API layer)
- MongoDB (persistent database)
- Redis (cache layer)

It implements a **cache-aside pattern** where Redis is checked first before querying MongoDB.

---

#  Architecture Flow

```
Client → FastAPI → Redis → MongoDB → Redis → Response
```


### Flow explanation:

1. Client requests user data
2. FastAPI checks Redis (cache)
3. If found -> return instantly
4. If not found -> query MongoDB
5. Store result in Redis for future requests
6. Return response

---

#  Tech Stack

- Python 3.10+
- FastAPI
- Uvicorn
- Redis
- MongoDB
- Docker / Docker Compose

---

#  Run Redis + MongoDB (Docker)

Create `docker-compose.yml`:

```yaml
services:
  redis:
    image: redis:7-alpine
    container_name: redis_server
    ports:
      - "6379:6379"

  mongodb:
    image: mongo:7
    container_name: mongo_server
    ports:
      - "27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: admin
      MONGO_INITDB_ROOT_PASSWORD: password

```

## Install dependencies

```bash
python -m venv venv
source venv/bin/activate

pip install fastapi uvicorn pymongo redis

uvicorn app:app --reload

```

```
curl "http://127.0.0.1:8000/users/1"

```

Response (MongoDB first time):

```json
{
  "source": "mongodb",
  "data": {
    "name": "Alice",
    "age": 25
  }
}
```

Response (Redis cached):

```

{
  "source": "redis",
  "data": {
    "name": "Alice",
    "age": 25
  }
}

```
Open redis commands

```bash
docker exec -it redis_server redis-cli

# Useful commands:

KEYS *
GET user:1
TTL user:1
FLUSHALL


```






