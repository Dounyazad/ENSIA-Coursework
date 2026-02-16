from flask import Flask, request, jsonify
import requests
import uuid
from datetime import datetime

app = Flask(__name__)

PEER = "http://localhost:5001"
MODE = "AP"   # "AP" or "CP"

documents = {}  # In-memory document store


@app.route("/documents/add", methods=["GET"])
def add_document():
    title = request.args.get("title")
    content = request.args.get("content")

    if not title or not content:
        return jsonify({"error": "title and content required"}), 400

    doc_id = str(uuid.uuid4())
    document = {
        "id": doc_id,
        "title": title,
        "content": content,
        "created_at": datetime.utcnow().isoformat()
    }

    # Write locally first
    documents[doc_id] = document

    # -------- CAP LOGIC --------
    if MODE == "CP":
        # Banking DMS: must replicate or reject
        try:
            requests.get(
                f"{PEER}/documents/replicate",
                params=document,
                timeout=1
            )
        except:
            # rollback local write
            documents.pop(doc_id, None)
            return jsonify({
                "error": "Write rejected (CP mode: peer unreachable)"
            }), 503

    elif MODE == "AP":
        # Chat/Messaging: accept write even if peer is down
        try:
            requests.get(
                f"{PEER}/documents/replicate",
                params=document,
                timeout=1
            )
        except:
            # ignore replication failure
            pass
    # ---------------------------

    return jsonify({
        "status": "document added",
        "document": document
    })


@app.route("/documents/replicate", methods=["GET"])
def replicate_document():
    doc_id = request.args.get("id")
    if not doc_id:
        return jsonify({"error": "invalid replication data"}), 400

    documents[doc_id] = {
        "id": doc_id,
        "title": request.args.get("title"),
        "content": request.args.get("content"),
        "created_at": request.args.get("created_at")
    }

    return jsonify({"status": "replicated"})


@app.route("/documents/list", methods=["GET"])
def list_documents():
    return jsonify(list(documents.values()))


if __name__ == "__main__":
    app.run(port=5001, debug=True)
