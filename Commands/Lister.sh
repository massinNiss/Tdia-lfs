lister() {
    echo "Liste des environnements disponibles :"
    local environments=($(ls -d */ | sed 's#/##'))

    # Affiche les environnements disponibles
    for ((i=0; i<${#environments[@]}; i++)); do
        echo "$i. ${environments[$i]}"
    done

    # Demande à l'utilisateur de choisir un environnement
    read -p "Choisissez un environnement (entrez le numéro) : " env_number

    # Vérifie si l'entrée utilisateur est un nombre valide
    re='^[0-9]+$'
    if ! [[ $env_number =~ $re ]]; then
        echo "Veuillez entrer un numéro valide."
        return
    fi

    # Vérifie si le numéro choisi est dans la plage valide
    if (( env_number >= 0 && env_number < ${#environments[@]} )); then
        selected_env=${environments[$env_number]}
        echo "Accès à l'environnement $selected_env"
        source "$selected_env/bin/activate"
    else
        echo "Numéro d'environnement invalide."
    fi
}
