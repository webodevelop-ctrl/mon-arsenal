---
description: Audit de sécurité du projet courant — secrets en dur dans
  les sources et hygiène des fichiers d'environnement. À utiliser quand
  on demande un audit, un scan ou une vérification de sécurité.
context: fork
background: false
---

Réalise un audit de sécurité du projet courant, depuis sa racine :

1. Exécute `bash ${CLAUDE_SKILL_DIR}/scripts/check-secrets.sh`
2. Exécute `bash ${CLAUDE_SKILL_DIR}/scripts/check-env.sh`
3. Qualifie les [A_VERIFIER] : nom de champ, donnée factice ou secret suspect.
   Ne recopie pas de valeur sensible. Rapporte les [ALERTE] confirmées,
   leur gravité, la correction recommandée, les faux positifs écartés et
   le périmètre inspecté. Un résultat sans motif n'est pas une certification.

Rapport uniquement : n'applique aucune correction toi-même.
