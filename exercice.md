### Création d'un page builder dynamique

## Il y a 2 apis

- /api/components: liste des composants à instancier dans la page
- /api/users: liste des utilisateurs

## A implémenter
1 - Créer les composants suivants: form, dropdown, search, table

1a - Il y a une particularité avec le dropdown, la liste deroulante à afficher se trouve dans un objet data qu'il faut recuperer lorsque la page est créée dynamiquement.

1b - le composant search devra afficher en résultat le nom + prenom

2 - Le composant form doit englober les composants suivants: dropdown, search. Cependant le bouton de soumission fait parti du composant form

3 - A partir de l'api /api/components, créer une page dynamiquement qui permet d'afficher les 4 components suivants: form, dropdown, search, table

4 - Par default le composant table affichera "no data" si il n'y a aucune donnée

5 - A l'ouverture de la page ou au rechargement les composants suivants doivent se trouver sur la page: form, dropdown, search, table.

6 - En soumettant le formulaire j'obtiens le résulat dans le composant table

7 - Si nous decidons de supprimer le dropdown depuis l'api /api/components, la page ne devra pas être cassée. Il faut prevoir un cas d'utilisation où il n'y aurait que les composants suivants: form, search, table.
