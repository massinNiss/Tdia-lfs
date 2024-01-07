# Préparation pour la Construction
  Note importante : Le Système de fichiers sera construit en utilisant une distribution Linux déjà installée (comme Debian, Ubuntu et Fedora ...). Ce système Linux existant (l'hôte) sera utilisé comme point de départ pour fournir les programmes nécessaires, y compris un compilateur(Compiler), un éditeur de liens (linker) et un shell, afin de construire le nouveau système.
    
1- Installation des paquets :
  Vous devez exécuter le script verify.sh  afin de vérifier si vous disposez de tous les paquets nécessaires et de la version appropriée dans votre distribution.Ensuite, installez les paquets necessaires

 # Système dans Linux :
  L'installation du system de fichier de manière temporaire est faite pour isoler le système hôte, assurer un environnement de construction propre, faciliter la cross-compilation, approfondir la compréhension du système Linux, offrir un contrôle total sur le processus de construction, et permettre la répétition et les tests sans risque.
# Création de partitions
  Un système minimal nécessite une partition d'environ 10 gigaoctets (Go). Cela suffit pour stocker tous les tarballs source et compiler les paquets. Cependant, si le système LFS est destiné à être le système Linux principal, des logiciels supplémentaires seront probablement installés, nécessitant plus d'espace. Une partition de 30 Go est une taille raisonnable pour permettre la croissance. Le système LFS lui-même n'occupera pas autant d'espace. Une grande partie de cette exigence est de fournir un stockage temporaire libre suffisant ainsi que pour ajouter des capacités supplémentaires après la complétion de LFS. De plus, la compilation des paquets peut nécessiter beaucoup d'espace disque qui sera récupéré après l'installation du paquet. Comme il n'y a pas toujours assez de mémoire vive (RAM) disponible pour les processus de compilation, il est judicieux d'utiliser une petite partition de disque comme espace de swap. Cela est utilisé par le noyau pour stocker des données rarement utilisées et laisser plus de mémoire disponible pour les processus actifs. La partition de swap pour un système LFS peut être la même que celle utilisée par le système hôte, auquel cas il n'est pas nécessaire d'en créer une autre. Lancez un programme de partitionnement de disque tel que cfdisk ou fdisk avec une option de ligne de commande nommant le disque dur sur lequel la nouvelle partition sera créée, par exemple /dev/sda pour le disque dur principal. Créez une partition native Linux et une partition de swap, si nécessaire.
    Nous avons créé un disque dur virtuel séparé et, à l'aide de la commande fdisk, nous avons réparti ce disque en deux partitions, une pour la racine et l'autre pour la partition d'échange(Swap).

créer un nouveau système de fichiers sur un périphérique de stockage en formatant une partition de disque spécifique en utilisant le système de fichiers ext4.
        mkfs -v -t ext4 /dev/<xxx>   //Remplacez <xxx> par le nom de la partition LFS.
        mkswap /dev/<yyy>   //Remplacez <yyy> par le nom de la partition d'échange.
    
# Définir la variable $LFS
  "/mnt/new" c'est le chemin de notre système de fichiers.
    export LFS=/mnt/lfs
# Montage de la nouvelle partition
Maintenant qu'un système de fichiers a été créé, la partition doit être montée pour que le système hôte puisse y accéder. Ce livre
suppose que le système de fichiers est monté dans le répertoire spécifié par la variable d'environnement LFS décrite dans le
section précédente.
  mkdir -pv $LFS
  mount -v -t ext4 /dev/<xxx> $LFS //Remplacez <xxx> par le nom de la partition LFS.

# Packages et correctifs ( Packages and Patches)
  Les paquets et correctifs téléchargés devront être stockés quelque part de manière pratique tout au long de la construction du système. Un répertoire de travail est également nécessaire pour décompresser les sources et les construire.
  $LFS/sources peut être utilisé à la fois comme emplacement pour stocker les fichiers tar et les correctifs, ainsi que comme répertoire de travail. En utilisant ce répertoire, les éléments requis seront situés sur la partition LFS et seront disponibles pendant toutes les étapes du processus de construction.
Rendez ce répertoire accessible en écriture et collant.
"Collant" signifie que même si plusieurs utilisateurs ont des permissions d'écriture sur un répertoire, seul le propriétaire d'un fichier peut supprimer le fichier à l'intérieur de celui-ci.

une archive tar de tous les fichiers nécessaires peut être téléchargée depuis l'un des sites miroirs.
répertorié sur https://www.linuxfromscratch.org/mirrors.html#files.
• Les fichiers peuvent être téléchargés à l'aide de wget et d'une liste wget comme décrit ci-dessous.
 wget https://www.linuxfromscratch.org/lfs/downloads/stable/wget-list-sysv

Pour télécharger l'ensemble des paquets et correctifs en utilisant wget-list comme entrée pour la commande wget, utilisez :
     wget --input-file=wget-list-sysv --continue --directory-prefix=$LFS/sources
Ensuite, exécutez cette commande pour vous assurer que tous les paquets installés précédemment sont la propriété de l'utilisateur root :
chown root:root $LFS/sources/*

# Preparations Finals
Dans cette section, nous commençons à peupler le système de fichiers LFS avec les éléments qui constitueront le système Linux final.
   mkdir -v /tools
   
Nous allons créer un nouvel utilisateur appelé "Tdia" en tant que membre d'un nouveau groupe (nommé "tdia") et exécuter des commandes en tant que "Tdia" pendant le processus d'installation. En tant que root, exécutez les commandes suivantes pour ajouter le nouvel utilisateur :


# Installation du system du fichier
Cette partie est divisée en trois étapes : 
    premièrement, la construction d'un compilateur croisé et de ses bibliothèques associées ; 
    deuxièmement, l'utilisation de cette chaîne d'outils croisée pour construire plusieurs utilitaires de manière à les isoler de la distribution hôte ; 
    et troisièmement, l'entrée dans l'environnement chroot (qui améliore encore l'isolation de l'hôte) et la construction des outils restants nécessaires pour construire le système final.
      
Le compilateur croisé sera installé dans un répertoire distinct $LFS/tools, car il ne fera pas partie du système final.

Binutils est installé en premier car les configurations à exécuter à la fois pour gcc et glibc effectuent divers tests de fonctionnalités sur l'assembleur et le lieur pour déterminer quelles fonctionnalités logicielles activer ou désactiver. C'est plus important qu'on pourrait le réaliser au départ. Une configuration incorrecte de gcc ou de glibc peut entraîner une chaîne d'outils subtilement défectueuse, où l'impact d'une telle défaillance peut ne pas se manifester avant la fin de la construction de toute une distribution. Un échec du jeu de tests mettra généralement en évidence cette erreur avant qu'un travail supplémentaire ne soit effectué.
Binutils installe son assembleur et son lieur dans deux emplacements, $LFS/tools/bin et $LFS/tools/$LFS_TGT/bin. Les outils dans un emplacement sont liés en dur à l'autre. Un aspect important du lieur est son ordre de recherche de bibliothèque. Des informations détaillées peuvent être obtenues à partir de ld en lui passant le drapeau --verbose. Par exemple, $LFS_TGT -ld --verbose | grep SEARCH illustrera les chemins de recherche actuels et leur ordre. (Notez que cet exemple peut être exécuté tel quel uniquement lorsque vous êtes connecté en tant qu'utilisateur lfs. Si vous revenez sur cette page ultérieurement, remplacez $LFS_TGT-ld par ld).
Dans cette partie, nous allons découvrir comment construire un compilateur croisé et ses outils associés. Bien que la cross-compilation soit simulée ici, les principes sont les mêmes que pour une véritable chaîne d'outils croisée. Les programmes compilés dans ce chapitre seront installés dans le répertoire $LFS/tools pour les séparer des fichiers installés dans les chapitres suivants. En revanche, les bibliothèques sont installées à leur emplacement final, car elles concernent le système que nous voulons construire.
Binutils-2.41 - Passe 1
Assurez-vous de donner l'accès à l'utilisateur Tdia au répertoire $LFS/sources.

# Construction d’un vrai compilateur :
   Ces commandes montrent le processus de construction de la bibliothèque Libstdc++ en utilisant le compilateur GCC. Notez que les commandes de configuration varient en fonction de la version spécifique de GCC que vous utilisez. Assurez-vous d'ajuster ces commandes en conséquence.
   
    mnt/new/sources/work/gcc-8.2 $ rm -rf build/
    /mnt/new/sources/work/gcc-8.2 $ cd build/
    
     /mnt/new/sources/work/gcc-8.2/build/$ ../libstdc++-v3/configure \ --host=$LFS_TGT --build=$(../config.guess) \ --prefix=/usr \ --disable-multilib \ --disable-nls \ --disable-libstdcxx-pch \ --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/13.2.0

    /mnt/new/sources/work/gcc-8.2/build/ $ make
    /mnt/new/sources/work/gcc-8.2/build/ $ make install
