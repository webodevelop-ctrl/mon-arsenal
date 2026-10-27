---
description: Génère un composant React avec son fichier de test.
  À utiliser quand on demande de créer un nouveau composant UI
  (« crée un composant X », « il me faudrait un composant qui… »).
argument-hint: [NomDuComposant]
arguments: [nom]
---

Crée le composant React **$nom** dans ce projet :

1. Lis les conventions, package.json et la configuration TypeScript si présente.
2. Génère `components/$nom.tsx` en TypeScript, sinon `components/$nom.jsx`.
   Composant de présentation, props explicites, export par défaut,
   sans fetch ni accès à la base ; les pages parentes portent les appels API.
3. Ajoute le test de rendu adjacent avec le framework de test du projet.
   Si React ou le runner est absent, fournis un exemple non exécuté et
   signale les dépendances manquantes ; ne prétends pas avoir validé le rendu.

Règles :
- PascalCase pour le composant et ses fichiers.
- Si le composant existe déjà en `.jsx` ou `.tsx`, arrête-toi et signale-le
  au lieu d'écraser.
