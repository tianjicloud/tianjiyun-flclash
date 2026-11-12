// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a fr locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'fr';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} sélectionnée', other: '${count} sélectionnées')}";

  static String m1(name) => "${name} ajouté aux proxys locaux";

  static String m2(name) => "${name} est déjà dans les proxys locaux";

  static String m3(count, skipped) =>
      "${count} à ajouter, ${skipped} ignorés car déjà présents";

  static String m4(time) => "Vérifié à ${time}";

  static String m5(line) => "Le trafic passera par « ${line} »";

  static String m6(name, status) => "Actuel : ${name} · ${status}";

  static String m7(actual, expected) =>
      "La sortie se trouve en ${actual}, tandis que la ligne choisie se trouve en ${expected}";

  static String m8(name, ip) =>
      "La ligne « ${name} » correspond à la sortie ${ip}";

  static String m9(date) => "Expire le ${date}";

  static String m10(month, day) => "${day}/${month}";

  static String m11(date) =>
      "Le forfait expire le ${date}. Renouvelez-le pour garder vos lignes";

  static String m12(value) => "Coefficient ${value}×";

  static String m13(days) => "Expiré depuis ${days} jours";

  static String m14(date) =>
      "Cette offre a expiré le ${date}. Renouvelez-la, puis validez à nouveau le même lien.";

  static String m15(step, total) =>
      "Étape ${step} sur ${total} · Vérifier l’abonnement";

  static String m16(count) => "Cochées · ${count}";

  static String m17(count) => "${count} applications sélectionnées";

  static String m18(name) =>
      "Le groupe résidentiel est verrouillé sur « ${name} ». Modifiez-le dans les lignes résidentielles.";

  static String m19(time) => "Abonnement mis à jour ${time}";

  static String m20(categories) =>
      "Sortie directe du centre de données pour : ${categories}";

  static String m21(count) => "${count} applications";

  static String m22(count) => "${count} réussis";

  static String m23(count) => "${count} requêtes";

  static String m24(version) => "Nouvelle version disponible : ${version}";

  static String m25(percent) => "${percent} % utilisé";

  static String m26(count) => "Règles Wi-Fi : ${count}";

  static String m27(detail) => "Impossible d’effacer les données : ${detail}";

  static String m28(count, download, upload) =>
      "Total : ${count} connexions · Téléchargement ${download} · Envoi ${upload} · Sélectionnez une ligne pour voir la chaîne et la règle correspondante";

  static String m29(code) =>
      "Windows a refusé d’exécuter TianjiCloudCore.exe (erreur ${code}). Une stratégie de contrôle des applications, telle que Smart App Control ou AppLocker, bloque les programmes non signés ; autorisez 天机云 dans cette stratégie ou désactivez-la, puis réessayez.";

  static String m30(name) =>
      "L’app n’a pas réussi à finir de démarrer deux fois de suite. Pour sortir de cette boucle, le profil ${name} a été désélectionné et la configuration automatique a été ignorée. Vous pouvez le sélectionner de nouveau à tout moment.";

  static String m31(url) => "Créer un profil à partir de ${url} ?";

  static String m32(members, count) => "${members} et ${count} autres";

  static String m33(count) => "Utilisé par ${count} règles";

  static String m34(count, label) =>
      "${Intl.plural(count, one: '1 règle SUB-RULE a été abandonnée, car les profils personnalisés ne prennent pas en charge les sous-règles', other: '${label} règles SUB-RULE ont été abandonnées, car les profils personnalisés ne prennent pas en charge les sous-règles')}";

  static String m35(message) =>
      "Le cœur ne peut pas analyser ce proxy : ${message}";

  static String m36(proxy, target) =>
      "${proxy} se connecte via ${target}, qui renvoie à ${proxy} ; la connexion boucle";

  static String m37(name) =>
      "Le nom ${name} est déjà utilisé par un autre proxy ou groupe de proxys";

  static String m38(path) =>
      "Les groupes de proxys se référencent mutuellement en boucle : ${path}";

  static String m39(name) =>
      "Le repli si vide doit être un proxy, mais ${name} n’existe pas ou est un groupe de proxys";

  static String m40(name, message) =>
      "${name} n’est pas une regex valide : ${message}";

  static String m41(name) => "Le proxy de connexion ${name} n’existe pas";

  static String m42(names) =>
      "Ces fournisseurs de proxys n’existent pas : ${names}";

  static String m43(names) =>
      "Ces proxys ou stratégies n’existent pas : ${names}";

  static String m44(name) =>
      "${name} est un nom de stratégie intégré et ne peut pas être utilisé ici";

  static String m45(count) =>
      "${count} éléments posent problème, et l’application de ce profil peut échouer";

  static String m46(count) => "Utilisé dans ${count} groupes";

  static String m47(count) =>
      "${Intl.plural(count, one: 'il y a 1 jour', other: 'il y a ${count} jours')}";

  static String m48(count) =>
      "${Intl.plural(count, other: 'il y a ${count} j')}";

  static String m49(label) =>
      "Voulez-vous vraiment supprimer les éléments sélectionnés (${label}) ?";

  static String m50(label) =>
      "Voulez-vous vraiment supprimer cet élément (${label}) ?";

  static String m51(hours) =>
      "Les ressources recherchent les mises à jour toutes les ${hours} heures ; en cas d’échec, la version précédente reste utilisée.";

  static String m52(label) => "Détails de ${label}";

  static String m53(name) =>
      "La connexion via ${name} renvoie au proxy qui l’utilise ; la connexion a donc été arrêtée";

  static String m54(label) => "${label} ne peut pas être vide";

  static String m55(label) => "${label} existe déjà";

  static String m56(count) =>
      "${count} éléments en échec. Appuyez pour afficher";

  static String m57(label, message) => "${label} : ${message}";

  static String m58(name) => "${name} est déjà à jour";

  static String m59(name) => "${name} mis à jour";

  static String m60(count) =>
      "${Intl.plural(count, one: '1 groupe', other: '${count} groupes')}";

  static String m61(count) => "${count} expirés";

  static String m62(action) =>
      "Déjà utilisé par « ${action} ». Choisissez un autre raccourci.";

  static String m63(modifiers) =>
      "Incluez au moins l’une de ces touches : ${modifiers}";

  static String m64(count) =>
      "${Intl.plural(count, one: 'il y a 1 heure', other: 'il y a ${count} heures')}";

  static String m65(count) =>
      "${Intl.plural(count, other: 'il y a ${count} h')}";

  static String m66(encoding) =>
      "Impossible de décoder ${encoding}, les données sont affichées telles qu’envoyées.";

  static String m67(memory, body) =>
      "Les plus anciens enregistrements sont supprimés en premier une fois ce nombre atteint ou ${memory} de mémoire occupés. Seuls les premiers ${body} de chaque corps sont conservés.";

  static String m68(invalid, total) => "${invalid} sur ${total} invalides";

  static String m69(target) => "${target} n’est pas une stratégie valide";

  static String m70(proxyName) => "${proxyName} n’est pas un proxy valide";

  static String m71(providerName) =>
      "${providerName} n’est pas un fournisseur de proxys valide";

  static String m72(ruleSet) => "${ruleSet} n’est pas un jeu de règles valide";

  static String m73(subRule) => "${subRule} n’est pas un SUB_RULE valide";

  static String m74(count) =>
      "${Intl.plural(count, one: '1 élément', other: '${count} éléments')}";

  static String m75(line, message) => "Ligne ${line} : ${message}";

  static String m76(appName) =>
      "1. Ouvrez Réglages système > Confidentialité et sécurité\n2. Choisissez Service de localisation\n3. Trouvez ${appName} dans la liste et cochez-le\n\nUne fois terminé, revenez dans l’app pour continuer. Merci de votre coopération.";

  static String m77(label, max) =>
      "${label} ne doit pas dépasser ${max} caractères";

  static String m78(size) => "${size} libérés";

  static String m79(count) =>
      "${Intl.plural(count, one: 'il y a 1 minute', other: 'il y a ${count} minutes')}";

  static String m80(count) =>
      "${Intl.plural(count, other: 'il y a ${count} min')}";

  static String m81(fileName) =>
      "${fileName} est enregistré dans Téléchargements. Installez-le dans Paramètres › Sécurité › Chiffrement et identifiants › Installer un certificat › Certificat CA.";

  static String m82(command) =>
      "Chrome et Firefox ont leurs propres magasins de certificats, qui nécessitent certutil : ${command}";

  static String m83(host) =>
      "Ajouter ${host} à la liste des noms d’hôte ? 天机云 pourra lire ce qui lui est envoyé, cookies et mots de passe compris.";

  static String m84(host) =>
      "Ajouter -${host} en tête de la liste des noms d’hôte ? L’hôte ne sera alors plus jamais déchiffré.";

  static String m85(size) => "Le fichier dépasse ${size} Mo";

  static String m86(stores) => "Pas encore dans : ${stores}";

  static String m87(name) =>
      "Les scripts de ${name} ont changé : le module a été désactivé";

  static String m88(system) =>
      "Écrit pour ${system} ; certaines lignes peuvent ne pas correspondre aux applications de cet appareil.";

  static String m89(name) =>
      "Impossible de supprimer l’ancien certificat, ${name}. Retirez-le vous-même des racines de confiance.";

  static String m90(name) =>
      "L’ancien certificat, ${name}, figure toujours parmi les certificats de confiance du système. Autorisez l’accès root à 天机云 dans votre gestionnaire root puis régénérez-le, ou supprimez-y le module « TianjiCloud MITM CA » et redémarrez.";

  static String m91(name) =>
      "Supprimez l’ancien certificat, ${name}, dans Paramètres › Sécurité › Chiffrement et identifiants › Identifiants de confiance › Utilisateur, puis installez le nouveau.";

  static String m92(section) =>
      "La section [${section}] n’est pas prise en charge";

  static String m93(count) =>
      "${Intl.plural(count, one: 'il y a 1 mois', other: 'il y a ${count} mois')}";

  static String m94(count) =>
      "${Intl.plural(count, other: 'il y a ${count} m')}";

  static String m95(code) =>
      "Le serveur a refusé l’accès (HTTP ${code}). Le lien a peut-être expiré, ou les identifiants sont incorrects";

  static String m96(code) => "Le serveur a rejeté la requête (HTTP ${code})";

  static String m97(code) =>
      "Rien n’a été trouvé à cette adresse (HTTP ${code}). Vérifiez que l’URL est correcte";

  static String m98(detail) => "Échec de la requête réseau : ${detail}";

  static String m99(code) =>
      "Le serveur a rencontré un problème (HTTP ${code}). Réessayez plus tard";

  static String m100(label) => "Aucun élément (${label}) pour le moment";

  static String m101(label, min, max) =>
      "${label} doit être compris entre ${min} et ${max}";

  static String m102(label) => "${label} doit être un nombre";

  static String m103(count) => "Importé · ${count} nœuds";

  static String m104(label) => "${label} doit être compris entre 1024 et 49151";

  static String m105(port) => "Port ${port}";

  static String m106(days) =>
      "${Intl.plural(days, one: '1 jour restant', other: '${days} jours restants')}";

  static String m107(date, days) =>
      "Expire le ${date}, ${Intl.plural(days, one: '1 jour restant', other: '${days} jours restants')}";

  static String m108(time) => "Mis à jour ${time}";

  static String m109(count) => "${count} éléments";

  static String m110(label, profiles) =>
      "${label} est encore utilisé par ${profiles}, qui ne fonctionneront plus correctement s’il est supprimé. Voulez-vous vraiment le supprimer ?";

  static String m111(count, label) =>
      "${Intl.plural(count, one: '1 proxy', other: '${label} proxys')}";

  static String m112(name, count) => "${name} et autres (${count} proxys)";

  static String m113(removed) =>
      "Ces proxys seront supprimés : ${removed}. Une ligne dont le nom a changé compte comme un nouveau proxy, et les profils personnalisés qui nomment les proxys supprimés les signaleront comme manquants. Appliquer quand même ?";

  static String m114(removed, added) =>
      "Ces proxys seront supprimés : ${removed}. Ceux-ci seront ajoutés : ${added}. Une ligne dont le nom a changé compte comme un nouveau proxy, et les profils personnalisés qui nomment les proxys supprimés les signaleront comme manquants. Appliquer quand même ?";

  static String m115(available, total) => "Disponibles ${available}/${total}";

  static String m116(label) =>
      "${label} est encore nommé par des règles, des groupes de proxys, des proxys de connexion, le DNS ou le NTP de ce profil, qui cesseront de fonctionner s’il est supprimé. Voulez-vous vraiment le supprimer ?";

  static String m117(count, label) =>
      "${Intl.plural(count, one: '1 groupe de proxys', other: '${label} groupes de proxys')}";

  static String m118(line) =>
      "« ${line} » a échoué à 3 vérifications consécutives. Vérifiez la ligne ou réessayez.";

  static String m119(name) => "Utiliser ${name}";

  static String m120(count, label) =>
      "${Intl.plural(count, one: '1 règle', other: '${label} règles')}";

  static String m121(appName) => "${appName} (mode sans échec)";

  static String m122(count) =>
      "${Intl.plural(count, one: '1 seconde', other: '${count} secondes')}";

  static String m123(count) => "${count} actifs";

  static String m124(count) =>
      "${Intl.plural(count, one: '1 problème', other: '${count} problèmes')}";

  static String m125(count) =>
      "${Intl.plural(count, one: '1 réglage', other: '${count} réglages')}";

  static String m126(link) => "Aucun proxy n’a pu être lu dans ${link}";

  static String m127(label) => "${label} doit être un seul élément";

  static String m128(name, date) => "${name} · ${date}";

  static String m129(days) => "Votre forfait expire dans ${days} jours";

  static String m130(value) => "Pic ${value}";

  static String m131(value) => "Total ${value}";

  static String m132(transport) => "En-têtes ${transport}";

  static String m133(label) => "${label} doit être une URL";

  static String m134(date) => "Valide jusqu’au ${date}";

  static String m135(count) =>
      "${Intl.plural(count, one: 'il y a 1 an', other: 'il y a ${count} ans')}";

  static String m136(count) =>
      "${Intl.plural(count, other: 'il y a ${count} a')}";

  static String m137(hours) =>
      "mise à jour automatique toutes les ${hours} heures";

  static String m138(count, unit) =>
      "Mise à jour automatique toutes les ${count} ${unit}";

  static String m139(date) => "Expire le ${date}";

  static String m140(count) =>
      "Basé sur l’abonnement actuel · ${count} règles de remplacement";

  static String m141(count) =>
      "Lien d’abonnement · expiré depuis ${count} jours";

  static String m142(scheme) =>
      "Vous pouvez aussi coller un lien du presse-papiers, choisir un fichier YAML local ou ouvrir ${scheme} dans un navigateur pour importer un lien.";

  static String m143(date) => "Fichier local · importé le ${date}";

  static String m144(quota) => "Total ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("À propos"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Contrôle d’accès"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Seules les apps sélectionnées passent par le VPN",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "Le contrôle d’accès des apps est désactivé",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Les apps sélectionnées sont exclues du VPN",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("Compte"),
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage(
      "Tester tous les délais",
    ),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Mode direct"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("Mode global"),
    "actionMode": MessageLookupByLibrary.simpleMessage("Changer de mode"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("Proxy système"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Mode règles"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Démarrer/Arrêter"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Mettre à jour les profils",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Afficher/Masquer"),
    "add": MessageLookupByLibrary.simpleMessage("Ajouter"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Ajouter un proxy"),
    "addFilters": MessageLookupByLibrary.simpleMessage("Ajouter des filtres"),
    "addNodes": MessageLookupByLibrary.simpleMessage("Ajouter des nœuds"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Ajouter une entrée de remplacement",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Ajouter un profil"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Ajouter un groupe de proxys",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Ajouter une règle"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage(
      "Ajouter un réglage",
    ),
    "addSsid": MessageLookupByLibrary.simpleMessage("Ajouter un SSID"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage(
      "Ajouter aux proxys locaux",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Règles ajoutées"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Paramètres supplémentaires",
    ),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage("Préfixe du nom"),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage("Suffixe du nom"),
    "address": MessageLookupByLibrary.simpleMessage("Adresse"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir une adresse WebDAV valide",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Configuration avancée",
    ),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage(
      "Profil chiffré",
    ),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage("Clé secrète age"),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "Ce profil est chiffré avec age et nécessite une clé secrète age pour être déchiffré",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("Accepter"),
    "all": MessageLookupByLibrary.simpleMessage("Tout"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage(
      "Tous les proxys référencés",
    ),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Tous les fournisseurs de proxys référencés",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Autoriser les apps à contourner le VPN",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Autoriser le LAN"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("IP autorisées"),
    "alreadyInLocalProxies": m2,
    "alreadyLatest": MessageLookupByLibrary.simpleMessage(
      "Vous utilisez la dernière version",
    ),
    "alwaysOnVpn": MessageLookupByLibrary.simpleMessage("VPN toujours activé"),
    "alwaysOnVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Activez Tianji Yun dans les réglages système",
    ),
    "answers": MessageLookupByLibrary.simpleMessage("Réponses"),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Contrôle d’accès des apps",
    ),
    "appBackground": MessageLookupByLibrary.simpleMessage("Arrière-plan"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage(
      "Conception de l’icône de l’app",
    ),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "Aucun proxy local",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Ajouter le DNS du système",
    ),
    "applied": MessageLookupByLibrary.simpleMessage("Appliqué"),
    "applyNow": MessageLookupByLibrary.simpleMessage("Appliquer maintenant"),
    "arguments": MessageLookupByLibrary.simpleMessage("Arguments"),
    "authentication": MessageLookupByLibrary.simpleMessage("Authentification"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Le proxy système n’est pas appliqué tant que l’authentification est activée.",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Autoriser"),
    "authorized": MessageLookupByLibrary.simpleMessage("Autorisé"),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Rechercher les mises à jour automatiquement",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Fermer les connexions automatiquement",
    ),
    "autoInclude": MessageLookupByLibrary.simpleMessage(
      "Inclure automatiquement",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Lancement automatique"),
    "autoRoute": MessageLookupByLibrary.simpleMessage("Routage automatique"),
    "autoRun": MessageLookupByLibrary.simpleMessage("Démarrage automatique"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Le démarrage automatique active le proxy à l’ouverture de l’app.",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Définir automatiquement le DNS du système",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage(
      "Mise à jour automatique",
    ),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalle de mise à jour automatique",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Retour"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("Aurore"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage(
      "Flou d’arrière-plan",
    ),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("Globe"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("Montagnes"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("Nébuleuse"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("Orbite"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("Planète"),
    "backgroundResidentialCheck": MessageLookupByLibrary.simpleMessage(
      "Vérification résidentielle en arrière-plan",
    ),
    "backgroundResidentialCheckDescription": MessageLookupByLibrary.simpleMessage(
      "Vérifie la sortie résidentielle actuelle toutes les 10 minutes en arrière-plan. Utilise un peu de trafic.",
    ),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("Couleur unie"),
    "backup": MessageLookupByLibrary.simpleMessage("Sauvegarde"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Sauvegarde et restauration",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "Cette sauvegarde provient d’une version plus récente de l’app. Mettez l’app à jour avant de la restaurer",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Sauvegarde réussie"),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Infos de base"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Stratégies de base"),
    "batchImport": MessageLookupByLibrary.simpleMessage("Importation groupée"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage(
      "Un élément par ligne",
    ),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage(
      "Un lien par ligne",
    ),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage(
      "Une URL par ligne",
    ),
    "binaryData": MessageLookupByLibrary.simpleMessage("Données binaires"),
    "bind": MessageLookupByLibrary.simpleMessage("Lier"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Mode liste noire"),
    "blockQuic": MessageLookupByLibrary.simpleMessage("Bloquer QUIC"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage("Réécriture du corps"),
    "brandName": MessageLookupByLibrary.simpleMessage("Tianji Cloud"),
    "brightness": MessageLookupByLibrary.simpleMessage("Luminosité"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage(
      "À propos et sauvegarde",
    ),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage(
      "Espace utilisateur et renouvellement",
    ),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage(
      "Couleur d’accentuation",
    ),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "Réseau avancé",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage(
      "Services IA",
    ),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage(
      "Toutes les lignes",
    ),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "Autoriser certaines apps hors VPN.",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage(
      "Proxy par application",
    ),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage(
      "Autoriser l’adaptateur",
    ),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "S’exécute en arrière-plan après la connexion à Windows",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage(
      "Lancer au démarrage",
    ),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Utiliser la ligne et le mode précédents",
    ),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage(
      "Se connecter au lancement",
    ),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage(
      "Test automatique",
    ),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Enregistre vos profils et réglages dans un fichier de sauvegarde.",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage(
      "Sauvegarder maintenant",
    ),
    "businessCards": MessageLookupByLibrary.simpleMessage("Cartes"),
    "businessChangeLine": MessageLookupByLibrary.simpleMessage(
      "Changer de ligne",
    ),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage(
      "Changer de ligne",
    ),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage(
      "Version du client",
    ),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "Version du client actuellement installée",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage(
      "Tout fermer",
    ),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage(
      "À la fermeture de la fenêtre",
    ),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Connecté · Anomalie détectée",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "Connecté · cliquer pour déconnecter",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "Connecté · Vérification de la sortie échouée",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "Connecté · Sortie non vérifiée",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage(
      "Copier les informations d’erreur",
    ),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("Actuel"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage(
      "IP de sortie actuel",
    ),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage(
      "Ligne actuelle",
    ),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("Nœud actuel"),
    "businessDashboardEditorHint": MessageLookupByLibrary.simpleMessage(
      "Faites glisser les cartes pour les réordonner et appuyez sur le bouton de suppression. La connexion et les scènes restent en haut.",
    ),
    "businessDatacenter": MessageLookupByLibrary.simpleMessage(
      "Centre de données",
    ),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage(
      "Tester la vitesse",
    ),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage(
      "Délai dépassé",
    ),
    "businessDetectedAt": MessageLookupByLibrary.simpleMessage("détecté"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "Ouvrir les diagnostics et outils avancés.",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "Ces options aident à diagnostiquer les problèmes. Il est généralement inutile de les modifier.",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "Options pour les développeurs",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage(
      "Accepter et continuer",
    ),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Affiché au premier démarrage",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage(
      "À lire avant utilisation",
    ),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("Déconnecter"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage(
      "DNS et inspection",
    ),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("Échec"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "Choisir comment générer les réponses DNS.",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "Aucun serveur DNS personnalisé n’est configuré.",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage(
      "Résolution par proxy",
    ),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "Aperçu des ressources de routage",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage("Serveurs DNS"),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("Réussi"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "Lire les noms d’hôte du trafic compatible.",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage(
      "Activer le routage intelligent",
    ),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage(
      "Essayez ces solutions",
    ),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "Changez le port dans Paramètres → Entrées et ports",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "Fermez le programme qui utilise le port 7890, puis relancez TianjiCloud",
    ),
    "businessExitAnomaly": MessageLookupByLibrary.simpleMessage(
      "Anomalie de ligne, contactez le support",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage(
      "Vérification de sortie réussie",
    ),
    "businessExitCountryMismatch": m7,
    "businessExitKindMismatch": MessageLookupByLibrary.simpleMessage(
      "Le type de sortie ne correspond pas à la ligne choisie",
    ),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "La sortie réelle ne correspond pas à la ligne choisie",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "La vérification de la sortie n’a rien renvoyé. Le proxy fonctionne peut-être toujours. Réessayez ou lancez le diagnostic.",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "Impossible de confirmer la sortie",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "L’adaptateur virtuel n’est pas autorisé. Le terminal et certaines applications contournent le proxy et voient votre IP locale. Autorisez-le une fois pour corriger cela.",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage(
      "Connecté · Sortie vérifiée",
    ),
    "businessExitVerifiedDetail": m8,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage(
      "Sortie vérifiée",
    ),
    "businessExpiryDate": m9,
    "businessExpiryDateShort": m10,
    "businessExpiryNotice": m11,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage(
      "Suivre le système",
    ),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("Groupes"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage("Verrouillé"),
    "businessHelp": MessageLookupByLibrary.simpleMessage("Aide"),
    "businessHome": MessageLookupByLibrary.simpleMessage("Accueil"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez une ligne pour définir ou modifier le raccourci",
    ),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage(
      "Importer à nouveau",
    ),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("Renouveler"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("Bloquer"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage(
      "Redémarrer le cœur",
    ),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "Le cœur réseau n’a pas pu démarrer",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage(
      "Durée d’exécution",
    ),
    "businessLegal": MessageLookupByLibrary.simpleMessage("Mentions légales"),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("lignes"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage(
      "Le changement de ligne a échoué. Réessayez.",
    ),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "La sélection manuelle est prioritaire : la ligne choisie devient la sortie. Son IP est vérifiée après le changement, avec la raison en cas d’écart.",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "La ligne choisie devient la sortie ; son IP est vérifiée après le changement.",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage(
      "Ligne par défaut",
    ),
    "businessLines": MessageLookupByLibrary.simpleMessage("Lignes"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "Aucune ligne chargée. Vérifiez votre abonnement.",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage(
      "Chargement des lignes disponibles…",
    ),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage(
      "Exporter vers un fichier local",
    ),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage("Ports locaux"),
    "businessLocked": MessageLookupByLibrary.simpleMessage("Verrouillé"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage(
      "Sortie verrouillée",
    ),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Connexion directe à la Chine continentale",
    ),
    "businessManage": MessageLookupByLibrary.simpleMessage("Gérer"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage(
      "Sélection manuelle",
    ),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "L’icône de la barre affiche toujours l’état de connexion",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage(
      "Réduire dans la zone de notification",
    ),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "Inspecter HTTPS avec le certificat local.",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM déchiffre le trafic HTTPS des domaines correspondants. Activez-le uniquement pour les modules de confiance.",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage(
      "Trafic du mois",
    ),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage(
      "Utilisé ce mois-ci",
    ),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Ouvrir les autres options d’interface VPN.",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "Plus de paramètres VPN",
    ),
    "businessMultiplier": m12,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage("Pile réseau"),
    "businessNoExitInfo": MessageLookupByLibrary.simpleMessage(
      "Aucune donnée de sortie",
    ),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage(
      "Non connecté",
    ),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage(
      "Connexion à la demande",
    ),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "Ajoutez un réseau Wi-Fi pour mettre l’application en pause lorsque vous vous y connectez.",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "Consultez les statistiques sur le tableau de bord",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "Importez la configuration de votre abonnement",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "Consultez l’état de connexion des lignes",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "Utiliser un autre lien d’abonnement",
    ),
    "businessOnboardingFailedDays": m13,
    "businessOnboardingFailedExpiredDescription": m14,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("Cet abonnement a expiré"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "Offre",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "Lien collé",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "Renouveler",
    ),
    "businessOnboardingFailedRetainedConfig": MessageLookupByLibrary.simpleMessage(
      "Votre configuration précédente est conservée et le client peut continuer à fonctionner.",
    ),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Revérifier",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "État",
    ),
    "businessOnboardingFailedStep": m15,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "Connectez-vous à Tianji Cloud en trois étapes",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "Importer et connecter",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "Scanner le QR code / choisir un fichier",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "Collez un lien Tianji Cloud",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Lien d’abonnement",
    ),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage(
      "Licences open source",
    ),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "Basé sur FlClash · GPL-3.0",
    ),
    "businessOrdinaryWebExit": MessageLookupByLibrary.simpleMessage(
      "Sortie pour les sites ordinaires",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("Sortie"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage(
      "Remplacements des abonnements",
    ),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "Le port 7890 est utilisé par un autre programme, TianjiCloud ne peut donc pas l’écouter. Les paramètres réseau n’ont pas été modifiés ; vous pouvez continuer à naviguer.",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage(
      "Confidentialité · Conditions d’utilisation",
    ),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Mise à jour automatique",
    ),
    "businessProfileAddClipboardRecognized":
        MessageLookupByLibrary.simpleMessage(
          "Lien d’abonnement Tianji Cloud détecté dans le presse-papiers.",
        ),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "Ajouter des règles à un abonnement existant",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "Configuration personnalisée",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage(
      "Fichier local",
    ),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "Copier depuis le panneau utilisateur",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage(
      "Lien d’abonnement",
    ),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "Plus d’options",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "Laisser vide pour utiliser le nom de l’offre de l’abonnement",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nom (facultatif)",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage(
      "Importer et vérifier",
    ),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage(
      "Ajouter un abonnement",
    ),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage(
      "Coller le lien d’abonnement",
    ),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Lien d’abonnement",
    ),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "L’importation est d’abord vérifiée. Une erreur d’analyse ne remplacera pas le profil actif.",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage(
      "Supprimer cet abonnement",
    ),
    "businessProfileEditDeleteDescription": MessageLookupByLibrary.simpleMessage(
      "Supprime uniquement cette configuration locale. Votre compte et votre forfait Tianji Cloud ne sont pas affectés.",
    ),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Supprimer l’abonnement",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage("Expire"),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("Substitutions actives : "),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " éléments",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "Substitutions et scripts",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " groupes",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("Masquer"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage(
      "Lignes",
    ),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage("Gérer"),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("Ouvrir"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("Forfait"),
    "businessProfileEditPreviewDescription": MessageLookupByLibrary.simpleMessage(
      "Aperçu en lecture seule. Utilisez la configuration personnalisée pour modifier.",
    ),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "Ce lien contient un jeton personnel. Ne le partagez pas.",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "Voir la configuration d’origine",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage(
      "Renouveler / mettre à niveau",
    ),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("Afficher"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Détails du forfait",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage(
      "Modifier l’abonnement",
    ),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "Faites glisser pour changer l’ordre. Les abonnements en tête s’affichent en premier dans le tableau de bord et la barre système.",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage(
      "Réorganiser les abonnements",
    ),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage(
      "Ensembles de proxys et de règles",
    ),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage(
      "Densité des cartes proxy",
    ),
    "businessProxyCheckedGroup": m16,
    "businessProxyDnsRemote": MessageLookupByLibrary.simpleMessage(
      "Les domaines du trafic proxy sont résolus par la ligne",
    ),
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage("Icônes proxy"),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "Les changements prennent effet à la prochaine connexion",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Ensembles de proxys",
    ),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage(
      "Reconnecter maintenant",
    ),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage(
      "Rechercher des applications",
    ),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "Contourner le proxy pour les apps cochées",
    ),
    "businessProxySelectedCount": m17,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "Proxy uniquement pour les apps cochées",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("Proxy"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage(
      "Non cochées",
    ),
    "businessRecheck": MessageLookupByLibrary.simpleMessage(
      "Vérifier à nouveau",
    ),
    "businessRegionAT": MessageLookupByLibrary.simpleMessage("Autriche"),
    "businessRegionAU": MessageLookupByLibrary.simpleMessage("Australie"),
    "businessRegionBE": MessageLookupByLibrary.simpleMessage("Belgique"),
    "businessRegionBR": MessageLookupByLibrary.simpleMessage("Brésil"),
    "businessRegionCA": MessageLookupByLibrary.simpleMessage("Canada"),
    "businessRegionCO": MessageLookupByLibrary.simpleMessage("Colombie"),
    "businessRegionCZ": MessageLookupByLibrary.simpleMessage("Tchéquie"),
    "businessRegionDE": MessageLookupByLibrary.simpleMessage("Allemagne"),
    "businessRegionFR": MessageLookupByLibrary.simpleMessage("France"),
    "businessRegionGB": MessageLookupByLibrary.simpleMessage("Royaume-Uni"),
    "businessRegionHK": MessageLookupByLibrary.simpleMessage("Hong Kong"),
    "businessRegionIT": MessageLookupByLibrary.simpleMessage("Italie"),
    "businessRegionJP": MessageLookupByLibrary.simpleMessage("Japon"),
    "businessRegionKR": MessageLookupByLibrary.simpleMessage("Corée du Sud"),
    "businessRegionLocalDns": MessageLookupByLibrary.simpleMessage(
      "Les domaines de Chine continentale sont résolus localement",
    ),
    "businessRegionRO": MessageLookupByLibrary.simpleMessage("Roumanie"),
    "businessRegionSE": MessageLookupByLibrary.simpleMessage("Suède"),
    "businessRegionSG": MessageLookupByLibrary.simpleMessage("Singapour"),
    "businessRegionTW": MessageLookupByLibrary.simpleMessage("Taïwan"),
    "businessRegionUS": MessageLookupByLibrary.simpleMessage("États-Unis"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("Remplacer"),
    "businessResidential": MessageLookupByLibrary.simpleMessage("Résidentiel"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "Haut débit résidentiel",
    ),
    "businessResidentialLockedHint": m18,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage(
      "Résidentiel",
    ),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage("Restaurer…"),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "Restaurer depuis un fichier ou WebDAV",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "Seule la ligne par défaut change. L’IA et le streaming conservent leurs règles, ainsi que les connexions directes et les blocages.",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "Le routage intelligent est désactivé. Cette ligne par défaut n’est pas utilisée actuellement.",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "Gérer les règles et fournisseurs.",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage(
      "Ensembles de règles",
    ),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage(
      "Placez le QR code de l’abonnement dans le cadre",
    ),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage(
      "Rechercher un nom ou une région",
    ),
    "businessSelected": MessageLookupByLibrary.simpleMessage("Sélectionné"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "L’abonnement ou le mode a changé. Rouvrez la sélection.",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage(
      "Connexion inutile",
    ),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage(
      "À propos de Tianji Cloud",
    ),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage(
      "Apparence",
    ),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("Général"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS et ressources",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage(
      "Raccourcis",
    ),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage(
      "Icônes et UA",
    ),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "Entrées et ports",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "Réseau (avancé)",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("Autre"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage(
      "Règles et remplacements",
    ),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "Démarrage et fenêtre",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage(
      "Adaptateur virtuel TUN",
    ),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage(
      "Routage intelligent",
    ),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage(
      "Trier par latence",
    ),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "Choisir la pile réseau utilisée par le VPN.",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Mise à jour automatique de l’abonnement",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Actualisation automatique après un changement de ligne",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "Détails de l’abonnement",
    ),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage(
          "Paramètres DNS fournis par cet abonnement.",
        ),
    "businessSubscriptionUpdatedAt": m19,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Abonnements",
    ),
    "businessSubstitutedCategories": m20,
    "businessSwitchMode": MessageLookupByLibrary.simpleMessage(
      "Changer de mode",
    ),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "Acheminer HTTP via le proxy système.",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "Proxy système (HTTP)",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Touchez pour vous connecter",
    ),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("Tout tester"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage(
      "Apparence",
    ),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "Apparence et langue",
    ),
    "businessToolsApplicationCount": m21,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("Parcourir"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "Connexions et requêtes",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("Général"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage(
      "Connecter directement les appareils du réseau local",
    ),
    "businessToolsPassedCount": m22,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage(
      "Proxy par application",
    ),
    "businessToolsRequestCount": m23,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "Ressources de routage",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage(
      "Journaux d’exécution",
    ),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "Chinois simplifié",
    ),
    "businessTrafficNotOnTianji": MessageLookupByLibrary.simpleMessage(
      "Le trafic ne passe pas par Tianji",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage(
      "Trafic du mois sur cet appareil uniquement",
    ),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "Accès direct aux imprimantes, NAS et autres appareils du réseau local",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage(
      "Acheminer le trafic de toutes les applications",
    ),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage(
      "Nom de l’adaptateur",
    ),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage(
      "Routes exclues",
    ),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("routes"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "TCP et UDP utilisent la pile utilisateur gVisor",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "TCP et UDP utilisent la pile réseau en espace utilisateur mipstack",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("Mixte"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP utilise la pile système et UDP gVisor, pour une meilleure compatibilité",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "TCP et UDP utilisent la pile réseau du système",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "L’adaptateur virtuel prend en charge toutes les applications, y compris les terminaux, jeux et applications qui ignorent le proxy système. Le service système doit être exécuté en administrateur.",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage(
      "Prise en charge du trafic",
    ),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage(
      "Interface réseau virtuelle (TUN)",
    ),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage(
      "Texte et disposition",
    ),
    "businessUpdateAvailable": m24,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("Chaque jour"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage(
      "Toutes les heures",
    ),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage(
      "Toutes les 12 heures",
    ),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage(
      "Toutes les 6 heures",
    ),
    "businessUsagePercent": m25,
    "businessVersion": MessageLookupByLibrary.simpleMessage("Version"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Voir le diagnostic",
    ),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "Autorisez le VPN lors de la première connexion",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage(
      "Sauvegarde WebDAV",
    ),
    "businessWifiRulesCount": m26,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Domaines contournés"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Les domaines contournés ne s’appliquent que si le proxy système est activé.",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage(
      "Contourner les adresses privées",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Cache"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage(
      "Algorithme de cache",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Le cache est corrompu. Le vider ?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Taille du cache"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Autorisez l’accès à l’appareil photo dans les réglages du système pour scanner des codes QR, ou choisissez une image de code QR dans l’album.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Autorisation de l’appareil photo requise",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Appareil photo indisponible",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Annuler"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Tout désélectionner",
    ),
    "cannotSave": MessageLookupByLibrary.simpleMessage(
      "Enregistrement impossible",
    ),
    "certificate": MessageLookupByLibrary.simpleMessage("Certificat"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "Échec du changement de proxy ; la sélection précédente a été rétablie",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Changements majeurs",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("Nouveautés"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage(
      "Corrections de bugs",
    ),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage(
      "Performances",
    ),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Annulations"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Vérifier les certificats TLS",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "Sans vérification TLS, les abonnements et les sauvegardes sont exposés aux attaques de l’homme du milieu.",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage(
      "Rechercher des mises à jour",
    ),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "L’app est déjà à jour",
    ),
    "checkingExit": MessageLookupByLibrary.simpleMessage(
      "Vérification de la sortie…",
    ),
    "chooseFile": MessageLookupByLibrary.simpleMessage("Choisir un fichier"),
    "cipher": MessageLookupByLibrary.simpleMessage("Chiffrement"),
    "clearData": MessageLookupByLibrary.simpleMessage("Effacer les données"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "Cela supprime tous les profils, réglages et données locales, puis ferme l’app. Rouvrez-la pour repartir de zéro.",
    ),
    "clearDataFailed": m27,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage("Vider le cache DNS"),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage(
      "Échec du vidage du cache DNS",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Effacer la recherche"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage(
      "Empreinte client",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Exporter vers le presse-papiers",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Importer depuis le presse-papiers",
    ),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "Aucun nom de package valide dans le presse-papiers",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de copier dans le presse-papiers. La sélection est peut-être trop volumineuse",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Fermer"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage(
      "Fermer toutes les connexions",
    ),
    "closeConnection": MessageLookupByLibrary.simpleMessage(
      "Fermer la connexion",
    ),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Fermer les connexions",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Couleur"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("Style de couleur"),
    "columns": MessageLookupByLibrary.simpleMessage("Colonnes"),
    "compact": MessageLookupByLibrary.simpleMessage("Compact"),
    "compactSidebar": MessageLookupByLibrary.simpleMessage(
      "Barre latérale compacte",
    ),
    "compatible": MessageLookupByLibrary.simpleMessage("Mode de compatibilité"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmer"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment effacer toutes les données ?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment supprimer ce groupe de proxys ?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment quitter la fenêtre actuelle ?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment forcer le plantage du cœur ?",
    ),
    "congestionControl": MessageLookupByLibrary.simpleMessage(
      "Contrôle de congestion",
    ),
    "congestionController": MessageLookupByLibrary.simpleMessage(
      "Contrôle de congestion TCP",
    ),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Le contrôle de congestion TCP ne fonctionne qu’avec la pile mips.",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connecté"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connexion…"),
    "connection": MessageLookupByLibrary.simpleMessage("Connexion"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage(
      "Ajouter une règle pour ce domaine",
    ),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage("Bloqué"),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage(
      "Fermer cette connexion",
    ),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("Groupe"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage(
      "Cet appareil",
    ),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage(
      "Règle appliquée",
    ),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage(
      "Chemin du processus",
    ),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage(
      "Rechercher un domaine, une app ou une règle",
    ),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage(
      "Domaine détecté",
    ),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage(
      "Adresse source",
    ),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage(
      "Heure de début",
    ),
    "connectionStats": MessageLookupByLibrary.simpleMessage(
      "Statistiques de connexion",
    ),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Connexions en direct, requêtes récentes et requêtes DNS",
    ),
    "connectionSummary": m28,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("Écoulé"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage(
      "IP de destination",
    ),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage(
      "Chemin du trafic",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Connexions"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage(
      "Connexions et requêtes",
    ),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("En direct"),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivité : "),
    "content": MessageLookupByLibrary.simpleMessage("Contenu"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Le contenu ne peut pas être vide",
    ),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Gérer les règles ajoutées globales",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copier"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage("Copier en Base64"),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("Copier en cURL"),
    "copyDestination": MessageLookupByLibrary.simpleMessage(
      "Copier la destination",
    ),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copier les variables d’environnement",
    ),
    "copyHost": MessageLookupByLibrary.simpleMessage("Copier l’hôte"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copier le lien"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("Copier la requête"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("Copier la réponse"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage(
      "Copier le corps de la réponse",
    ),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Copier le lien de l’abonnement",
    ),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copié avec succès"),
    "core": MessageLookupByLibrary.simpleMessage("Cœur"),
    "coreBlockedByPolicyTip": m29,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Windows Smart App Control a bloqué TianjiCloudCore.exe car il n’est pas signé. Ouvrez Sécurité Windows → Contrôle des applications et du navigateur → Paramètres de Smart App Control, choisissez Désactivé, puis relancez 天机云. Smart App Control ne peut pas être réactivé sans réinstaller Windows.",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("État du cœur"),
    "country": MessageLookupByLibrary.simpleMessage("Région"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Plantage détecté"),
    "crashDetectedTip": m30,
    "crashTest": MessageLookupByLibrary.simpleMessage("Test de plantage"),
    "create": MessageLookupByLibrary.simpleMessage("Créer"),
    "createProfileFromUrlTip": m31,
    "creationTime": MessageLookupByLibrary.simpleMessage("Date de création"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("Expiration"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage(
      "Contient le bouton de démarrage et ne peut pas être retiré",
    ),
    "currentUsage": MessageLookupByLibrary.simpleMessage(
      "Utilisé sur la période",
    ),
    "custom": MessageLookupByLibrary.simpleMessage("Personnalisé"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("Ajouter un proxy"),
    "customColor": MessageLookupByLibrary.simpleMessage(
      "Couleur personnalisée",
    ),
    "customEditorPanelEmpty": MessageLookupByLibrary.simpleMessage(
      "Sélectionnez un élément pour modifier ses réglages ici.",
    ),
    "customGroupMemberSummary": m32,
    "customGroupRuleUsage": m33,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("Groupes"),
    "customImportDroppedSubRules": m34,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage(
      "Importer depuis un lien",
    ),
    "customIssueCoreRejected": m35,
    "customIssueDialerLoop": m36,
    "customIssueDuplicateName": m37,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "Le nom est vide",
    ),
    "customIssueGroupLoop": m38,
    "customIssueInvalidEmptyFallback": m39,
    "customIssueInvalidFilter": m40,
    "customIssueMissingDialer": m41,
    "customIssueMissingProviders": m42,
    "customIssueMissingProxies": m43,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "Aucun proxy ni fournisseur de proxys n’est sélectionné ; le cœur rejette donc ce groupe",
    ),
    "customIssueReservedName": m44,
    "customIssuesSummary": m45,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage(
      "Prévisualiser la configuration fusionnée",
    ),
    "customProfile": MessageLookupByLibrary.simpleMessage("Personnalisé"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage(
      "Fournisseurs et chaînage",
    ),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Proxys personnalisés",
    ),
    "customProxyGroupUsage": m46,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "Les proxys de l’abonnement s’affichent avec ceux-ci.",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage(
      "Non référencé",
    ),
    "customResources": MessageLookupByLibrary.simpleMessage("Personnalisé"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("Mes règles"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage(
      "Ajouter depuis les préréglages",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Couper"),
    "dark": MessageLookupByLibrary.simpleMessage("Sombre"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Tableau de bord"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage(
      "Disponibles à l’ajout",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "Échec de l’enregistrement de la modification ; elle a été annulée",
    ),
    "daysAgo": m47,
    "daysAgoShort": m48,
    "daysUnit": MessageLookupByLibrary.simpleMessage("jours"),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage(
      "Déchiffrer sans confiance locale",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Résout les noms des autres serveurs DNS. Adresses IP uniquement.",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage(
      "Sélection par défaut",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("Par défaut"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "La configuration doit être un mappage YAML avec un nom et un type",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("Délai"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("Échec"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Test de délai"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage(
      "Délai d’expiration du test de latence",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Supprimer"),
    "deleteMultipTip": m49,
    "deleteTip": m50,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Un client proxy multiplateforme basé sur ClashMeta, simple d’utilisation, open source et sans publicité.",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage(
      "Base de données des systèmes autonomes",
    ),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 est la plage de mappage fake-IP ; la résolution DNS réelle se fait à la sortie, sans passer par votre FAI local.",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage(
      "Base de données de localisation IP",
    ),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage(
      "Base de données des catégories de domaines",
    ),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage("À jour"),
    "desktopResourceUpdateNote": m51,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "Règles fournies par l’abonnement",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "GeoIP de destination",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "ASN de l’IP de destination",
    ),
    "details": m52,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Repose sur une API tierce ; à titre indicatif uniquement",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Mode développeur"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Le mode développeur est activé.",
    ),
    "diagnosticsEnableTun": MessageLookupByLibrary.simpleMessage("Activer TUN"),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("Non réussi"),
    "diagnosticsIpv6": MessageLookupByLibrary.simpleMessage("IPv6"),
    "diagnosticsIpv6Blocked": MessageLookupByLibrary.simpleMessage(
      "Le trafic IPv6 est capturé par TUN et bloqué par le cœur.",
    ),
    "diagnosticsIpv6Checking": MessageLookupByLibrary.simpleMessage(
      "Vérification du trafic IPv6.",
    ),
    "diagnosticsIpv6Direct": MessageLookupByLibrary.simpleMessage(
      "IPv6 n’est capturé ni par TUN ni par le proxy système et peut se connecter directement.",
    ),
    "diagnosticsIpv6NoNetwork": MessageLookupByLibrary.simpleMessage(
      "Cet appareil ne dispose pas de réseau IPv6.",
    ),
    "diagnosticsIpv6ProxyOnly": MessageLookupByLibrary.simpleMessage(
      "Le proxy système ne couvre pas toutes les applications ; IPv6 peut passer en direct. Activez TUN.",
    ),
    "diagnosticsIpv6Routed": MessageLookupByLibrary.simpleMessage(
      "Le trafic IPv6 est capturé par TUN et suit la route.",
    ),
    "diagnosticsIpv6Unavailable": MessageLookupByLibrary.simpleMessage(
      "Informations réseau IPv6 indisponibles.",
    ),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("Réussi"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("Relancer"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage(
      "Vérification de la sortie du chemin par défaut",
    ),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("Démarrer"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage(
      "Diagnostic rapide",
    ),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "Les contrôles de sortie DNS, WebRTC du navigateur et NTP ne sont pas disponibles.",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage(
      "Non vérifiable",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("Proxy de connexion"),
    "dialerProxyLoopStopped": m53,
    "dialog": MessageLookupByLibrary.simpleMessage("Boîte de dialogue"),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Résout les domaines des connexions directes.",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage(
      "Désactiver le transfert ICMP",
    ),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "Avec le transfert ICMP désactivé, TUN répond lui-même au ping, qui n’indique donc plus la latence réelle.",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage(
      "Désactiver le keep-alive TCP",
    ),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Désactiver UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Désactivé"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "Abandonner les modifications ?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Avertissement"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "Cette déclaration explique la nature, les risques et les responsabilités liés à l\'utilisation du Logiciel. Elle n\'ajoute aucune condition à la GPL-3.0 et ne limite aucun des droits que cette licence vous accorde, notamment ceux d\'exécuter, de copier, de modifier et de distribuer le Logiciel. En cas de divergence, la GPL-3.0 prévaut.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "Rapport avec la licence open source",
    ),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "J\'ai lu et compris cette déclaration",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "Pour confirmer que vous avez compris, lisez la déclaration suivante et cochez la case ci-dessous :",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage(
      "Confirmer la déclaration",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "Cette déclaration peut être révisée dans les versions ultérieures ; chaque version contient celle qui s\'y applique.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Modifications de cette déclaration",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Avant d\'utiliser 天机云 (« le Logiciel »), lisez attentivement cette déclaration et assurez-vous de bien la comprendre. Appuyer sur « Accepter » signifie que vous avez lu et compris ce qui suit. Si vous ne souhaitez pas continuer, appuyez sur « Quitter ».",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "Dans toute la mesure permise par la loi applicable, ni les développeurs ni aucun contributeur ne sauraient être tenus responsables de dommages directs, indirects, accessoires, spéciaux, punitifs ou consécutifs résultant de l’utilisation ou de l’impossibilité d’utiliser le Logiciel, y compris, sans s’y limiter, la perte de données, les dommages matériels, les pannes réseau, l’interruption d’activité, le manque à gagner ou tout litige qui en découlerait, même s’ils ont été avertis de la possibilité de tels dommages.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Limitation de responsabilité",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "Le Logiciel est open source sous licence GPL-3.0. Selon cette licence, vous pouvez l\'exécuter, l\'étudier, le modifier et le distribuer ; lorsque vous distribuez le Logiciel ou une version modifiée, vous devez également en fournir le code source sous GPL-3.0 et conserver les mentions de droits d\'auteur d\'origine.\n\nLes composants tiers du Logiciel, y compris le noyau Clash.Meta, suivent leurs propres licences. Les auteurs d\'origine ne sont pas responsables des problèmes liés aux versions modifiées ou distribuées par d\'autres.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Licence open source",
    ),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "Le Logiciel ne fournit lui-même aucun serveur proxy, nœud, abonnement ni service d’accès au réseau, et n’a aucun partenariat, mandat ni lien de garantie avec un quelconque fournisseur de tels services.",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "Le Logiciel ne collecte ni ne transmet vos URL d’abonnement, détails de nœuds, contenus de configuration, sites visités, historiques de connexion, contenus de trafic ou journaux. Ces données restent sur votre appareil et les développeurs n’y ont pas accès.\n\nLe Logiciel n’accède au réseau que lorsque vous utilisez une fonction qui en a besoin, par exemple pour récupérer l’URL d’abonnement que vous avez fournie lors de la mise à jour d’un profil, ou pour contacter GitHub lors de la recherche de mises à jour.\n\nLe Logiciel n’inclut aucun service d’analyse ni de rapport de plantage, sur aucune plateforme.",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Collecte de données et confidentialité",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "Il vous incombe de vous assurer que l’utilisation du Logiciel est licite là où vous vivez, et vous assumez seul la responsabilité juridique de tout ce que vous faites avec lui et de ses conséquences.\n\nLes abonnements, nœuds et configurations que vous importez relèvent de votre choix. La licéité de leur source, la sécurité de leur contenu et la fiabilité de leur service sont une affaire entre vous et leurs fournisseurs.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Votre responsabilité",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage(
      "Saisissez la déclaration ci-dessus",
    ),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "Ne correspond pas à la déclaration",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "Pour confirmer que vous avez compris, saisissez la déclaration suivante en entier dans le champ ci-dessous :",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage(
      "Recopier la déclaration",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "Le Logiciel est un client proxy réseau open source construit sur le cœur Clash.Meta (mihomo). Il se limite à fournir des outils locaux tels que la gestion de la configuration, le routage par règles et le transfert du trafic.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Nature du logiciel",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Les liens d’abonnement, fichiers de configuration, jeux de règles, scripts, ressources externes et liens externes sont tous fournis par des tiers. Les développeurs ne peuvent ni ne vont vérifier ou garantir leur légalité, leur exactitude, leur sécurité ou leur disponibilité.\n\nTout vol de données, perte financière, bannissement de compte ou autre dommage causé par un contenu tiers se règle entre vous et le tiers concerné ; les développeurs n’en assument aucune responsabilité.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Contenus tiers",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "Toute activité commerciale menée par quiconque avec le Logiciel, y compris la distribution payante, la vente groupée ou l\'utilisation au sein d\'un service commercial, est sans lien avec les développeurs du Logiciel, qui ne l\'approuvent, ne la soutiennent ni ne la garantissent.\n\nIl vous appartient de respecter les lois du pays ou de la région où vous vous trouvez, et vous assumez les conséquences de toute utilisation illégale du Logiciel.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage(
      "À propos de l\'utilisation",
    ),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "Le Logiciel est fourni « tel quel » et « selon disponibilité », sans garantie d’aucune sorte, expresse ou implicite, y compris, sans s’y limiter, les garanties de qualité marchande, d’adéquation à un usage particulier, d’absence de contrefaçon, de disponibilité ininterrompue, d’absence d’erreurs ou d’absence de failles de sécurité.\n\nLes développeurs ne garantissent pas que le Logiciel répondra à vos besoins ni qu’il fonctionnera sans interruption ni erreur.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "Absence de garantie",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Déconnecté"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Nouvelle version disponible",
    ),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("Bloqué"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage("Cache DNS vidé"),
    "dnsExit": MessageLookupByLibrary.simpleMessage("Sortie DNS"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage(
      "Aucun résultat disponible",
    ),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("Traitement"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "Sans cette entrée, TUN détourne toutes les requêtes DNS vers le port 53 (any:53).",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("Détournement DNS"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Mode DNS"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Les entrées ajoutées ici remplacent le DNS de tous les profils URL et fichier ; tout ce qui n’est pas ajouté garde le réglage du profil. Les profils personnalisés définissent leur DNS dans leur contenu.",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("Via proxy"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("Requêtes DNS"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "DNS et ressources",
    ),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("DNS amont"),
    "docked": MessageLookupByLibrary.simpleMessage("Ancrée"),
    "domain": MessageLookupByLibrary.simpleMessage("Domaine"),
    "done": MessageLookupByLibrary.simpleMessage("Terminé"),
    "download": MessageLookupByLibrary.simpleMessage("Réception"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Bande passante de réception",
    ),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Téléchargement de la mise à jour",
    ),
    "duration": MessageLookupByLibrary.simpleMessage("Durée"),
    "edit": MessageLookupByLibrary.simpleMessage("Modifier"),
    "editDashboard": MessageLookupByLibrary.simpleMessage(
      "Modifier le tableau de bord",
    ),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Modifier les règles globales",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Modifier le proxy"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Modifier le groupe de proxys",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Modifier la règle"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Modifier le SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Éditeur indisponible",
    ),
    "elapsed": MessageLookupByLibrary.simpleMessage("Durée"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage("Repli si vide"),
    "emptyTip": m54,
    "en": MessageLookupByLibrary.simpleMessage("Anglais"),
    "enabled": MessageLookupByLibrary.simpleMessage("Activé"),
    "entries": MessageLookupByLibrary.simpleMessage(" entrées"),
    "error": MessageLookupByLibrary.simpleMessage("Erreur"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("Détails de l’erreur"),
    "es": MessageLookupByLibrary.simpleMessage("Espagnol"),
    "eventAlerts": MessageLookupByLibrary.simpleMessage("Alertes d’événement"),
    "exclude": MessageLookupByLibrary.simpleMessage(
      "Masquer des tâches récentes",
    ),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage(
      "Ports de destination exclus",
    ),
    "excludeFilter": MessageLookupByLibrary.simpleMessage("Filtre d’exclusion"),
    "excludeInterface": MessageLookupByLibrary.simpleMessage(
      "Interfaces exclues",
    ),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage(
      "Ports source exclus",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("SSID exclus"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "Lorsque vous êtes connecté à un Wi-Fi dont le SSID est exclu, l’état d’exécution de l’app change automatiquement.",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage("ID utilisateur exclus"),
    "existsTip": m55,
    "exit": MessageLookupByLibrary.simpleMessage("Quitter"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage(
      "Quitter le plein écran",
    ),
    "exitNodes": MessageLookupByLibrary.simpleMessage("Nœuds de sortie"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Statut attendu"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Date d’expiration"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("Expiré"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage(
      "Exporter le certificat",
    ),
    "exportFile": MessageLookupByLibrary.simpleMessage("Exporter le fichier"),
    "exportHar": MessageLookupByLibrary.simpleMessage("Exporter en HAR"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Exporter les journaux"),
    "exportShort": MessageLookupByLibrary.simpleMessage("Exporter"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage(
      "Exportation réussie",
    ),
    "extend": MessageLookupByLibrary.simpleMessage("Extension"),
    "extendMode": MessageLookupByLibrary.simpleMessage("Mode d’extension"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage(
      "Remplacements et scripts d’extension",
    ),
    "extendScript": MessageLookupByLibrary.simpleMessage("Script d’extension"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Contrôleur externe",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Le contrôleur externe permet de piloter le cœur via le port 9090.",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage(
      "Secret du contrôleur externe",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("Lien externe"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Très grande"),
    "fade": MessageLookupByLibrary.simpleMessage("Fondu"),
    "failedCount": m56,
    "failedItem": m57,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Filtre Fake-IP"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "Ces domaines reçoivent leur vraie IP au lieu d’une Fake-IP. En mode whitelist, eux seuls reçoivent une Fake-IP.",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Mode du filtre Fake-IP",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Plage Fake-IP"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Plage Fake-IP (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("TTL Fake-IP"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Utilisés à la place de Nameserver quand le filtre de repli juge sa réponse polluée.",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Filtre de repli"),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Ces domaines sont résolus directement par Fallback.",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Les domaines de ces catégories GeoSite sont résolus directement par Fallback.",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "Si Nameserver renvoie une IP de ces plages, la réponse de Fallback est utilisée.",
    ),
    "file": MessageLookupByLibrary.simpleMessage("Fichier"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Le fichier a été modifié. Enregistrer les modifications ?",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filtrer"),
    "filters": MessageLookupByLibrary.simpleMessage("Filtres"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage(
      "Recherche de processus",
    ),
    "floating": MessageLookupByLibrary.simpleMessage("Flottante"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Suivre le profil"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Suivre le système"),
    "followSystemAccent": MessageLookupByLibrary.simpleMessage(
      "Suivre la couleur d’accentuation du système",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Police"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Taille"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage(
      "Forcer le mappage DNS",
    ),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "Forcer le mappage DNS analyse aussi les connexions dont le domaine provient d’un mappage DNS.",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage("Domaines forcés"),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Les domaines forcés sont aussi analysés ; les autres connexions qui ont déjà un domaine sont laissées telles quelles.",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment forcer le redémarrage du cœur ?",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Français"),
    "general": MessageLookupByLibrary.simpleMessage("Général"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Les entrées ajoutées ici remplacent le réglage correspondant de tous les profils ; tout ce qui n’est pas ajouté garde le réglage du profil, ou la valeur par défaut du cœur si le profil n’en a pas.",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage(
      "Générer le certificat",
    ),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m58,
    "geoUpdated": m59,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Mode Geo à faible mémoire",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Aller"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Télécharger"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage(
      "Aller à la configuration des règles ajoutées",
    ),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Aller à la configuration du script",
    ),
    "grid": MessageLookupByLibrary.simpleMessage("Grille"),
    "groupBy": MessageLookupByLibrary.simpleMessage("Grouper par"),
    "groupCount": m60,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("groupes"),
    "groupTimeoutCount": m61,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Mettre les modifications en cache ?",
    ),
    "hashByInUser": MessageLookupByLibrary.simpleMessage(
      "Hachage par utilisateur entrant",
    ),
    "headerRewrite": MessageLookupByLibrary.simpleMessage(
      "Réécriture d’en-têtes",
    ),
    "healthCheck": MessageLookupByLibrary.simpleMessage("Contrôle d’état"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Service Helper indisponible ; le mode TUN ne peut pas être activé. Réinstallez 天机云 pour le rétablir.",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("Hex"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Masquer de la liste"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Masquer l’IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage(
      "Masquer le mot de passe",
    ),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Masquer les proxys expirés",
    ),
    "hopInterval": MessageLookupByLibrary.simpleMessage("Intervalle de saut"),
    "host": MessageLookupByLibrary.simpleMessage("Hôte"),
    "hostname": MessageLookupByLibrary.simpleMessage("Nom d’hôte"),
    "hotkeyConflictWith": m62,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Les raccourcis globaux fonctionnent même lorsque la fenêtre est masquée. Appuyez sur une action pour enregistrer sa combinaison de touches.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Gestion des raccourcis",
    ),
    "hotkeyNeedsModifier": m63,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Non défini"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Non enregistré, il est peut-être pris par une autre app",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("heures"),
    "hoursAgo": m64,
    "hoursAgoShort": m65,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage(
      "Non enregistré faute de mémoire.",
    ),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "Lu comme Protobuf sans schéma : numéros de champ uniquement, types supposés.",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage(
      "Seul le début de ce corps a été enregistré.",
    ),
    "httpBodyUndecoded": m66,
    "httpCapture": MessageLookupByLibrary.simpleMessage("Capture HTTP"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "Enregistre les requêtes vers les hôtes listés dans Nom d’hôte, à consulter dans les détails de la connexion. Les enregistrements restent uniquement en mémoire.",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage(
      "Nombre maximal d’enregistrements",
    ),
    "httpCaptureLimitDesc": m67,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "Aucun hôte n’est listé, rien n’est donc enregistré. Ajoutez des hôtes dans Nom d’hôte sur la page MITM, ou depuis les détails d’une connexion.",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage(
      "La capture est désactivée",
    ),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "Une requête peut contenir des cookies, des jetons, des mots de passe et le contenu de formulaires. Vérifiez ce que vous partagez, et avec qui.",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage(
      "Contient des données privées",
    ),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage(
      "L\'enregistrement de cette requête a été effacé",
    ),
    "httpRequests": MessageLookupByLibrary.simpleMessage("Requêtes HTTP"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "Les requêtes envoyées avant l\'activation de la capture, ou déjà effacées, ne sont pas listées.",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage(
      "Déchiffrement HTTPS",
    ),
    "hue": MessageLookupByLibrary.simpleMessage("Teinte"),
    "icon": MessageLookupByLibrary.simpleMessage("Icône"),
    "iconRecords": MessageLookupByLibrary.simpleMessage(
      "Historique des icônes",
    ),
    "iconSets": MessageLookupByLibrary.simpleMessage("Jeux d’icônes"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "Aucun jeu d’icônes pour le moment. Ajoutez-en dans Ressources des profils personnalisés → Jeux d’icônes",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Style des icônes"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("Pleines"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Masquées"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Simples"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("URL de l’icône"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignorer l’optimisation de la batterie",
    ),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "import": MessageLookupByLibrary.simpleMessage("Importer"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage(
      "Ce fichier n’est pas une configuration importable",
    ),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "L’importation remplace les groupes de proxys, les règles et les réglages actuels de ce profil",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage(
      "Importer depuis un fichier",
    ),
    "importFromLink": MessageLookupByLibrary.simpleMessage(
      "Importer depuis un lien",
    ),
    "importSubscription": MessageLookupByLibrary.simpleMessage(
      "Importer un abonnement",
    ),
    "importUrl": MessageLookupByLibrary.simpleMessage(
      "Importer depuis une URL",
    ),
    "inProgress": MessageLookupByLibrary.simpleMessage("En cours"),
    "inUse": MessageLookupByLibrary.simpleMessage("En cours"),
    "inbound": MessageLookupByLibrary.simpleMessage("Entrant"),
    "includeInterface": MessageLookupByLibrary.simpleMessage(
      "Interfaces incluses",
    ),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "Seul le trafic arrivant sur les interfaces incluses passe par TUN, et les interfaces exclues ne s’appliquent plus.",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage("ID utilisateur inclus"),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("N’expire jamais"),
    "init": MessageLookupByLibrary.simpleMessage("Initialisation"),
    "initFailed": MessageLookupByLibrary.simpleMessage("Échec du démarrage"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "天机云 a rencontré une erreur au démarrage et ne peut pas continuer. Copiez les détails pour signaler le problème. Si cela se reproduit, effacer les données permet généralement de relancer l’app.",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("Initiateur"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("De"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Saisissez le nom du groupe de proxys",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez le contenu de la règle",
    ),
    "installCertificate": MessageLookupByLibrary.simpleMessage(
      "Installer dans le système",
    ),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage(
      "Certificat installé",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "L’autorisation de la liste des apps a été refusée ; les apps installées ne peuvent donc pas être listées. Veuillez l’accorder manuellement dans les réglages du système.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Ce système masque la liste des apps installées tant que l’autorisation n’est pas accordée. Accordez-la pour configurer le proxy par app.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Autorisation de la liste des apps requise",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage(
      "Polices installées",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Sélection intelligente",
    ),
    "intercept": MessageLookupByLibrary.simpleMessage("Bloquer"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Nom de l’interface"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Interface sortante",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Aucune"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage(
      "Personnalisée",
    ),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Suivre la configuration",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Intervalle"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("IP du réseau local"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Fichier de sauvegarde non valide",
    ),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez une plage d’IP au format CIDR, par exemple 192.168.0.0/16",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "Une marque DSCP ne peut pas dépasser 63",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez un domaine ou une adresse IP",
    ),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage(
      "Jeu d’icônes non valide",
    ),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage(
      "Ce n’est ni un lien d’abonnement ni un lien de partage de proxy",
    ),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez une adresse et un port, par exemple 0.0.0.0:1053",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Seuls tcp ou udp sont pris en charge",
    ),
    "invalidOfCount": m68,
    "invalidPolicy": m69,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez un port ou une plage, par exemple 443 ou 8000-9000",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "Ce code QR ne contient pas de lien de profil",
    ),
    "invalidProxy": m70,
    "invalidProxyProvider": m71,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Saisissez des nombres ou des plages tels que 80 ou 8000-9000, séparés par /",
    ),
    "invalidRuleSet": m72,
    "invalidSubRule": m73,
    "ipAddress": MessageLookupByLibrary.simpleMessage("Adresse IP"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Antécédents d’abus"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Indicateurs"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Organisation"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de déterminer le type de l’IP",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Bonne"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Niveau"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Normale"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage(
      "Vérifier à nouveau",
    ),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("À risque"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("Qualité"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Réponse de"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Sources"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "IP sortante différente",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("Aucun type"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage(
      "Limite de débit atteinte",
    ),
    "ipType": MessageLookupByLibrary.simpleMessage("Type"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Entreprise"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Centre de données"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Réseau mobile"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Résidentielle"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("Type inconnu"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("Version d’IP"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "Le trafic IPv6 n’est reçu que si IPv6 est activé.",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage(
      "Délai d’expiration IPv6 (ms)",
    ),
    "itemsCount": m74,
    "ja": MessageLookupByLibrary.simpleMessage("Japonais"),
    "justNow": MessageLookupByLibrary.simpleMessage("À l’instant"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage(
      "Inactivité keep-alive TCP",
    ),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Intervalle keep-alive TCP",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Clé"),
    "ko": MessageLookupByLibrary.simpleMessage("Coréen"),
    "label": MessageLookupByLibrary.simpleMessage("Libellé"),
    "language": MessageLookupByLibrary.simpleMessage("Langue"),
    "large": MessageLookupByLibrary.simpleMessage("Grande"),
    "lastBackupTime": MessageLookupByLibrary.simpleMessage(
      "Dernière sauvegarde",
    ),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Dernière mise à jour"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "Démarrage inachevé",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "L’app s’est arrêtée de façon inattendue lors de son dernier démarrage. La configuration automatique a été ignorée pour ce lancement ; vous pouvez la démarrer manuellement pour réessayer.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Disposition"),
    "light": MessageLookupByLibrary.simpleMessage("Clair"),
    "lineIssueTip": m75,
    "lineRate": MessageLookupByLibrary.simpleMessage("Taux"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("Retour à la ligne"),
    "link": MessageLookupByLibrary.simpleMessage("Lien"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("Liquid Glass"),
    "list": MessageLookupByLibrary.simpleMessage("Liste"),
    "listen": MessageLookupByLibrary.simpleMessage("Écoute"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Marque de routage d’écoute",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "La marque de routage d’écoute ne fonctionne que sous Linux.",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage(
      "Connexions en direct",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Chargement…"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localFile": MessageLookupByLibrary.simpleMessage("Fichier local"),
    "localImage": MessageLookupByLibrary.simpleMessage("Image locale"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Autorisation du réseau local refusée : la pile gvisor est utilisée, le LAN est inaccessible.",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("Proxys locaux"),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Autorisation de localisation",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "L’autorisation de localisation a été refusée ; le nom du Wi-Fi actuel ne peut donc pas être lu. Veuillez l’activer manuellement dans les réglages du système.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Le système exige l’autorisation de localisation pour lire le nom du Wi-Fi. Sur Android, choisissez « Toujours autoriser », sinon le nom du Wi-Fi ne peut pas être lu lorsque l’app est en arrière-plan.",
    ),
    "locationPermissionGuide": m76,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Autorisation de localisation requise",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Journal"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("Erreur"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("Info"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("Avertissement"),
    "logLevel": MessageLookupByLibrary.simpleMessage(
      "Niveau de journalisation",
    ),
    "logRedactionNotice": MessageLookupByLibrary.simpleMessage(
      "Les rapports exportés masquent les jetons d’abonnement, mots de passe, UUID, clés privées et en-têtes Authorization ou Cookie.",
    ),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Désactiver Logcat masque l’entrée Journaux.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Journaux"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Journaux et diagnostic",
    ),
    "logsRunning": MessageLookupByLibrary.simpleMessage("Journaux d’exécution"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Test des journaux"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Exemption de bouclage UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Aérée"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage("Direct continent"),
    "mapLocal": MessageLookupByLibrary.simpleMessage("Mappage local"),
    "matchCase": MessageLookupByLibrary.simpleMessage("Respecter la casse"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage(
      "Faire correspondre l’IP source",
    ),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("Règles appliquées"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("Échecs maximum"),
    "maxLengthTip": m77,
    "maximize": MessageLookupByLibrary.simpleMessage("Agrandir"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Mémoire résidente",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("App et partagée"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("Tas inactif"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("Tas utilisé"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "Le cœur n’est pas en cours d’exécution",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Surcharge du runtime",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage(
      "Piles de goroutines",
    ),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Estimation d’après la mémoire résidente du processus ; elle peut différer de ce qu’indique le système.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "Le cœur s’exécute dans le processus de l’app. Sa part est estimée à partir des statistiques du runtime, et le reste compte comme mémoire de l’app et partagée.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Infos mémoire"),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Mémoire utilisée par l’app et le cœur",
    ),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("Mémoire libérée"),
    "memoryReleasedSize": m78,
    "messageTest": MessageLookupByLibrary.simpleMessage("Test de message"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "Ceci est un message.",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Méthode"),
    "minimize": MessageLookupByLibrary.simpleMessage("Réduire"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Réduire à la fermeture",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("minutes"),
    "minutesAgo": m79,
    "minutesAgoShort": m80,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage(
      "Ajouter un fichier local",
    ),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage(
      "Ajouter une règle de mappage local",
    ),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage(
      "Ajouter une règle de rejet",
    ),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("Pièces jointes"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "Les lignes désignent les pièces jointes par leur nom de fichier, comme script-path=a.js.",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "Seules les applications qui font confiance aux certificats utilisateur, surtout les navigateurs, sont déchiffrées.",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "Exportez-le et faites-lui confiance sur les appareils à déchiffrer.",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "Les navigateurs Flatpak nécessitent d’importer le certificat exporté à la main.",
    ),
    "mitmCertificateSavedTip": m81,
    "mitmCertutilMissing": m82,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "Le client a refusé le certificat. Installez l’AC, ou excluez cet hôte si l’application épingle son certificat.",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage(
      "Déchiffrer cet hôte",
    ),
    "mitmDecryptHostTip": m83,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "天机云 pourra lire tout ce qui est envoyé aux hôtes déchiffrés, cookies et mots de passe compris. N’activez cette option que pour les hôtes à réécrire.",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage(
      "Exclure du déchiffrement",
    ),
    "mitmExcludeHostTip": m84,
    "mitmFileTooLarge": m85,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "Un - en tête exclut un hôte, et la première correspondance l’emporte.",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage("Lignes ignorées"),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "Root a été détecté : le certificat sera ajouté aux certificats de confiance du système sous forme de module Magisk, KernelSU ou APatch « TianjiCloud MITM CA ». Toutes les applications de l’appareil lui feront alors confiance, et quiconque détient sa clé privée pourra déchiffrer le trafic HTTPS de l’appareil. Pour annuler, régénérez le certificat ou supprimez le module dans le gestionnaire root, puis redémarrez. Si root est refusé, il sera installé comme certificat utilisateur.",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "Root n’a pas été détecté : le certificat ne peut être installé que comme certificat utilisateur. Seules les applications qui font confiance aux certificats utilisateur, surtout les navigateurs, sont déchiffrées ; les autres échouent sur les hôtes listés, ne listez donc pas leurs hôtes. À partir d’Android 11, vous terminez l’installation vous-même dans les paramètres système.",
    ),
    "mitmMissingStores": m86,
    "mitmModule": MessageLookupByLibrary.simpleMessage("Module"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "Ce n’est ni un module Surge, ni un plugin Loon, ni un extrait Quantumult X, ni une surcharge Stash",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Les règles de routage passent avant celles du profil.",
    ),
    "mitmModuleScriptsChanged": m87,
    "mitmModuleSystemTip": m88,
    "mitmModules": MessageLookupByLibrary.simpleMessage("Modules"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("Nouveau module"),
    "mitmOldCertificateLeftTip": m89,
    "mitmOldSystemCertificateLeftTip": m90,
    "mitmRemoveOldCertificateTip": m91,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "Le certificat prendra effet après le redémarrage de l’appareil.",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "Aucun Magisk, KernelSU ou APatch n’a été trouvé pour conserver le certificat. Installez-le de nouveau après le redémarrage de l’appareil.",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage(
      "Règles de routage",
    ),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "Ce module est une surcharge Stash : la règle a été copiée pour que vous l’ajoutiez à la main.",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage(
      "Exécuter maintenant",
    ),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage(
      "Le script s\'est terminé sans sortie",
    ),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "Ses scripts lisent et modifient le trafic des hôtes qu\'ils ciblent, cookies et jetons compris, et peuvent envoyer leurs propres requêtes. Ne l\'activez que si vous faites confiance à sa source.",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage(
      "Exécuter les scripts de ce module ?",
    ),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage(
      "Les réécritures conditionnelles ne sont pas prises en charge",
    ),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage(
      "Désactivé par un argument",
    ),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage(
      "Cet événement n\'est pas pris en charge",
    ),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage(
      "Les réécritures jq ne sont pas prises en charge",
    ),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage(
      "Les réécritures de corps JSON ne sont pas prises en charge",
    ),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage(
      "Son fichier n’a pas encore été téléchargé",
    ),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "Seules les politiques DIRECT et REJECT sont prises en charge",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "La réécriture de tous les en-têtes comme un seul texte n’est pas prise en charge",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "Le fichier que nomme cette ligne n’est pas joint ; utilisez une URL ou joignez-le",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage(
      "Ce type de règle n’est pas pris en charge",
    ),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage(
      "Ce type de script n\'est pas pris en charge",
    ),
    "mitmSkipSection": m92,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage(
      "Ce réglage n’est pas pris en charge",
    ),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage(
      "Cette ligne est illisible",
    ),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible d’ajouter le certificat aux racines de confiance du système",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("Vérification…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Non installé",
    ),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("Approuvé"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage(
      "Pas entièrement approuvé",
    ),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Port mixte"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage(
      "Validité du forfait",
    ),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Trafic restant",
    ),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage("Icône monochrome"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "monthsAgo": m93,
    "monthsAgoShort": m94,
    "more": MessageLookupByLibrary.simpleMessage("Plus"),
    "name": MessageLookupByLibrary.simpleMessage("Nom"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Serveurs DNS utilisés par défaut, par ex. 223.5.5.5, tls://1.1.1.1 ou https://dns.google/dns-query.",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Les domaines correspondants utilisent le serveur DNS indiqué ici plutôt que Nameserver et Fallback.",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage(
      "Barre inférieure",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Réseau"),
    "networkAccessDeniedError": m95,
    "networkBadResponseError": m96,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "La requête a été annulée",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "Impossible de se connecter au serveur. Vérifiez votre connexion réseau ou vos réglages de proxy",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "Impossible de résoudre l’adresse du serveur. Vérifiez que l’URL est correcte et que le DNS fonctionne",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("Nom du réseau"),
    "networkNotFoundError": m97,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Trop de requêtes (HTTP 429). Patientez un instant puis réessayez",
    ),
    "networkRequestFailed": m98,
    "networkSecret": MessageLookupByLibrary.simpleMessage("Secret du réseau"),
    "networkServerError": m99,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Débit réseau"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage(
      "Prise en charge du trafic",
    ),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "La requête a expiré. Vérifiez votre réseau ou votre proxy, puis réessayez",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Échec de la connexion sécurisée. Le certificat du serveur est peut-être invalide, ou la connexion est interceptée",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Type de réseau"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Résultat suivant"),
    "no": MessageLookupByLibrary.simpleMessage("Non"),
    "noData": MessageLookupByLibrary.simpleMessage("Aucune donnée"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Aucune information"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Ne plus me le rappeler",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Aucun réseau"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Apps sans réseau"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Ne pas résoudre l’IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Ne pas résoudre le nom d’hôte",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage("Aucun résultat"),
    "nodes": MessageLookupByLibrary.simpleMessage("Nœuds"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "Cette ressource externe n’est pas un fichier texte",
    ),
    "none": MessageLookupByLibrary.simpleMessage("Aucun"),
    "notRunning": MessageLookupByLibrary.simpleMessage("À l’arrêt"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Le groupe de proxys actuel n’est pas sélectionnable",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalle de synchronisation (minutes)",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Ajoutez un profil pour commencer",
    ),
    "nullTip": m100,
    "numberRangeTip": m101,
    "numberTip": m102,
    "obfs": MessageLookupByLibrary.simpleMessage("Obfuscation"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("Hôte d’obfuscation"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("Mode d’obfuscation"),
    "obfsParam": MessageLookupByLibrary.simpleMessage(
      "Paramètre d’obfuscation",
    ),
    "obfsPassword": MessageLookupByLibrary.simpleMessage(
      "Mot de passe d’obfuscation",
    ),
    "onDemand": MessageLookupByLibrary.simpleMessage("À la demande"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "Vérification de l’accès internet…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "Le presse-papiers est vide",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "Vérifiez le lien d’abonnement complet ci-dessus avant de l’importer.",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Abonnement Tianji Cloud",
    ),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("Se connecter"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "La connexion a échoué. Réessayez plus tard.",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("Connecté"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "Connecté, mais sans accès à internet",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage("Connexion…"),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "Une fois connecté, l’application fera une vraie requête internet pour le confirmer.",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("Continuer"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "Collez ou scannez le lien d’abonnement du panneau, puis connectez-vous en quelques étapes.",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("Sortie"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("Expire le"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Le forfait a peut-être expiré, ou le trafic de ce mois est épuisé. Renouvelez ou réinitialisez le trafic, puis appuyez sur « Réessayer ».",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "Aucun nœud utilisable dans cet abonnement",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "L’abonnement a peut-être été réinitialisé dans le panneau. Copiez à nouveau l’adresse d’abonnement depuis votre panneau utilisateur, puis collez-la ici.",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Le lien d’abonnement a expiré",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Appuyez sur « Copier l’adresse d’abonnement » dans votre panneau utilisateur, puis collez-la ici.",
        ),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage(
          "Ce n’est pas un lien d’abonnement",
        ),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "Vérifiez votre réseau et réessayez.",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "L’importation a échoué",
    ),
    "onboardingFailureUnreachableDescription": MessageLookupByLibrary.simpleMessage(
      "Votre réseau actuel bloque peut-être ce domaine. La page d’état propose des adresses de secours, ou réessayez plus tard.",
    ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "Impossible d’atteindre l’adresse d’abonnement",
    ),
    "onboardingImported": m103,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage(
      "Récupération de l’abonnement…",
    ),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "Lecture de la liste des nœuds et des informations du forfait",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "Accès internet · vérifié",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "Pas encore d’adresse d’abonnement ? Ouvrez votre panneau utilisateur pour la copier ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "Le nœud actuel est peut-être temporairement indisponible. Changer de nœud résout généralement le problème.",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("Pas maintenant"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage(
      "Ouvrir le panneau utilisateur",
    ),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage(
      "Coller à nouveau",
    ),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "Coller le lien d’abonnement depuis le presse-papiers",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "Le presse-papiers n’est lu que lorsque vous appuyez sur le bouton. Le lien d’abonnement reste sur cet appareil.",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Trafic restant",
    ),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage(
      "Scanner le QR code du panneau",
    ),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage(
      "Changer de nœud",
    ),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Importez un abonnement pour commencer",
    ),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage(
      "Voir l’adresse de secours",
    ),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Le système demandera si Tianji Cloud peut créer une connexion VPN. Appuyez sur « OK ». Cette autorisation n’est demandée qu’une fois.",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage(
      "Une autorisation système est nécessaire",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Ne compter que le trafic proxy",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage(
      "Ouvrir les paramètres",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Facultatif"),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("URL d\'origine"),
    "other": MessageLookupByLibrary.simpleMessage("Autre"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Autres contributeurs",
    ),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage(
      "Autres configurations",
    ),
    "outbound": MessageLookupByLibrary.simpleMessage("Sortant"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("Sortie"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("IP sortante"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Mode sortant"),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "Gardez généralement le mode « Règles ». Le mode global fait aussi passer le trafic de Chine continentale par le proxy ; le mode direct désactive toutes les lignes.",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "Le mode direct est actif",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "Le mode global est actif",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage(
      "Rétablir les règles",
    ),
    "overrideDestination": MessageLookupByLibrary.simpleMessage(
      "Remplacer la destination",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage(
      "Entrées de remplacement",
    ),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("Remplacements"),
    "overview": MessageLookupByLibrary.simpleMessage("Aperçu"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage(
      "Analyser les IP seules",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Mot de passe"),
    "paste": MessageLookupByLibrary.simpleMessage("Coller"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage(
      "Importer du presse-papiers",
    ),
    "peers": MessageLookupByLibrary.simpleMessage("Pairs"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage(
      "Choisir dans l’album",
    ),
    "pinWindow": MessageLookupByLibrary.simpleMessage("Épingler la fenêtre"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Veuillez lier un WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir un nom de script",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Veuillez importer un code QR valide",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("Plugin"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage(
      "Chiffrement du plugin",
    ),
    "pluginHost": MessageLookupByLibrary.simpleMessage("Hôte du plugin"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("Mode du plugin"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage(
      "Mot de passe du plugin",
    ),
    "pluginPath": MessageLookupByLibrary.simpleMessage("Chemin du plugin"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage(
      "Nom d’utilisateur du plugin",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir un autre port",
    ),
    "portHopping": MessageLookupByLibrary.simpleMessage("Saut de port"),
    "portTip": m104,
    "portValue": m105,
    "ports": MessageLookupByLibrary.simpleMessage("Ports"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("Clé prépartagée"),
    "preferred": MessageLookupByLibrary.simpleMessage("Préféré"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Prérequis"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Appuyez sur une combinaison de touches",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Aperçu"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("Lecture seule"),
    "previousMatch": MessageLookupByLibrary.simpleMessage("Résultat précédent"),
    "privateKey": MessageLookupByLibrary.simpleMessage("Clé privée"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage(
      "Phrase secrète de la clé privée",
    ),
    "process": MessageLookupByLibrary.simpleMessage("Processus"),
    "profile": MessageLookupByLibrary.simpleMessage("Profil"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Créer des proxys, groupes et règles locaux",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Copiez le lien depuis votre espace client",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "Les imports sont d’abord validés. Une erreur d’analyse ne remplace pas le profil actif.",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Veuillez saisir un intervalle valide",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Veuillez saisir l’intervalle de mise à jour automatique",
        ),
    "profileDaysLeft": m106,
    "profileExpiresIn": m107,
    "profileExpiryNotifications": MessageLookupByLibrary.simpleMessage(
      "Alertes d’expiration et de consommation",
    ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Le profil a été modifié. Désactiver la mise à jour automatique ?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir le nom du profil",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage(
      "Aperçu de la configuration",
    ),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "S’applique uniquement à ce profil ; tout ce qui n’est pas ajouté utilise la valeur par défaut.",
    ),
    "profileShowPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Afficher les informations du forfait sur l’accueil",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "Le changement prend effet immédiatement ; en cas d’échec de l’analyse, la configuration actuelle est conservée.",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "S’applique uniquement à ce profil et prime sur les entrées de remplacement TUN des réglages réseau.",
    ),
    "profileUpdatedAt": m108,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir une URL de profil valide",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Veuillez saisir l’URL du profil",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Profils"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Trier les profils"),
    "project": MessageLookupByLibrary.simpleMessage("Projet"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocole"),
    "protocolParam": MessageLookupByLibrary.simpleMessage(
      "Paramètre du protocole",
    ),
    "protocolVersion": MessageLookupByLibrary.simpleMessage(
      "Version du protocole",
    ),
    "providerCount": m109,
    "providerInUse": m110,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Seuls les fournisseurs distants sont pris en charge",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("Ressources externes"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxys"),
    "proxiesCount": m111,
    "proxiesProfileLabel": m112,
    "proxiesRemovedTip": m113,
    "proxiesReplacedTip": m114,
    "proxyAvailability": m115,
    "proxyChains": MessageLookupByLibrary.simpleMessage("Chaîne de proxys"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Groupe de proxys"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Le groupe de proxys est vide",
    ),
    "proxyGroupInUse": m116,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "Les groupes s’affichent ici une fois le cœur démarré",
    ),
    "proxyGroupsCount": m117,
    "proxyProviders": MessageLookupByLibrary.simpleMessage(
      "Fournisseurs de proxys",
    ),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Sert uniquement à résoudre les noms des serveurs proxy.",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Les noms de serveurs proxy correspondants utilisent le serveur DNS indiqué ici plutôt que Proxy Server Nameserver.",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Type de proxy"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Nettoyer le cache"),
    "publicKey": MessageLookupByLibrary.simpleMessage("Clé publique"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Noir pur"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Mode noir pur"),
    "qrcode": MessageLookupByLibrary.simpleMessage("Code QR"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scannez un code QR pour obtenir un profil",
    ),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "Ce lien est trop long pour un code QR. Utilisez Copier le lien.",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("Actions rapides"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Modification rapide"),
    "quickLines": MessageLookupByLibrary.simpleMessage("Lignes rapides"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage(
      "Requêtes DNS récentes",
    ),
    "recentRequests": MessageLookupByLibrary.simpleMessage("Requêtes récentes"),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("Suggestions"),
    "recordType": MessageLookupByLibrary.simpleMessage("Type d’enregistrement"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Port Redir"),
    "redo": MessageLookupByLibrary.simpleMessage("Rétablir"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage(
      "Régénérer le certificat",
    ),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "Le nouveau certificat remplace l’actuel, que 天机云 retire des racines de confiance de cet appareil quand il le peut. Chaque autre appareil qui fait confiance à l’actuel doit installer le nouveau.",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("Regex"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Libérer la mémoire"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la libération de la mémoire",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Distant"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Destination distante",
    ),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage(
      "Résolution DNS distante",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Retirer"),
    "rename": MessageLookupByLibrary.simpleMessage("Renommer"),
    "renew": MessageLookupByLibrary.simpleMessage("Renouveler"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Renouveler / changer de forfait",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("Remplacer"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Tout remplacer"),
    "request": MessageLookupByLibrary.simpleMessage("Requête"),
    "requestBody": MessageLookupByLibrary.simpleMessage("Corps de la requête"),
    "requestHeaders": MessageLookupByLibrary.simpleMessage(
      "En-têtes de requête",
    ),
    "requests": MessageLookupByLibrary.simpleMessage("Requêtes"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Requêtes et mises à jour",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Obligatoire"),
    "reset": MessageLookupByLibrary.simpleMessage("Réinitialiser"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "Cette page contient des modifications. Voulez-vous vraiment réinitialiser ?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment réinitialiser ?",
    ),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "Une fois connecté, le trafic nécessitant un proxy utilise cette ligne.",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible d’appliquer cette ligne. Réessayez ou choisissez une autre ligne.",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("Application…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "Vidéos et gros téléchargements passent par les lignes ordinaires, sans consommer le trafic résidentiel.",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Contournement des gros transferts non confirmé ; vidéos et téléchargements peuvent utiliser le trafic résidentiel.",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "Le trafic de l’ordinateur n’est pas pris en charge. Activez le proxy système ou TUN ci-dessous.",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage(
      "Changer de sortie",
    ),
    "residentialChoose": MessageLookupByLibrary.simpleMessage(
      "Choisir la sortie",
    ),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "Choisissez la sortie résidentielle depuis le tableau de bord. Les autres groupes ne peuvent pas la modifier tant que le routage résidentiel est actif.",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "L’IA et les groupes nécessitant un proxy suivront la ligne sélectionnée.",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Choisir une sortie résidentielle",
    ),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "Le trafic proxy par défaut utilise la sortie résidentielle choisie ; le trafic direct suit l’abonnement. Le contournement des gros transferts est indiqué ci-dessous lorsqu’il est actif. Le serveur peut utiliser d’autres sorties pour certaines destinations.",
    ),
    "residentialFollowSelected": MessageLookupByLibrary.simpleMessage(
      "L’IA et les proxys suivent la sortie résidentielle choisie",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "Chargement des lignes résidentielles…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "Lecture des lignes disponibles dans votre abonnement.",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Gérer l’abonnement",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "La sortie résidentielle sélectionnée n’existe plus dans cet abonnement.",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "Le trafic proxy est bloqué jusqu’à ce que vous choisissiez une autre sortie. Le trafic direct en Chine continentale est inchangé.",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage(
      "Aucune ligne résidentielle disponible",
    ),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "Cet abonnement n’a aucune sortie résidentielle utilisable pour le moment. Continuez avec la politique de l’abonnement ou vérifiez le panneau d’abonnement.",
    ),
    "residentialNoticeBody": m118,
    "residentialNoticeChange": MessageLookupByLibrary.simpleMessage(
      "En choisir une autre",
    ),
    "residentialNoticeRetry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "residentialNoticeTitle": MessageLookupByLibrary.simpleMessage(
      "Ligne résidentielle temporairement indisponible",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage(
      "Sortie résidentielle",
    ),
    "residentialPageExplanation": MessageLookupByLibrary.simpleMessage(
      "Après le changement, les groupes qui passent par le proxy sortent aussitôt par la ligne résidentielle choisie et les connexions se rétablissent brièvement ; le trafic de Chine continentale et direct suit toujours l\'abonnement. Certaines destinations peuvent utiliser une sortie de remplacement côté serveur.",
    ),
    "residentialPending": MessageLookupByLibrary.simpleMessage(
      "Changement de ligne en cours. Veuillez patienter.",
    ),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "La nouvelle sortie est active, mais les connexions existantes n’ont pas pu être fermées. Elles peuvent conserver l’ancienne sortie jusqu’à la reconnexion.",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "La carte IP affiche la sortie pour sa destination de test actuelle, pas une sortie unique pour tous les sites.",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("Sélectionnée"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "Politique de l’abonnement",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage(
      "Sortie résidentielle",
    ),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage(
      "Indisponible",
    ),
    "residentialUseExit": m119,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage(
      "Utiliser la politique de l’abonnement",
    ),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "Aucune sortie résidentielle n’est sélectionnée. Le trafic proxy suit la politique de l’abonnement.",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalle de mise à jour automatique",
    ),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "L’intervalle de mise à jour automatique doit être supérieur à 0",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Ressources"),
    "respectRules": MessageLookupByLibrary.simpleMessage(
      "Respecter les règles",
    ),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Respecter les règles fait passer les connexions DNS selon les règles et nécessite un Proxy Server Nameserver.",
    ),
    "response": MessageLookupByLibrary.simpleMessage("Réponse"),
    "responseBody": MessageLookupByLibrary.simpleMessage("Corps de la réponse"),
    "responseCode": MessageLookupByLibrary.simpleMessage("Code de réponse"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage(
      "En-têtes de réponse",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Redémarrer"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Voulez-vous vraiment redémarrer le cœur ?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restaurer"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Restaurer toutes les données",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restaurer uniquement les profils",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Stratégie de restauration",
    ),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage("Écraser"),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Restauration réussie",
    ),
    "result": MessageLookupByLibrary.simpleMessage("Résultat"),
    "retry": MessageLookupByLibrary.simpleMessage("Réessayer"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Adresses de route"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage(
      "Adresses de route exclues",
    ),
    "routingMark": MessageLookupByLibrary.simpleMessage("Marque de routage"),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "Ressources de routage",
    ),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Détermine le trafic passant par le proxy ou en direct",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Russe"),
    "rule": MessageLookupByLibrary.simpleMessage("Règle"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Règle logique ET",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au domaine complet",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à un mot-clé de domaine",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une regex de domaine",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à un suffixe de domaine",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Correspondance par caractères génériques ; seuls * et ? sont pris en charge",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à la marque DSCP (entrant UDP tproxy uniquement)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à la plage de ports de destination",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au code pays de l’IP",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond aux domaines de Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au nom entrant",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au port entrant",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au type entrant",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au nom d’utilisateur entrant ; séparez plusieurs noms par /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à l’ASN de l’IP",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une plage d’adresses IP ; IP-CIDR6 n’est qu’un alias",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une plage d’adresses IP",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une plage de suffixes d’IP",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à toutes les requêtes, sans condition",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à TCP ou UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Règle logique NON",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage(
      "Règle logique OU",
    ),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au nom du processus ; correspond au nom du paquet sur Android",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond par regex au nom du processus ; correspond au nom du paquet sur Android",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond par caractères génériques au nom du processus ; seuls * et ? sont pris en charge",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au chemin complet du processus",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond par regex au chemin du processus",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond par caractères génériques au chemin du processus ; seuls * et ? sont pris en charge",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au nom de rematch ; séparez plusieurs noms par /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Référence un jeu de règles ; nécessite rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond au code pays de l’IP source",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à l’ASN de l’IP source",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une plage d’adresses IP source",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à une plage de suffixes d’IP source",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à la plage de ports source",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond vers une sous-règle ; attention aux parenthèses",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Correspond à l’ID d’utilisateur Linux",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("La règle est vide"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "Les règles doivent former une liste YAML avec une règle par élément, par exemple - DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent en direct",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Bloquer DNS over TLS",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage(
      "Bloquer le bouclage du proxy",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage("Bloquer QUIC"),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage("Bloquer STUN"),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage(
      "LAN en direct",
    ),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple et Microsoft en direct",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage(
      "Fournisseurs de règles",
    ),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Jeu de règles"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage(
      "Le jeu de règles ne contient aucune entrée exploitable",
    ),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Ce fichier mrs est illisible",
    ),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "Le jeu de règles mélange des domaines et des plages d’IP : son type est indéterminable",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Cible de la règle"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "La règle doit commencer par un type pris en charge, par exemple DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("Règles"),
    "rulesCount": m120,
    "runTime": MessageLookupByLibrary.simpleMessage("Durée d’exécution"),
    "running": MessageLookupByLibrary.simpleMessage("En cours d’exécution"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage(
      "Configuration d’exécution",
    ),
    "safeMode": MessageLookupByLibrary.simpleMessage("Mode sans échec"),
    "safeModeAppTitle": m121,
    "saturation": MessageLookupByLibrary.simpleMessage("Saturation"),
    "save": MessageLookupByLibrary.simpleMessage("Enregistrer"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "Enregistrer les modifications ?",
    ),
    "scene": MessageLookupByLibrary.simpleMessage("Scène"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("IA"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "Les services d’IA passent par les routes du mode IA ; le trafic vers la Chine continentale reste direct",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("Quotidien"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "Le trafic volumineux contourne automatiquement la sortie résidentielle ; le trafic vers la Chine continentale reste direct",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage(
      "Le trafic vers la Chine continentale reste direct",
    ),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage(
      "Scènes en pause en mode résidentiel",
    ),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage(
      "Scènes indisponibles",
    ),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "Cet abonnement n’a pas encore de groupes de scènes. Contactez le support ou gérez le routage depuis la page Proxies.",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Certaines règles n’ont pas pu être basculées",
    ),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("Streaming"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "Le streaming passe par les routes du mode vidéo ; le trafic vers la Chine continentale reste direct",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Mode script : réécrit tout le profil avec un script d’extension",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Défiler jusqu’à la sélection",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Rechercher"),
    "seconds": MessageLookupByLibrary.simpleMessage("secondes"),
    "secondsCount": m122,
    "secretKey": MessageLookupByLibrary.simpleMessage("Clé"),
    "sectionsInEffect": m123,
    "select": MessageLookupByLibrary.simpleMessage("Sélectionner"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Tout sélectionner"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner un jeu de règles",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Veuillez sélectionner une stratégie de répartition",
    ),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage(
      "Vérification de la sortie…",
    ),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "Ce groupe automatique a choisi un autre nœud. Sélectionnez un nœud manuellement pour le fixer.",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "Le trafic de cet appareil n’est pas encore pris en charge. Activez le proxy système ou TUN ci-dessous.",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage(
      "Vérifier à nouveau",
    ),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "La ligne résidentielle contrôle le trafic proxy. Changez-la dans sa carte ou revenez au routage de l’abonnement.",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "La sortie diffère de votre choix. La cause n’a pas pu être confirmée. Réessayez.",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "La sortie diffère de votre choix. Vérification de la cause…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("Envoyer"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage(
      "Envoyer depuis le téléphone",
    ),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Importer le lien envoyé depuis le téléphone ?",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "Cet appareil n\'est connecté à aucun réseau local",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "Lien d\'abonnement ou lien de partage de proxy",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "Envoyé. Confirmez l\'importation sur l\'autre appareil.",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage(
      "Envoyer un lien à 天机云",
    ),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Pour recevoir un lien depuis le téléphone, 天机云 a besoin de l\'autorisation Appareils à proximité, qui lui donne accès au réseau local. Activez-la dans les paramètres de l\'application.",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "Scannez le code avec l\'appareil photo du téléphone, puis collez le lien dans la page qui s\'ouvre. Les deux appareils doivent être sur le même réseau.",
    ),
    "server": MessageLookupByLibrary.simpleMessage("Serveur"),
    "serviceAbnormalCount": m124,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage(
      "Tout est disponible",
    ),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Bloqué"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Tout vérifier"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage(
      "Bientôt disponible",
    ),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "FAI non autorisé",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la vérification",
    ),
    "serviceManage": MessageLookupByLibrary.simpleMessage("Gérer les services"),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Contenus originaux uniquement",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Non vérifié"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Accès restreint",
    ),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage(
      "Affiché sur le tableau de bord",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("État des services"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("Indisponible"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Région non prise en charge",
    ),
    "settingEntries": MessageLookupByLibrary.simpleMessage("réglages"),
    "settings": MessageLookupByLibrary.simpleMessage("Paramètres"),
    "settingsCount": m125,
    "shareLinkUnreadable": m126,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage(
      "Aucun proxy n’a pu être lu dans les liens",
    ),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "Scannez avec 天机云 sur un autre appareil pour importer ce profil.",
    ),
    "show": MessageLookupByLibrary.simpleMessage("Afficher"),
    "showLess": MessageLookupByLibrary.simpleMessage("Réduire"),
    "showMore": MessageLookupByLibrary.simpleMessage("Développer"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Bouton Arrêter dans la notification",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage(
      "Afficher le mot de passe",
    ),
    "sidebar": MessageLookupByLibrary.simpleMessage("Barre latérale"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage(
      "Lancement silencieux",
    ),
    "singleImport": MessageLookupByLibrary.simpleMessage("Importation unique"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "Saisissez un seul lien ici ; pour en modifier plusieurs, utilisez la modification rapide de la liste",
    ),
    "singleValueTip": m127,
    "size": MessageLookupByLibrary.simpleMessage("Taille"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage(
      "Ignorer la vérification du certificat",
    ),
    "skipDomain": MessageLookupByLibrary.simpleMessage("Domaines ignorés"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage(
      "Adresses de destination ignorées",
    ),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage(
      "Ignorer la vérification du certificat serveur",
    ),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage(
      "Adresses sources ignorées",
    ),
    "slide": MessageLookupByLibrary.simpleMessage("Glissement"),
    "sliders": MessageLookupByLibrary.simpleMessage("Curseurs"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("Protocoles"),
    "sniffer": MessageLookupByLibrary.simpleMessage("Sniffer"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Port SOCKS"),
    "softStyle": MessageLookupByLibrary.simpleMessage("Doux"),
    "sort": MessageLookupByLibrary.simpleMessage("Trier"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("IP source"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Proxy spécial"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Règles spéciales"),
    "spectrum": MessageLookupByLibrary.simpleMessage("Spectre"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Statistiques de débit",
    ),
    "splitStrategy": MessageLookupByLibrary.simpleMessage(
      "Stratégie de répartition",
    ),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "La stratégie de répartition ne peut pas être vide",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("Les SSID sont vides"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Mode de pile"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("Trace de pile"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Mode standard : ajoute des règles par-dessus le profil",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Démarrer"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("Partir de zéro"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Démarrage du VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Démarrage et arrière-plan",
    ),
    "status": MessageLookupByLibrary.simpleMessage("État"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "Si DNS est désactivé, le DNS du système est utilisé.",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Arrêter"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage(
      "Arrêter le téléchargement de la mise à jour ?",
    ),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Arrêt du VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Stratégie"),
    "strictRoute": MessageLookupByLibrary.simpleMessage("Route stricte"),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "La route stricte empêche le trafic tel que le DNS de contourner TUN et, avec IPv6 désactivé, bloque les connexions IPv6 de cet appareil.",
    ),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "submit": MessageLookupByLibrary.simpleMessage("Valider"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("Détails"),
    "subscriptionExpiryNoticeBody": m128,
    "subscriptionExpiryNoticeTitle": m129,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Infos d’abonnement",
    ),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Lien d’abonnement",
    ),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Saisissez votre mot de passe pour sudo",
    ),
    "suspended": MessageLookupByLibrary.simpleMessage("Suspendu…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Changer de profil"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("Basculer"),
    "sync": MessageLookupByLibrary.simpleMessage("Synchroniser"),
    "system": MessageLookupByLibrary.simpleMessage("Système"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Apps système"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Proxy système"),
    "systemService": MessageLookupByLibrary.simpleMessage("Service système"),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("Anomalie"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "S’exécute avec les droits administrateur pour configurer et restaurer l’adaptateur virtuel, les routes et le proxy système.",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("Installer"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Non installé",
    ),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("Actualiser"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("Réparer"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Installé et en cours d’exécution",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Onglet"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage(
      "Animation des onglets",
    ),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage(
      "Appuyez sur l’icône pour réessayer",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage(
      "Appuyez pour autoriser",
    ),
    "target": MessageLookupByLibrary.simpleMessage("Cible"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP simultané"),
    "testInterval": MessageLookupByLibrary.simpleMessage("Intervalle de test"),
    "testUrl": MessageLookupByLibrary.simpleMessage("URL de test"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage(
      "Tester à l’utilisation",
    ),
    "textScale": MessageLookupByLibrary.simpleMessage("Taille du texte"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Le texte de l’app ressemblera à ceci",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Thème"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Couleur du thème"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Mode du thème"),
    "tight": MessageLookupByLibrary.simpleMessage("Serrée"),
    "time": MessageLookupByLibrary.simpleMessage("Heure"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage(
      "Délai du premier octet",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage("Expiré"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("Teinté"),
    "tip": MessageLookupByLibrary.simpleMessage("Astuce"),
    "toggle": MessageLookupByLibrary.simpleMessage("Basculer"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Tolérance"),
    "tools": MessageLookupByLibrary.simpleMessage("Outils"),
    "torch": MessageLookupByLibrary.simpleMessage("Lampe torche"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("Reçu"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Trafic total"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("Envoyé"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Port TProxy"),
    "traffic": MessageLookupByLibrary.simpleMessage("Trafic"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage(
      "Direct vers la Chine ce mois-ci",
    ),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage(
      "Direct (région non confirmée)",
    ),
    "trafficPeak": m130,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage(
      "Économisé ce mois",
    ),
    "trafficStats": MessageLookupByLibrary.simpleMessage(
      "Statistiques de trafic",
    ),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Trafic direct en Chine continentale, trafic VPN et trafic proxy économisé ce mois-ci sur cet appareil.",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "Cet appareil uniquement, ce mois-ci. Seul le trafic capturé par l\'application est compté.",
    ),
    "trafficTotal": m131,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Trafic utilisé"),
    "transport": MessageLookupByLibrary.simpleMessage("Transport"),
    "transportHeaders": m132,
    "trayCopyProxyCommand": MessageLookupByLibrary.simpleMessage(
      "Copier la commande proxy du terminal",
    ),
    "trayDisconnect": MessageLookupByLibrary.simpleMessage("Déconnecter"),
    "trayNotConnected": MessageLookupByLibrary.simpleMessage("Non connecté"),
    "trayOpenApp": MessageLookupByLibrary.simpleMessage("Ouvrir Tianji Cloud…"),
    "trayPreferences": MessageLookupByLibrary.simpleMessage("Préférences"),
    "trayShowMainWindow": MessageLookupByLibrary.simpleMessage(
      "Afficher la fenêtre principale",
    ),
    "trayTun": MessageLookupByLibrary.simpleMessage(
      "Adaptateur réseau virtuel (TUN)",
    ),
    "trustCertificate": MessageLookupByLibrary.simpleMessage(
      "Approuver le certificat",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "TUN n’a pas pu être autorisé et a donc été désactivé.",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "TUN ne fonctionne qu’en mode administrateur.",
    ),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Les entrées ajoutées ici remplacent les réglages TUN de tous les profils ; tout ce qui n’est pas ajouté garde le réglage du profil. Les entrées qu’un profil personnalisé ajoute lui-même priment.",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Désactiver"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Activer"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage("Mode de relais UDP"),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("Délai UDP"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "Le délai UDP est en secondes et ne fonctionne qu’avec les piles gvisor, system et mixed.",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("Ultra"),
    "undo": MessageLookupByLibrary.simpleMessage("Annuler"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Délai unifié"),
    "unknown": MessageLookupByLibrary.simpleMessage("Inconnu"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Erreur réseau inconnue",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Restaurer"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Sans nom"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage(
      "Désépingler la fenêtre",
    ),
    "update": MessageLookupByLibrary.simpleMessage("Mettre à jour"),
    "updateAll": MessageLookupByLibrary.simpleMessage("Tout mettre à jour"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible de télécharger la mise à jour.",
    ),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "Téléchargement de la mise à jour lancé. Suivez la progression sur le tableau de bord.",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage(
      "Test de téléchargement de mise à jour",
    ),
    "updateFailed": MessageLookupByLibrary.simpleMessage(
      "Échec de la mise à jour",
    ),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "Impossible d\'installer la mise à jour. Vous pouvez la télécharger depuis la page de publication.",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage(
      "La mise à jour téléchargée n\'a pas pu être vérifiée.",
    ),
    "updateReady": MessageLookupByLibrary.simpleMessage("Mise à jour prête"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage(
      "La mise à jour est téléchargée. Touchez pour l’installer.",
    ),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "天机云 se ferme pour installer la mise à jour et se rouvre une fois terminée.",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Envoi"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Bande passante d’envoi",
    ),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("Réécriture d’URL"),
    "urlTip": m133,
    "useHosts": MessageLookupByLibrary.simpleMessage("Utiliser hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Utiliser les hosts du système",
    ),
    "usedShort": MessageLookupByLibrary.simpleMessage("utilisé"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("Trafic utilisé"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "username": MessageLookupByLibrary.simpleMessage("Nom d’utilisateur"),
    "validUntil": m134,
    "value": MessageLookupByLibrary.simpleMessage("Valeur"),
    "view": MessageLookupByLibrary.simpleMessage("Afficher"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Tout afficher"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("IPv4 virtuelle"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("Vif"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "La configuration liée au VPN a changé. Appuyez pour redémarrer",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Configuration WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Mode liste blanche"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage(
      "Écrire dans le système",
    ),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "Écrire dans le système règle aussi l’horloge système ; Android l’ignore.",
    ),
    "yearsAgo": m135,
    "yearsAgoShort": m136,
    "yes": MessageLookupByLibrary.simpleMessage("Oui"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Chinois simplifié"),
    "zzAutoUpdateHours": m137,
    "zzAutoUpdateIntervalLabel": m138,
    "zzExpiryDate": m139,
    "zzProfileBasedOnOverrides": m140,
    "zzProfileExpiredDays": m141,
    "zzProfileImportHint": m142,
    "zzProfileImportedOn": m143,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("Presse-papiers"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("Fichier local"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("Scanner"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("Restant"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("jours"),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage(
      "Renouveler / améliorer",
    ),
    "zzTotalQuota": m144,
  };
}
