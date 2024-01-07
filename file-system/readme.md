# Préparation pour la Construction
    Note importante : Le Système de fichiers sera construit en utilisant une distribution Linux déjà installée (comme Debian, Ubuntu et Fedora ...). Ce système Linux existant (l'hôte) sera utilisé comme point de départ pour fournir les programmes nécessaires, y compris un compilateur(Compiler), un éditeur de liens (linker) et un shell, afin de construire le nouveau système.
    
1- Installation des paquets :
  Vous devez exécuter le script verify.sh  afin de vérifier si vous disposez de tous les paquets nécessaires et de la version appropriée dans votre distribution.Ensuite, installez les paquets necessaires

 # Système dans Linux :
    L'installation du system de fichier de manière temporaire est faite pour isoler le système hôte, assurer un environnement de construction propre, faciliter la cross-compilation, approfondir la compréhension du système Linux, offrir un contrôle total sur le processus de construction, et permettre la répétition et les tests sans risque.
# Création de partitions
    Un système minimal nécessite une partition d'environ 10 gigaoctets (Go). Cela suffit pour stocker tous les tarballs source et compiler les paquets. Cependant, si le système LFS est destiné à être le système Linux principal, des logiciels supplémentaires seront probablement installés, nécessitant plus d'espace. Une partition de 30 Go est une taille raisonnable pour permettre la croissance. Le système LFS lui-même n'occupera pas autant d'espace. Une grande partie de cette exigence est de fournir un stockage temporaire libre suffisant ainsi que pour ajouter des capacités supplémentaires après la complétion de LFS. De plus, la compilation des paquets peut nécessiter beaucoup d'espace disque qui sera récupéré après l'installation du paquet. Comme il n'y a pas toujours assez de mémoire vive (RAM) disponible pour les processus de compilation, il est judicieux d'utiliser une petite partition de disque comme espace de swap. Cela est utilisé par le noyau pour stocker des données rarement utilisées et laisser plus de mémoire disponible pour les processus actifs. La partition de swap pour un système LFS peut être la même que celle utilisée par le système hôte, auquel cas il n'est pas nécessaire d'en créer une autre. Lancez un programme de partitionnement de disque tel que cfdisk ou fdisk avec une option de ligne de commande nommant le disque dur sur lequel la nouvelle partition sera créée, par exemple /dev/sda pour le disque dur principal. Créez une partition native Linux et une partition de swap, si nécessaire.
    Nous avons créé un disque dur virtuel séparé et, à l'aide de la commande fdisk, nous avons réparti ce disque en deux partitions, une pour la racine et l'autre pour la partition d'échange(Swap).

# Définir la variable $LFS
    "/mnt/new" c'est le chemin de notre système de fichiers.
    
