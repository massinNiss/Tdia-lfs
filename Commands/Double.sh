#!/bin/bash

# Vérifie si aucun argument n'est passé
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Vérifie si le répertoire existe
if [ ! -d "$1" ]; then
    echo "Le répertoire spécifié n'existe pas."
    exit 1
fi

# Trouve les fichiers dupliqués dans le répertoire spécifié
echo "Recherche des fichiers dupliqués dans $1..."
echo "-----------------------------------------"
echo ""

# Utilisation de la commande find pour lister tous les fichiers et en vérifier les sommes de contrôle MD5
find "$1" -type f -exec md5sum {} + | sort | uniq -w32 -D

echo ""
echo "-----------------------------------------"
echo ""

# Demande à l'utilisateur de choisir les fichiers à supprimer
read -p "Entrez le chemin du fichier à supprimer (ou 'exit' pour quitter) : " file_to_delete

# Supprime le fichier si l'utilisateur le choisit
if [ "$file_to_delete" != "exit" ] && [ -f "$file_to_delete" ]; then
    rm -i "$file_to_delete"
    echo "Le fichier a été supprimé."
else
    echo "Aucun fichier supprimé."
fi
