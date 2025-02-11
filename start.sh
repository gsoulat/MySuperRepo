#!/bin/bash

# Affichage ASCII pour RocketWeb
echo -e "
 (        )             )                                   
 )\ )  ( /(    (     ( /(        *   )  (  (            (   
(()/(  ) $))   )\    )\()) (    )  /(  )$ )(   ' (   ( )\  
 /(_))((_)\  (((_) |((_)\  )\   ( )(_))((_)()\ )  )\  )((_) 
(_))    ((_) )\___ |_ ((_)((_) (_(_()) _(())\_)()((_)((_)_  
| _ \  / _ \((/ __|| |/ / | __||_   _| \ \((_)/ /| __|| _ ) 
|   / | (_) || (__   ' <  | _|   | |    \ \/\/ / | _| | _ \ 
|_|_\  \___/  \___| _|\_\ |___|  |_|     \_/\_/  |___||___/ 
                                                            
"

# Fonction pour vérifier si le fichier secrets.yml est correctement rempli
check_secrets_file() {
    echo "Avez-vous correctement rempli le fichier secrets.yml ? (o/n)"
    read ANSWER
    if [[ "$ANSWER" =~ ^[Oo]$ ]]; then
        return 0 # Oui, continue
    else
        return 1 # Non, retour au menu
    fi
}

# Fonction pour exécuter initial.yml
run_initial_playbook() {
    echo "Exécution du playbook initial.yml..."
    ansible-playbook initial.yml -i hosts.ini
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'exécution du playbook initial.yml."
        exit 1
    fi
}

# Fonction pour exécuter setup.yml
run_setup_playbook() {
    echo "Exécution du playbook setup.yml..."
    ansible-playbook setup.yml -i hosts.ini
    if [ $? -ne 0 ]; then
        echo "Erreur lors de la configuration des known_hosts."
        exit 1
    fi
}

# Fonction pour exécuter deploy.yml
run_deploy_playbook() {
    echo "Exécution du playbook deploy.yml..."
    ansible-playbook deploy.yml -i hosts.ini
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'exécution du playbook deploy.yml."
        exit 1
    fi
}

# Fonction pour exécuter github.yml
run_github_playbook() {
    echo "Exécution du playbook github.yml..."
    ansible-playbook github.yml -i hosts.ini
    if [ $? -ne 0 ]; then
        echo "Erreur lors de l'exécution du playbook github.yml."
        exit 1
    fi
}

# Fonction pour exécuter tout dans l'ordre
run_all() {
    if check_secrets_file; then
        run_initial_playbook
        run_setup_playbook
        run_deploy_playbook
        run_github_playbook
        echo "C'est fini ! Le script se terminera dans 15 secondes..."
        sleep 15
    else
        echo "Retour au menu principal."
    fi
}

# Menu principal
while true; do
    echo "Choisissez une option :"
    echo "1 : Laissez RocketWeb faire"
    echo "2 : Créer une clé SSH"
    echo "3 : Déployer à nouveau"
    echo "4 : Créer un repo GitHub + secrets"
    echo "5 : Quitter"
    read CHOICE

    case $CHOICE in
        1)
            run_all
            ;;
        2)
            run_initial_playbook
            ;;
        3)
            run_deploy_playbook
            ;;
        4)
            run_github_playbook
            ;;
        5)
            echo "Au revoir !"
            exit 0
            ;;
        *)
            echo "Option non valide. Veuillez choisir entre 1 et 5."
            ;;
    esac
done
