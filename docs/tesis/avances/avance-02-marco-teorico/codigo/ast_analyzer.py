"""
ast_analyzer.py — Analizador AST de Python para el plugin Moodle aiassignment.

Uso (llamado por PHP via proc_open):
    python ast_analyzer.py <base64_json>

Entrada: base64( json({"code1": "...", "code2": "..."}) )
Salida:  json({ "similarity": 87.5, "method": "ast_python", "details": {...} })

No requiere librerías externas. Solo usa el módulo ast built-in de Python.
"""

import ast
import sys
import json
import math
import base64
from collections import Counter


def extract_features(code: str) -> dict:
    """Parsea código Python con ast.parse() y extrae características del árbol."""
    try:
        tree = ast.parse(code)
    except SyntaxError as e:
        return {"error": str(e), "node_types": {}, "structure": [], "metrics": {}}

    node_types = Counter()
    structure  = []
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

        if isinstance(node, (ast.FunctionDef, ast.AsyncFunctionDef)):
            metrics["functions"] += 1
            func_names.add(node.name)
        elif isinstance(node, (ast.For, ast.While, ast.AsyncFor)):
            metrics["loops"] += 1
        elif isinstance(node, ast.If):
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

    # Detectar recursión
    for node in ast.walk(tree):
        if isinstance(node, ast.Call):
            if isinstance(node.func, ast.Name) and node.func.id in func_names:
                metrics["recursion"] += 1

    return {
        "node_types": dict(node_types),
        "structure":  structure,
        "metrics":    metrics,
        "total_nodes": sum(node_types.values()),
    }


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
    keys   = [k for k in m1 if k != "max_depth"]
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
            "details": {}
        }

    # Capa 1: similitud de tipos de nodos (coseno) — 35%
    node_sim = cosine(f1["node_types"], f2["node_types"]) * 100

    # Capa 2: similitud de secuencia estructural (Jaccard de bigramas) — 35%
    bg1 = [f"{f1['structure'][i]}|{f1['structure'][i+1]}"
           for i in range(len(f1["structure"]) - 1)]
    bg2 = [f"{f2['structure'][i]}|{f2['structure'][i+1]}"
           for i in range(len(f2["structure"]) - 1)]
    struct_sim = jaccard(bg1, bg2) * 100

    # Capa 3: similitud de métricas numéricas — 30%
    met_sim = metrics_sim(f1["metrics"], f2["metrics"]) * 100

    final = round(node_sim * 0.35 + struct_sim * 0.35 + met_sim * 0.30, 2)

    # Detección de técnicas de ofuscación
    techniques = []

    if node_sim > 70 and struct_sim > 65:
        techniques.append("Renombrado de variables/funciones")

    if abs(f1["metrics"]["loops"] - f2["metrics"]["loops"]) >= 1 and met_sim > 60:
        techniques.append("Cambio de tipo de bucle (for/while/recursión)")

    r1 = f1["metrics"]["recursion"] > 0
    r2 = f2["metrics"]["recursion"] > 0
    if r1 != r2 and met_sim > 55:
        techniques.append("Cambio recursión ↔ iteración")

    t1, t2 = f1["total_nodes"], f2["total_nodes"]
    if t1 and t2:
        size_diff = abs(t1 - t2) / max(t1, t2)
        if size_diff > 0.30 and node_sim > 60:
            techniques.append("Posible inserción de código muerto")

    return {
        "similarity": final,
        "method": "ast_python",
        "details": {
            "node_types_sim": round(node_sim,    2),
            "structure_sim":  round(struct_sim,  2),
            "metrics_sim":    round(met_sim,     2),
            "techniques":     techniques,
            "features1":      {"metrics": f1["metrics"], "total_nodes": t1},
            "features2":      {"metrics": f2["metrics"], "total_nodes": t2},
        }
    }


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "Se requiere argumento base64_json"}))
        sys.exit(1)

    try:
        raw  = base64.b64decode(sys.argv[1]).decode("utf-8")
        data = json.loads(raw)
        result = compare(data.get("code1", ""), data.get("code2", ""))
        print(json.dumps(result))
    except Exception as e:
        print(json.dumps({"error": str(e), "similarity": 0, "details": {}}))
        sys.exit(1)
