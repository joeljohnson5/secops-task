from fastapi import FastAPI
from pydantic import BaseModel
import hmac
import hashlib
import json
import os


app = FastAPI()


class Item(BaseModel):
    name: str
    price: float


@app.get("/items")
def list_items():
    """Return a dummy list of items."""
    return [{"id": 1, "name": "sample", "price": 10.0}]


@app.post("/items")
def insert_item(item: Item):
    """Pretend to insert an item and return it."""
    return {"status": "success", "item": item.dict()}


@app.get("/export")
def export_signed():
    """Return signed export payload using a simple HMAC."""
    data = json.dumps([{"id": 1, "name": "sample", "price": 10.0}])

    secret_key = os.getenv("HMAC_KEY", "test_key").encode()
    signature = hmac.new(secret_key, data.encode(), hashlib.sha256).hexdigest()

    return {"data": data, "signature": signature}
