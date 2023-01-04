# Dploma

## Description

Le contrat Dploma est un contrat Ethereum qui permet de créer et de stocker des diplômes numériques. Une certification est composé de données sur le modèle utilisé, le certifieur et le certifié. Le certifié peut choisir de rendre sa certification visible ou non aux autres utilisateurs.

## Fonctionnalités

Voici les fonctionnalités de ce contrat :

- `Création de modèles de certification`: un utilisateur peut créer un modèle de certification en spécifiant son titre, son nom, sa date et ses spécifications.
- `Ajout de certifications avec modèle`: un utilisateur peut ajouter une certification en utilisant un modèle existant en spécifiant les informations du certifié et du certifieur.
- `Ajout de certifications sans modèle`: un utilisateur peut ajouter une certification en créant un nouveau modèle en spécifiant les informations du certifié, du certifieur et du modèle.
- `Modification de certifications`: Un certifieur peut modifier les informations d'une certification.
- `Suppression de certifications`: Un certifieur peut supprimer une certification. 
- `Visibilité de certifications`: le certifié peut choisir de rendre visible ou non ses données dans sa certification aux autres utilisateurs.

## Structures de données

Voici les structures de données utilisées dans ce contrat :

### Certification

Cette structure représente les données d'une certification. Elle contient les champs suivants :

- `dip_addr_certifier`: l'adresse Ethereum du certifieur.
- `dip_addr_certified`: l'adresse Ethereum de la personne certifiée.
- `dip_certified`: les données sur la personne certifiée (voir la structure Certified).
- `dip_cedrtifier`: les données sur le certifieur (voir la structure Certifier).
- `dip_template`: les données sur le modèle utilisé pour la certification (voir la structure Template).
  
### Template

Cette structure représente les données d'un modèle. Elle contient les champs suivants :

- `temp_title`: le titre du modèle.
- `temp_name`: le nom du modèle.
- `temp_date`: la date du modèle.
- `temp_spec`: les spécifications du modèle.

### Certified

Cette structure représente les données sur la personne certifiée. Elle contient les champs suivants :

- `cfied_firstname`: le prénom de la personne certifiée.
- `cfied_lastname`: le nom de famille de la personne certifiée.
- `cfied_birthdate`: la date de naissance de la personne certifiée.

### Certifier

Cette structure représente les données sur le certifieur. Elle contient les champs suivants :

- `cfier_name`: le nom du certifieur.
- `cfier_adress`: l'adresse du certifieur.

## Mappings

Voici les mappings utilisés dans ce contrat :

- `map_cert`: mapping de la structure Certification qui associe un identifiant unique (calculé à partir de l'adresse Ethereum du titulaire et de l'horodatage de la transaction) à une certification.
- `map_temp`: mapping de la structure Template qui associe un identifiant unique (calculé à partir de l'identifiant de modèle incrémenté) à un modèle.
- `unvisibleCertified`: mapping de la structure Certified qui associe un identifiant unique à une personne certifée. Ce mapping n'est utilisé que lorsque le certifié a choisi de rendre ses données non visible aux autres utilisateurs.
- `studentVisibility`: mapping booléen qui associe un identifiant unique à un booléen indiquant si les informations du certifié sont visible ou non aux autres utilisateurs.

## Événements

Voici les événements déclenchés par ce contrat :

- `evtTemplate`: déclenché lorsqu'un modèle est créé, avec en paramètre l'identifiant unique du modèle.
- `certifCreation`: déclenché lorsqu'une certification est ajoutée, avec en paramètre l'identifiant unique de la certification.
- `modificationMsg`: déclenché lorsqu'une certification est modifiée, avec en paramètre un message informant de la modification.
- `evtVisisbility`: déclenché lorsque la visibilité d'une certification est modifiée, avec en paramètre un message informant de la modification.
- `deletedCertif`: déclenché lorsqu'une certification est supprimée, avec en paramètre un message informant de la suppression.

## Fonctions

Voici les fonctions de ce contrat :

### createhashOwner(address _addrS)

Cette fonction privée génère un ID unique pour une certification en utilisant l'adresse de la personne certifiée, l'adresse de l'appelant et le timestamp du bloc actuel.

### createTemplate(string _title, string _name, string _date, string[] _specs)

Cette fonction permet de créer un nouveau modèle de certification en enregistrant ses données dans la map `map_temp`. Un ID unique est généré pour le modèle en utilisant la fonction keccak256.

### getTemplate(bytes32 _hashTemplate)

Cette fonction permet de récupérer les données d'un modèle en utilisant son ID.

### insertWithTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, bytes32 _hashTemplate, address _certified_pub_adress)

Cette fonction permet de créer une nouvelle certification en utilisant un modèle existant. Les données sur la certification et la personne certifiée sont enregistrées dans la map `map_cert`. Un ID unique est généré pour la certification en utilisant la fonction `createhashOwner`.

### insertWithoutTemplate(string _cfied_firstname, string _cfied_lastname, string _cfied_birthdate, string _cfier_name, string _cfier_adress, address _certified_pub_adress, string _title, string _name, string _date, string[] _specs)

Cette fonction permet de créer une nouvelle certification en utilisant un modèle qui est créé en même temps. Les données sur la certification, la personne certifiée et le modèle sont enregistrées dans la map `map_cert`. Un ID unique est généré pour la certification en utilisant la fonction `createhashOwner`.

### toggleStudentVisibility(bytes32 _idCert, bool _visibility)

Cette fonction permet de définir la visibilité d'une certification dans la map `studentVisibility`. Seul la personne certifée peut effectuer cette action.

### getCertification(bytes32 _idCert)

Cette fonction permet de récupérer les données sur une certification à partir de son ID. Si la certification est définie comme visible dans la map `studentVisibility`, les données sont retournées. Sinon, les données par défaut sont retournées pour une personne certifée inconnue.

### ModifyTemplate(bytes32 _hashCert, string _title, string _name, string _date date, string[] _specs)

Cette fonction permet de modifier un modèle existant. Les données sont mises à jour dans la map `map_cert`. Seul le certifieur peut effectuer cette action.

### deleteCertif(bytes32 _idCert)

Cette fonction permet de supprimer une certification existante de la map `map_cert`. Seul le certifieur peut effectuer cette action.
