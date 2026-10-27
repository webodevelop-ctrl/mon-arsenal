#!/bin/bash
# Cherche des motifs de secrets en dur dans les sources du projet.
echo "== check-secrets : secrets en dur =="
if grep -rn -i -E "(api[_-]?key|secret|password|token)[[:space:]]*[:=]" \
    --include="*.js" --include="*.jsx" --include="*.ts" --include="*.tsx" \
    --include="*.json" --include="*.sql" --exclude="package-lock.json" \
    --exclude-dir=node_modules --exclude-dir=.next --exclude-dir=.git \
    --exclude-dir=.claude --exclude-dir=mon-arsenal .; then
  echo "[A_VERIFIER] Candidats ci-dessus : distinguer secrets réels, noms de champs et données de test."
else
  scan_status=$?
  if [ "$scan_status" -eq 1 ]; then
    echo "[OK] Aucun motif détecté dans les extensions inspectées ; ce n’est pas une preuve d’absence de secrets."
  else
    echo "[ERREUR] Scan incomplet : ne pas conclure à une absence de motifs." >&2
    exit "$scan_status"
  fi
fi
