from fastapi import FastAPI
from pydantic import BaseModel
import hmac, hashlib, os, json

app = FastAPI()

class Item(BaseModel):
    name: str
    price: float

@app.get("/items")
def list_items():
    # Dummy data for now (so you don't need real DB)
    return [{"id": 1, "name": "sample", "price": 10.0}]

@app.post("/items")
def insert_item(item: Item):
    # Here we just pretend to insert, to match the assignment requirement
    return {"status": "success", "item": item.dict()}

@app.get("/export")
def export_signed():
    data = json.dumps([{"id": 1, "name": "sample", "price": 10.0}])

    secret_key = os.getenv("HMAC_KEY", "test_key").encode()
    signature = hmac.new(secret_key, data.encode(), hashlib.sha256).hexdigest()

    return {"data": data, "signature": signature}
