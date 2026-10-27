---
description: Génère un fichier de migration SQL horodaté dans migrations/ pour
  un changement de schéma. À invoquer manuellement avec /create-migration.
disable-model-invocation: true
context: fork
background: false
argument-hint: [changement]
arguments: [changement]
allowed-tools: mcp__postgres__search_objects
---

Écris la migration SQL pour le changement de schéma suivant : **$changement**

1. Inspecte le schéma réel de la base avec l'outil `search_objects` du serveur
   MCP `postgres` (tables, colonnes, types, contraintes, index concernés par
   le changement). Ne te fie pas à des hypothèses ni à d'anciens fichiers.
2. Lis `CLAUDE.md` s'il existe, puis les routes existantes (dossier `api/` ou
   équivalent repéré dans le projet) pour connaître les champs attendus par le
   code. Signale tout écart entre le schéma réel et ces champs.
3. Écris le fichier `migrations/<AAAAMMJJHHMMSS>_<slug>.sql` (crée le dossier
   si besoin) :
   - l'horodatage vient de `date +%Y%m%d%H%M%S`, le slug est un résumé de
     `$changement` en minuscules, sans accents, séparé par des `_` ;
   - le fichier contient deux sections, avec `-- up` et `-- down` chacun seul
     sur sa ligne :

     ```sql
     -- up
     (SQL qui applique le changement)

     -- down
     (SQL qui l'annule exactement)
     ```

   - le `-- down` annule réellement le `-- up`, dans l'ordre inverse ;
   - noms d'objets et de colonnes cohérents avec le schéma réel et la langue
     du projet (français) ;
   - ne supprime ni ne réécris de données sans le signaler en commentaire.
4. Rapporte le chemin du fichier, un résumé du SQL, les écarts constatés à
   l'étape 2 et les risques (perte de données, verrous, `-- down` non
   réversible).

Règles :
- Le skill écrit seulement le SQL : n'appelle jamais `execute_sql` du serveur
  `postgres`, ni aucun autre moyen, pour appliquer ou tester la migration.
  Indique à la fin que l'application est à faire par l'utilisateur.
- Si `search_objects` est indisponible ou échoue, arrête-toi et signale-le
  plutôt que d'écrire une migration à partir de suppositions.
- N'écrase jamais une migration existante ; ne modifie aucun autre fichier.
