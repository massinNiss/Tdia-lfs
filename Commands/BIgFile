#!/bin/bash

# Vérifier si un argument est passé
if [ $# -eq 0 ]; then
    echo "Veuillez fournir le nom du répertoire."
    exit 1
fi

# Vérifier si le répertoire existe
if [ ! -d "$1" ]; then
    echo "Le répertoire spécifié n'existe pas."
    exit 1
fi

# Aller dans le répertoire spécifié
cd "$1" || exit

# Afficher les fichiers dans l'ordre décroissant de taille en bytes
echo "Liste des fichiers dans le répertoire $1, triés par taille décroissante :"
ls -lSrh --block-size=1 | grep "^-" | awk '{print $5, $9}' | sort -nr
