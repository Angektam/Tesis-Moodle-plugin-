"""
Python AST Comparator Service
Usa el módulo ast built-in de Python para parsear y comparar código fuente.

Expone un servidor HTTP en el puerto 5001.
El plugin PHP lo llama via: POST http://localhost:5001/compare

Entrada JSON:
  { "code1": "...", "code2": "..." }

Salida JSON:
  {
    "similarity": 87.5,
    "method": "ast",
    "details": {
      "node_types_sim": 92.0,
      "structure_sim": 85.0,
      "metrics_sim": 80.0,
      "techniques": ["Renombrado de variables", "..."]
    }
  }
"""

import ast
import json
import math
import sys
from http.server import HTTPServer, BaseHTTPRequestHandler
from collections import Counter


# ── Extracción de características del AST ────────────────────────────────────

def extract_features(code: str) -> dict:
    """Parsea código Python y extrae características estructurales del AST."""
    try:
        tree = ast.parse(code)
    except SyntaxError as e:
        return {"error": str(e), "node_types": {}, "structure": [], "metrics": {}}

    node_types = Counter()
    structure  = []          # secuencia de tipos de nodos (orden importa)
    metrics    = {
        "functions":    0,
        "loops":        0,
        "conditionals": 0,
        "returns":      0,
        "assignments":  0,
        "imports":      0,
        "recursion":    0,
        "max_depth":    0,
    }
    func_names = set()

    def walk(node, depth=0):
        metrics["max_depth"] = max(metrics["max_depth"], depth)
        t = type(node).__name__
        node_types[t] += 1
        structure.append(t)

        # Métricas específicas
        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            metrics["functions"] += 1
            func_names.add(node.name)
        elif isinstance(node, (ast.For, ast.While, ast.AsyncFor)):
            metrics["loops"] += 1
        elif isinstance(node, (ast.If,)):
            metrics["conditionals"] += 1
        elif isinstance(node, ast.Return):
            metrics["returns"] += 1
        elif isinstance(node, (ast.Assign, ast.AugAssign, ast.AnnAssign)):
            metrics["assignments"] += 1
        elif isinstance(node, (ast.Import, ast.ImportFrom)):
            metrics["imports"] += 1

        for child in ast.iter_child_nodes(node):
            walk(child, depth + 1)

    walk(tree)

    # Detectar recursión: llamadas a funciones definidas en el mismo código
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            if isinstance(node.func, ast.Name) and node.func.id in func_names:
                metrics["recursion"] += 1

    return {
        "node_types": dict(node_types),
        "structure":  structure,
        "metrics":    metrics,
    }


# ── Similitud entre dos conjuntos de características ─────────────────────────

def jaccard(a: list, b: list) -> float:
    if not a and not b:
        return 1.0
    ca, cb = Counter(a), Counter(b)
    inter = sum((ca & cb).values())
    union = sum((ca | cb).values())
    return inter / union if union else 0.0


def cosine(v1: dict, v2: dict) -> float:
    keys = set(v1) | set(v2)
    dot  = sum(v1.get(k, 0) * v2.get(k, 0) for k in keys)
    n1   = math.sqrt(sum(x**2 for x in v1.values()))
    n2   = math.sqrt(sum(x**2 for x in v2.values()))
    return dot / (n1 * n2) if n1 and n2 else 0.0


def metrics_sim(m1: dict, m2: dict) -> float:
    keys = [k for k in m1 if k != "max_depth"]
    scores = []
    for k in keys:
        v1, v2 = m1.get(k, 0), m2.get(k, 0)
        mx = max(v1, v2)
        scores.append(1 - abs(v1 - v2) / mx if mx else 1.0)
    return sum(scores) / len(scores) if scores else 1.0


