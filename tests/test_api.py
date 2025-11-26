import sys
from pathlib import Path

from fastapi.testclient import TestClient

# Ensure project root (where main.py lives) is on PYTHONPATH
ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.append(str(ROOT_DIR))

from main import app  # noqa: E402


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
