import os
import sys

# Make sure Python can find main.py in the parent folder
sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

def test_create_item():
    response = client.post("/items", json={"name": "book", "price": 12.5})
    assert response.status_code == 200
    body = response.json()
    assert body["status"] == "success"
    assert body["item"]["name"] == "book"
    assert body["item"]["price"] == 12.5

def test_list_items():
    response = client.get("/items")
    assert response.status_code == 200
    data = response.json()
    assert isinstance(data, list)
    assert len(data) >= 1