def compare(code1: str, code2: str) -> dict:
    f1 = extract_features(code1)
    f2 = extract_features(code2)

    if "error" in f1 or "error" in f2:
        return {
            "similarity": 0,
            "method": "ast_error",
            "error": f1.get("error") or f2.get("error"),
        }

    # 1. Similitud de tipos de nodos (coseno) — 35%
    node_sim  = cosine(f1["node_types"], f2["node_types"]) * 100

    # 2. Similitud de secuencia estructural (Jaccard de bigramas) — 35%
    bg1 = [f"{f1['structure'][i]}|{f1['structure'][i+1]}"
           for i in range(len(f1["structure"]) - 1)]
    bg2 = [f"{f2['structure'][i]}|{f2['structure'][i+1]}"
           for i in range(len(f2["structure"]) - 1)]
    struct_sim = jaccard(bg1, bg2) * 100

    # 3. Similitud de métricas numéricas — 30%
    met_sim = metrics_sim(f1["metrics"], f2["metrics"]) * 100

    final = round(node_sim * 0.35 + struct_sim * 0.35 + met_sim * 0.30, 2)

    # ── Detección de técnicas de ofuscación ──────────────────────────────
    techniques = []

    # Renombrado: estructura muy similar pero nombres distintos
    # (node_types similar, pero los Nombre/identificadores difieren)
    if node_sim > 70 and struct_sim > 65:
        techniques.append("Renombrado de variables/funciones")

    # Cambio de bucle: mismas métricas generales pero loops difieren
    if (abs(f1["metrics"]["loops"] - f2["metrics"]["loops"]) >= 1
            and met_sim > 60):
        techniques.append("Cambio de tipo de bucle (for/while/recursión)")

    # Recursión vs iteración
    r1 = f1["metrics"]["recursion"] > 0
    r2 = f2["metrics"]["recursion"] > 0
    if r1 != r2 and met_sim > 55:
        techniques.append("Cambio recursión ↔ iteración")

    # Código muerto: diferencia de nodos > 30% con alta similitud
    total1 = sum(f1["node_types"].values())
    total2 = sum(f2["node_types"].values())
    if total1 and total2:
        size_diff = abs(total1 - total2) / max(total1, total2)
        if size_diff > 0.30 and node_sim > 60:
            techniques.append("Posible inserción de código muerto")

    return {
        "similarity": final,
        "method": "ast_python",
        "details": {
            "node_types_sim":  round(node_sim,   2),
            "structure_sim":   round(struct_sim, 2),
            "metrics_sim":     round(met_sim,    2),
            "techniques":      techniques,
            "features1":       {"metrics": f1["metrics"], "total_nodes": total1},
            "features2":       {"metrics": f2["metrics"], "total_nodes": total2},
        }
    }


# ── Servidor HTTP ─────────────────────────────────────────────────────────────

class ASTHandler(BaseHTTPRequestHandler):

    def log_message(self, format, *args):
        pass  # silenciar logs por defecto

    def do_POST(self):
        if self.path != "/compare":
            self._send(404, {"error": "Not found"})
            return

        length = int(self.headers.get("Content-Length", 0))
        body   = self.rfile.read(length)

        try:
            data   = json.loads(body)
            code1  = data.get("code1", "")
            code2  = data.get("code2", "")
            result = compare(code1, code2)
            self._send(200, result)
        except Exception as e:
            self._send(500, {"error": str(e)})

    def do_GET(self):
        if self.path == "/health":
            self._send(200, {"status": "ok", "service": "python-ast", "python": sys.version})
        else:
            self._send(404, {"error": "Not found"})

    def _send(self, code: int, data: dict):
        body = json.dumps(data).encode()
        self.send_response(code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", len(body))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    port   = int(sys.argv[1]) if len(sys.argv) > 1 else 5001
    server = HTTPServer(("localhost", port), ASTHandler)
    print(f"[Python AST Service] Escuchando en http://localhost:{port}")
    print(f"[Python AST Service] POST /compare  |  GET /health")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\n[Python AST Service] Detenido.")
