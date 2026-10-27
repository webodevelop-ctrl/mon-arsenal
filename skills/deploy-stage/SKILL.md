---
description: Pipeline de déploiement vers l'environnement de staging —
  vérifications, artefacts de build, publication, déploiement. Dry-run
  automatique si la cible staging n'est pas configurée.
disable-model-invocation: true
allowed-tools: Bash(git *)
---

Déroule la pipeline de déploiement staging dans l'ordre, en t'arrêtant
à la première vérification qui échoue, avec ce qu'il faut corriger.

0. **Cible** — si `deploy.staging.json` est absent de la racine du
   projet, passe en DRY-RUN : joue la phase 1 normalement, puis
   rapporte ce que les phases 2 à 4 feraient, sans rien écrire ni
   pousser.
1. **Vérifications** — arbre de travail git propre (`git status`),
   remote `origin` configuré (`git remote -v`), puis invoque le skill
   audit-security et attends son rapport : aucune alerte confirmée non résolue ;
   tout candidat non qualifié ou erreur de scan bloque la suite.
2. **Artefacts** — assure un Dockerfile et une CI adaptés au projet,
   générés ou complétés si nécessaire. La CI installe depuis le lockfile,
   exécute lint et tests existants avant le build ; si les tests exigent une
   base, elle prépare une base éphémère et ses données, jamais celle du poste.
   Prépare le schéma uniquement à partir des blocs up relus des migrations,
   sans exécuter down ; documente la commande réservée à la base CI vierge.
   Relis les artefacts, lance localement lint, tests et build, attends la fin
   du formatage puis committe. N'invente pas une suite verte sans exécution.
3. **Publication** — pousse la branche courante sur `origin`, puis attends
   le résultat de la CI pour ce commit via GitHub ; si tu ne peux pas lire
   ce run, donne le commit et le lien de l'onglet Actions, et attends que
   l'utilisateur confirme le résultat. Stoppe en cas d'échec ou de statut
   inconnu : ne déploie pas en te basant sur un ancien run.
4. **Déploiement** — une fois les contrôles verts, déploie sur la cible
   déclarée et vérifie le démarrage. Si un conteneur de ce nom existe,
   signale-le et demande la décision de remplacement ; ne supprime pas
   la base ni ses données. La CI ne déploie pas à elle seule sur le poste.

Termine par un récapitulatif : chaque phase, faite / serait faite /
bloquée.
