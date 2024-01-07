# L'interfce d'amorçage

 on commence notre distribution par le bootloader (chargeur d'amorçage) qui est un composant essentiel du processus de démarrage d'un système d'exploitation sur un ordinateur. Sa fonction principale est de charger le noyau du système d'exploitation en mémoire, permettant ainsi à l'ordinateur de passer de l'état de mise sous tension à celui d'exécution d'un système d'exploitation.
	Pour cela, on a défini notre propre loader pour notre distribution ; cela a été basée sur ces différentes étapes :

On a installé les thèmes par ce lien : https://github.com/vinceliuice/grub2-themes sous format Zip.

maintenant on execute le script install.sh par la command :
  ---$sudo ./install.sh
On sélectionne le thème qu’on veut activer : Dans not cas Vimix Themes.

# l’affichage du nom

Et pour l’affichage du nom de notre distribution durent l’amorcage  ; voilà ses étapes :
----$sudo apt-get update && apt-get upgrade
----$sudo apt-get install grub-customizer

Puis nous ouvrons  Grub-customizer et nous sélectionnons notre logo

# Pour le changement de logo :
1.sudo apt install plymouth
2.sudo apt install plymouth-themes
3.sudo vim plymouth-preview : on écrit ce script :
 #!/bin/bash
check_root () {
  if [ ! $(id -u) -eq 0 ]; then
    echo "Please run as root"
    exit
  fi
}
check_root
DURATION=$1
if [ $# -ne 1 ];
then
  DURATION=5
fi
plymouthd; plymouth --show-splash
for ((i=0; i<$DURATION; i++)); do
  plymouth --update=duration$i;
  sleep 1;
done;
plymouth --quit

4.sudo chmod +x plymouth-preview
5.Maintenant, on installe les thèmes de logo qu’on veut les activer par cette commande :
git clone https://github.com/adi1090x/plymouth-themes.git
on choisit le nom du thème qu’on veut et le pack ou elle se localise
6.cd pack –
7.sudo cp -r (nom du theme)  /usr/share/plymouth/themes
8.sudo ln -sf /usr/share/plymouth/themes/NOM_DU_THEME/NOM_DU_THEME.plymouth /etc/alternatives/default.plymouth
9.sudo update-initramfs -u
