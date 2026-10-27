---
description: Génère un endpoint d'API (routes, validation, test) pour une ressource.
  À utiliser quand on demande de créer une API ou un endpoint
  (« crée une API pour X », « il me faudrait des routes pour… »).
argument-hint: [ressource]
arguments: [ressource]
---

Crée l'endpoint d'API pour la ressource **$ressource** dans ce projet :

1. Lis `CLAUDE.md`, `package.json`, la configuration TypeScript (`tsconfig.json`)
   si présente, et repère le framework HTTP, le runner de test, la couche
   d'accès aux données et le schéma/les migrations déjà en place.
   Respecte la langue du projet (identifiants, messages, docs) et ses conventions
   de nommage, de dossiers et de modules (CommonJS ou ESM).
2. Génère, dans l'organisation existante du projet (sinon `api/`) :
   - les routes CRUD de `$ressource` (liste, lecture, création, mise à jour,
     suppression) avec les codes HTTP appropriés (201, 204, 400, 404) ;
   - la validation des entrées (corps, paramètres, identifiants), avec la
     bibliothèque déjà utilisée, sinon des gardes simples sans nouvelle
     dépendance ; les erreurs de validation renvoient 400 avec un message clair ;
   - l'accès aux données isolé dans un module dédié (dépôt/repository), injecté
     dans les routes pour pouvoir être remplacé par un double dans les tests.
   Utilise `.ts` si TypeScript est configuré, sinon `.js`.
3. Ajoute le fichier de test adjacent avec le runner du projet
   (sinon `node:test`) :
   - validation : entrées valides et invalides, cas limites ;
   - accès aux données : teste routes et logique avec des doubles (faux dépôt
     en mémoire) tant que la base n'est pas migrée.
4. Exécute les tests si le runner est disponible, et rapporte le résultat réel.

Règles :
- Ne modifie pas le schéma et n'applique aucune migration sans demande explicite ;
  si la table de `$ressource` manque, propose le schéma/la migration à part.
- Aucun test d'intégration contre la vraie base tant que le schéma n'est pas
  appliqué : ne prétends jamais qu'une intégration réussit sans l'avoir exécutée.
  Signale ce qui reste à valider (schéma appliqué, test d'intégration).
- Si une dépendance (framework HTTP, runner, validation) est absente, fournis
  un exemple non exécuté et liste les dépendances manquantes.
- Nom de fichier et de ressource cohérents avec le projet (pluriel/singulier,
  casse) ; pas de secrets en dur, config via l'environnement.
- Si l'endpoint de `$ressource` existe déjà, arrête-toi et signale-le
  au lieu d'écraser.
