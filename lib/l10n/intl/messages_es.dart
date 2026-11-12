// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es locale. All the
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
  String get localeName => 'es';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} seleccionada', other: '${count} seleccionadas')}";

  static String m1(name) => "${name} añadido a proxies locales";

  static String m2(name) => "${name} ya está en proxies locales";

  static String m3(count, skipped) =>
      "${count} por añadir, ${skipped} omitidos por ya existir";

  static String m4(time) => "Comprobado a las ${time}";

  static String m5(line) => "El tráfico saldrá por «${line}»";

  static String m6(name, status) => "Actual: ${name} · ${status}";

  static String m7(actual, expected) =>
      "La salida está en ${actual}, mientras que la línea seleccionada está en ${expected}";

  static String m8(name, ip) =>
      "La línea « ${name} » coincide con la salida ${ip}";

  static String m9(date) => "Vence el ${date}";

  static String m10(month, day) => "${day}/${month}";

  static String m11(date) =>
      "El plan vence el ${date}. Renueva para mantener tus líneas";

  static String m12(value) => "Multiplicador ${value}×";

  static String m13(days) => "Caducó hace ${days} días";

  static String m14(date) =>
      "El plan caducó el ${date}. Renueva y vuelve a validar el mismo enlace.";

  static String m15(step, total) =>
      "Paso ${step} de ${total} · Validar suscripción";

  static String m16(count) => "Marcadas · ${count}";

  static String m17(count) => "${count} aplicaciones seleccionadas";

  static String m18(name) =>
      "El grupo residencial está bloqueado en «${name}». Cámbialo en las líneas residenciales.";

  static String m19(time) => "Suscripción actualizada ${time}";

  static String m20(categories) =>
      "Salida directa del centro de datos para: ${categories}";

  static String m21(count) => "${count} aplicaciones";

  static String m22(count) => "${count} aprobadas";

  static String m23(count) => "${count} solicitudes";

  static String m24(version) => "Nueva versión disponible: ${version}";

  static String m25(percent) => "${percent} % usado";

  static String m26(count) => "Reglas Wi-Fi: ${count}";

  static String m27(detail) => "No se pudieron borrar los datos: ${detail}";

  static String m28(count, download, upload) =>
      "Total: ${count} conexiones · Descarga ${download} · Subida ${upload} · Selecciona una fila para ver la ruta completa y la regla coincidente";

  static String m29(code) =>
      "Windows se negó a ejecutar TianjiCloudCore.exe (error ${code}). Una directiva de control de aplicaciones, como Smart App Control o AppLocker, bloquea los programas sin firmar; permite 天机云 en esa directiva o desactívala e inténtalo de nuevo.";

  static String m30(name) =>
      "La app no pudo terminar de iniciarse dos veces seguidas. Para romper el ciclo, se ha deseleccionado el perfil ${name} y se ha omitido la configuración automática. Puedes volver a seleccionarlo en cualquier momento.";

  static String m31(url) => "¿Quieres crear un perfil a partir de ${url}?";

  static String m32(members, count) => "${members} y ${count} más";

  static String m33(count) => "Usado por ${count} reglas";

  static String m34(count, label) =>
      "${Intl.plural(count, one: 'Se descartó 1 regla SUB-RULE, porque los perfiles personalizados no admiten subreglas', other: 'Se descartaron ${label} reglas SUB-RULE, porque los perfiles personalizados no admiten subreglas')}";

  static String m35(message) =>
      "El núcleo no puede interpretar este proxy: ${message}";

  static String m36(proxy, target) =>
      "${proxy} marca a través de ${target}, que lleva de vuelta a ${proxy}, por lo que la marcación entra en bucle";

  static String m37(name) =>
      "El nombre ${name} ya lo usa otro proxy o grupo de proxies";

  static String m38(path) =>
      "Los grupos de proxies se referencian entre sí en bucle: ${path}";

  static String m39(name) =>
      "El respaldo si está vacío debe ser un proxy, pero ${name} no existe o es un grupo de proxies";

  static String m40(name, message) =>
      "${name} no es una expresión regular válida: ${message}";

  static String m41(name) => "El proxy de marcación ${name} no existe";

  static String m42(names) =>
      "Estos proveedores de proxies no existen: ${names}";

  static String m43(names) => "Estos proxies o políticas no existen: ${names}";

  static String m44(name) =>
      "${name} es un nombre de política integrada y no se puede usar aquí";

  static String m45(count) =>
      "${count} elementos tienen problemas, y aplicar este perfil puede fallar";

  static String m46(count) => "Usado en ${count} grupos";

  static String m47(count) =>
      "${Intl.plural(count, one: 'hace 1 día', other: 'hace ${count} días')}";

  static String m48(count) => "${Intl.plural(count, other: 'hace ${count} d')}";

  static String m49(label) =>
      "¿Seguro que quieres eliminar los elementos seleccionados (${label})?";

  static String m50(label) =>
      "¿Seguro que quieres eliminar este elemento (${label})?";

  static String m51(hours) =>
      "Los recursos comprueban si hay actualizaciones cada ${hours} horas; si falla una descarga, se conserva la versión anterior.";

  static String m52(label) => "Detalles de ${label}";

  static String m53(name) =>
      "La marcación a través de ${name} lleva de vuelta al proxy que lo usa, por lo que se detuvo la conexión";

  static String m54(label) => "${label} no puede estar vacío";

  static String m55(label) => "${label} ya existe";

  static String m56(count) => "${count} elementos fallaron. Toca para ver";

  static String m57(label, message) => "${label}: ${message}";

  static String m58(name) => "${name} ya está actualizado";

  static String m59(name) => "${name} actualizado";

  static String m60(count) =>
      "${Intl.plural(count, one: '1 grupo', other: '${count} grupos')}";

  static String m61(count) => "${count} sin respuesta";

  static String m62(action) => "Ya lo usa “${action}”. Elige otro atajo.";

  static String m63(modifiers) =>
      "Incluye al menos una de estas teclas: ${modifiers}";

  static String m64(count) =>
      "${Intl.plural(count, one: 'hace 1 hora', other: 'hace ${count} horas')}";

  static String m65(count) => "${Intl.plural(count, other: 'hace ${count} h')}";

  static String m66(encoding) =>
      "No se pudo decodificar ${encoding}, así que se muestran los datos tal como se enviaron.";

  static String m67(memory, body) =>
      "Los registros más antiguos se eliminan primero al alcanzar este número u ocupar ${memory} de memoria. De cada cuerpo se conservan solo los primeros ${body}.";

  static String m68(invalid, total) => "${invalid} de ${total} no válidos";

  static String m69(target) => "${target} no es una política válida";

  static String m70(proxyName) => "${proxyName} no es un proxy válido";

  static String m71(providerName) =>
      "${providerName} no es un proveedor de proxies válido";

  static String m72(ruleSet) => "${ruleSet} no es un conjunto de reglas válido";

  static String m73(subRule) => "${subRule} no es una SUB_RULE válida";

  static String m74(count) =>
      "${Intl.plural(count, one: '1 elemento', other: '${count} elementos')}";

  static String m75(line, message) => "Línea ${line}: ${message}";

  static String m76(appName) =>
      "1. Abre Ajustes del sistema > Privacidad y seguridad\n2. Elige Servicios de localización\n3. Busca ${appName} en la lista y márcalo\n\nCuando termines, vuelve a la app para continuar. Gracias por tu colaboración.";

  static String m77(label, max) =>
      "${label} debe tener como máximo ${max} caracteres";

  static String m78(size) => "Liberado: ${size}";

  static String m79(count) =>
      "${Intl.plural(count, one: 'hace 1 minuto', other: 'hace ${count} minutos')}";

  static String m80(count) =>
      "${Intl.plural(count, other: 'hace ${count} min')}";

  static String m81(fileName) =>
      "Se guardó ${fileName} en Descargas. Instálalo en Ajustes › Seguridad › Cifrado y credenciales › Instalar un certificado › Certificado de CA.";

  static String m82(command) =>
      "Chrome y Firefox tienen sus propios almacenes de certificados, que necesitan certutil: ${command}";

  static String m83(host) =>
      "¿Añadir ${host} a la lista de nombres de host? 天机云 podrá leer lo que se le envíe, incluidas cookies y contraseñas.";

  static String m84(host) =>
      "¿Añadir -${host} al principio de la lista de nombres de host? El host ya no se descifrará nunca.";

  static String m85(size) => "El archivo supera los ${size} MB";

  static String m86(stores) => "Aún no está en: ${stores}";

  static String m87(name) =>
      "Los scripts de ${name} han cambiado y se ha desactivado";

  static String m88(system) =>
      "Escrito para ${system}; algunas líneas pueden no coincidir con las apps de este dispositivo.";

  static String m89(name) =>
      "No se pudo quitar el certificado antiguo, ${name}. Quítalo tú de las raíces de confianza.";

  static String m90(name) =>
      "El certificado antiguo, ${name}, sigue entre los certificados de confianza del sistema. Permite el acceso root a 天机云 en tu gestor de root y vuelve a generarlo, o elimina allí el módulo «TianjiCloud MITM CA» y reinicia.";

  static String m91(name) =>
      "Quita el certificado antiguo, ${name}, en Ajustes › Seguridad › Cifrado y credenciales › Credenciales de confianza › Usuario, y después instala el nuevo.";

  static String m92(section) => "La sección [${section}] no es compatible";

  static String m93(count) =>
      "${Intl.plural(count, one: 'hace 1 mes', other: 'hace ${count} meses')}";

  static String m94(count) => "${Intl.plural(count, other: 'hace ${count} m')}";

  static String m95(code) =>
      "El servidor denegó el acceso (HTTP ${code}). Puede que el enlace haya caducado o que las credenciales sean incorrectas";

  static String m96(code) => "El servidor rechazó la solicitud (HTTP ${code})";

  static String m97(code) =>
      "No se encontró nada en esta dirección (HTTP ${code}). Comprueba que la URL sea correcta";

  static String m98(detail) => "Falló la solicitud de red: ${detail}";

  static String m99(code) =>
      "El servidor tuvo un problema (HTTP ${code}). Inténtalo de nuevo más tarde";

  static String m100(label) => "Aún no hay ningún elemento (${label})";

  static String m101(label, min, max) =>
      "${label} debe estar entre ${min} y ${max}";

  static String m102(label) => "${label} debe ser un número";

  static String m103(count) => "Importado · ${count} nodos";

  static String m104(label) => "${label} debe estar entre 1024 y 49151";

  static String m105(port) => "Puerto ${port}";

  static String m106(days) =>
      "${Intl.plural(days, one: 'Queda 1 día', other: 'Quedan ${days} días')}";

  static String m107(date, days) =>
      "Vence el ${date}, ${Intl.plural(days, one: 'queda 1 día', other: 'quedan ${days} días')}";

  static String m108(time) => "Actualizado ${time}";

  static String m109(count) => "${count} elementos";

  static String m110(label, profiles) =>
      "${label} sigue en uso en ${profiles}, que dejarán de funcionar correctamente si se elimina. ¿Seguro que quieres eliminarlo?";

  static String m111(count, label) =>
      "${Intl.plural(count, one: '1 proxy', other: '${label} proxies')}";

  static String m112(name, count) => "${name} y otros (${count} proxies)";

  static String m113(removed) =>
      "Se eliminarán estos proxies: ${removed}. Una línea cuyo nombre cambió cuenta como un proxy nuevo, y los perfiles personalizados que mencionen los eliminados los marcarán como ausentes. ¿Aplicar de todos modos?";

  static String m114(removed, added) =>
      "Se eliminarán estos proxies: ${removed}. Se añadirán estos: ${added}. Una línea cuyo nombre cambió cuenta como un proxy nuevo, y los perfiles personalizados que mencionen los eliminados los marcarán como ausentes. ¿Aplicar de todos modos?";

  static String m115(available, total) => "Disponibles ${available}/${total}";

  static String m116(label) =>
      "${label} sigue mencionado por reglas, grupos de proxies, proxies de marcación, DNS o NTP de este perfil, que dejarán de funcionar si se elimina. ¿Seguro que quieres eliminarlo?";

  static String m117(count, label) =>
      "${Intl.plural(count, one: '1 grupo de proxies', other: '${label} grupos de proxies')}";

  static String m118(line) =>
      "“${line}” ha fallado 3 comprobaciones seguidas. Comprueba la línea o inténtalo de nuevo.";

  static String m119(name) => "Usar ${name}";

  static String m120(count, label) =>
      "${Intl.plural(count, one: '1 regla', other: '${label} reglas')}";

  static String m121(appName) => "${appName} (Modo seguro)";

  static String m122(count) =>
      "${Intl.plural(count, one: '1 segundo', other: '${count} segundos')}";

  static String m123(count) => "${count} en vigor";

  static String m124(count) =>
      "${Intl.plural(count, one: '1 problema', other: '${count} problemas')}";

  static String m125(count) =>
      "${Intl.plural(count, one: '1 ajuste', other: '${count} ajustes')}";

  static String m126(link) => "No se pudo leer ningún proxy de ${link}";

  static String m127(label) => "${label} debe ser un solo elemento";

  static String m128(name, date) => "${name} · ${date}";

  static String m129(days) => "Tu plan vence en ${days} días";

  static String m130(value) => "Pico: ${value}";

  static String m131(value) => "Total: ${value}";

  static String m132(transport) => "Encabezados ${transport}";

  static String m133(label) => "${label} debe ser una URL";

  static String m134(date) => "Válido hasta el ${date}";

  static String m135(count) =>
      "${Intl.plural(count, one: 'hace 1 año', other: 'hace ${count} años')}";

  static String m136(count) =>
      "${Intl.plural(count, other: 'hace ${count} a')}";

  static String m137(hours) => "actualización automática cada ${hours} horas";

  static String m138(count, unit) =>
      "Actualización automática cada ${count} ${unit}";

  static String m139(date) => "Vence ${date}";

  static String m140(count) =>
      "Basado en la suscripción actual · ${count} reglas sobrescritas";

  static String m141(count) =>
      "Enlace de suscripción · caducó hace ${count} días";

  static String m142(scheme) =>
      "También puedes pegar un enlace del portapapeles, elegir un archivo YAML local o abrir ${scheme} en el navegador para importar un enlace.";

  static String m143(date) => "Archivo local · importado el ${date}";

  static String m144(quota) => "Total ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Acerca de"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Control de acceso"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Solo las apps seleccionadas usan la VPN",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "El control de acceso de apps está desactivado",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Las apps seleccionadas quedan excluidas de la VPN",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("Cuenta"),
    "action": MessageLookupByLibrary.simpleMessage("Acción"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage(
      "Probar la latencia de todos",
    ),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Modo directo"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage("Modo global"),
    "actionMode": MessageLookupByLibrary.simpleMessage("Cambiar modo"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("Proxy del sistema"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Modo regla"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Iniciar/Detener"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Actualizar perfiles",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Mostrar/Ocultar"),
    "add": MessageLookupByLibrary.simpleMessage("Añadir"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Añadir proxy"),
    "addFilters": MessageLookupByLibrary.simpleMessage("Añadir filtros"),
    "addNodes": MessageLookupByLibrary.simpleMessage("Añadir nodos"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Añadir entrada de sobrescritura",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Añadir perfil"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Añadir grupo de proxies",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Añadir regla"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage("Añadir ajuste"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Añadir SSID"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage(
      "Añadir a proxies locales",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Reglas añadidas"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Parámetros adicionales",
    ),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage(
      "Prefijo del nombre",
    ),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage(
      "Sufijo del nombre",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Dirección"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Introduce una dirección WebDAV válida",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Configuración avanzada",
    ),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage(
      "Perfil cifrado",
    ),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage(
      "Clave secreta de age",
    ),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "Este perfil está cifrado con age y necesita una clave secreta de age para descifrarse",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("Aceptar"),
    "all": MessageLookupByLibrary.simpleMessage("Todo"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage(
      "Todos los proxies referenciados",
    ),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Todos los proveedores de proxies referenciados",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Permitir que las apps eludan la VPN",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Permitir LAN"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("IP permitidas"),
    "alreadyInLocalProxies": m2,
    "alreadyLatest": MessageLookupByLibrary.simpleMessage(
      "Ya tienes la última versión",
    ),
    "alwaysOnVpn": MessageLookupByLibrary.simpleMessage("VPN siempre activa"),
    "alwaysOnVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Activa Tianji Yun en los ajustes del sistema",
    ),
    "answers": MessageLookupByLibrary.simpleMessage("Respuestas"),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Control de acceso de apps",
    ),
    "appBackground": MessageLookupByLibrary.simpleMessage("Fondo"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage(
      "Diseño del icono de la app",
    ),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "No hay proxies locales",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Añadir DNS del sistema",
    ),
    "applied": MessageLookupByLibrary.simpleMessage("Aplicado"),
    "applyNow": MessageLookupByLibrary.simpleMessage("Aplicar ahora"),
    "arguments": MessageLookupByLibrary.simpleMessage("Argumentos"),
    "authentication": MessageLookupByLibrary.simpleMessage("Autenticación"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "El proxy del sistema no se aplica mientras la autenticación esté activada.",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Autorizar"),
    "authorized": MessageLookupByLibrary.simpleMessage("Autorizado"),
    "auto": MessageLookupByLibrary.simpleMessage("Automático"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Buscar actualizaciones automáticamente",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Cerrar conexiones automáticamente",
    ),
    "autoInclude": MessageLookupByLibrary.simpleMessage(
      "Incluir automáticamente",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Inicio automático"),
    "autoRoute": MessageLookupByLibrary.simpleMessage("Ruta automática"),
    "autoRun": MessageLookupByLibrary.simpleMessage("Ejecución automática"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "La ejecución automática inicia el proxy al abrir la app.",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Configurar DNS del sistema automáticamente",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage(
      "Actualización automática",
    ),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalo de actualización automática",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Atrás"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("Aurora"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage(
      "Desenfoque de fondo",
    ),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("Globo"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("Montañas"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("Nebulosa"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("Órbita"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("Planeta"),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("Color sólido"),
    "backup": MessageLookupByLibrary.simpleMessage("Copia de seguridad"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Copia de seguridad y restauración",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "Esta copia de seguridad procede de una versión más reciente de la app. Actualiza la app antes de restaurarla",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage(
      "Copia de seguridad completada",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Información básica"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage(
      "Estrategias básicas",
    ),
    "batchImport": MessageLookupByLibrary.simpleMessage("Importar en lote"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage(
      "Un elemento por línea",
    ),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage(
      "Un enlace por línea",
    ),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage(
      "Una URL por línea",
    ),
    "binaryData": MessageLookupByLibrary.simpleMessage("Datos binarios"),
    "bind": MessageLookupByLibrary.simpleMessage("Vincular"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Modo lista negra"),
    "blockQuic": MessageLookupByLibrary.simpleMessage("Bloquear QUIC"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage(
      "Reescritura del cuerpo",
    ),
    "brandName": MessageLookupByLibrary.simpleMessage("Tianji Cloud"),
    "brightness": MessageLookupByLibrary.simpleMessage("Brillo"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage(
      "Acerca de y copias de seguridad",
    ),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage(
      "Panel de usuario y renovación",
    ),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage(
      "Color de énfasis",
    ),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "Red avanzada",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage(
      "Servicios de IA",
    ),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage(
      "Todas las líneas",
    ),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "Permite que ciertas apps no usen la VPN.",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage(
      "Proxy por aplicación",
    ),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage(
      "Autorizar adaptador virtual",
    ),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Se ejecuta en segundo plano al iniciar sesión en Windows",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage(
      "Iniciar al arrancar",
    ),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Usar la línea y el modo anteriores",
    ),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage(
      "Conectar al iniciar",
    ),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage(
      "Prueba automática",
    ),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Guarda tus perfiles y ajustes en un archivo de copia.",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage(
      "Crear copia ahora",
    ),
    "businessCards": MessageLookupByLibrary.simpleMessage("Tarjetas"),
    "businessChangeLine": MessageLookupByLibrary.simpleMessage("Cambiar línea"),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage("Cambiar línea"),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage(
      "Versión del cliente",
    ),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "Versión del cliente instalada",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage(
      "Cerrar todo",
    ),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage(
      "Al cerrar la ventana",
    ),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Conectado · Se detectó un problema",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "Conectado · pulsa para desconectar",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "Conectado · Falló la comprobación de salida",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "Conectado · Salida sin verificar",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage(
      "Copiar información del error",
    ),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("Actual"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage(
      "IP de salida actual",
    ),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage("Línea actual"),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("Nodo actual"),
    "businessDatacenter": MessageLookupByLibrary.simpleMessage(
      "Centro de datos",
    ),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage(
      "Probar velocidad",
    ),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage(
      "Tiempo agotado",
    ),
    "businessDetectedAt": MessageLookupByLibrary.simpleMessage("comprobado"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "Abre diagnósticos y herramientas avanzadas.",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "Estas opciones ayudan a diagnosticar problemas. Normalmente no hace falta cambiarlas.",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "Opciones para desarrolladores",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage(
      "Aceptar y continuar",
    ),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Se muestra al iniciar por primera vez",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage(
      "Lee esto antes de usar",
    ),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage(
      "DNS e inspección",
    ),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("Error"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "Elige cómo se generan las respuestas DNS.",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "No hay servidores DNS personalizados configurados.",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage(
      "Resolución por proxy",
    ),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "Vista previa de recursos de enrutamiento",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage(
      "Servidores DNS",
    ),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("Correcto"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "Lee nombres de host del tráfico compatible.",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage(
      "Activar enrutamiento inteligente",
    ),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage(
      "Prueba estos pasos",
    ),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "Cambia el puerto en Ajustes → Entradas y puertos",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "Cierra el programa que usa el puerto 7890 y vuelve a abrir TianjiCloud",
    ),
    "businessExitAnomaly": MessageLookupByLibrary.simpleMessage(
      "Anomalía de línea; contacte con soporte",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage(
      "Verificación de salida aprobada",
    ),
    "businessExitCountryMismatch": m7,
    "businessExitKindMismatch": MessageLookupByLibrary.simpleMessage(
      "El tipo de salida no coincide con la línea seleccionada",
    ),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "La salida real no coincide con la línea seleccionada",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "La comprobación de salida no devolvió resultados. Es posible que el proxy siga funcionando. Vuelve a intentarlo o ejecuta el diagnóstico.",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "No se pudo confirmar la salida",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "El adaptador virtual no está autorizado. La terminal y algunas aplicaciones no pasan por el proxy y ven tu IP local. Autorízalo una vez para corregirlo.",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage(
      "Conectado · Salida verificada",
    ),
    "businessExitVerifiedDetail": m8,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage(
      "Salida verificada",
    ),
    "businessExpiryDate": m9,
    "businessExpiryDateShort": m10,
    "businessExpiryNotice": m11,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage(
      "Seguir el sistema",
    ),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("Grupos"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage("Bloqueado"),
    "businessHelp": MessageLookupByLibrary.simpleMessage("Ayuda"),
    "businessHome": MessageLookupByLibrary.simpleMessage("Inicio"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage(
      "Selecciona una fila para configurar o cambiar el atajo",
    ),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage(
      "Importar de nuevo",
    ),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("Renovar"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("Bloquear"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage(
      "Reiniciar núcleo",
    ),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo iniciar el núcleo de red",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage(
      "Tiempo activo",
    ),
    "businessLegal": MessageLookupByLibrary.simpleMessage("Información legal"),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("líneas"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo completar el cambio. Reinténtalo.",
    ),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "La selección manual tiene prioridad: la línea elegida será la salida. Se comprobará su IP al cambiar y se indicará el motivo si no coincide.",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "La línea elegida será la salida; su IP se comprobará al cambiar.",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage(
      "Línea predeterminada",
    ),
    "businessLines": MessageLookupByLibrary.simpleMessage("Líneas"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "No se han cargado líneas. Revisa tu suscripción.",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage(
      "Cargando líneas disponibles…",
    ),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage(
      "Exportar a un archivo local",
    ),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage(
      "Puertos locales",
    ),
    "businessLocked": MessageLookupByLibrary.simpleMessage("Bloqueado"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage(
      "Salida bloqueada",
    ),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Conexión directa a China continental",
    ),
    "businessManage": MessageLookupByLibrary.simpleMessage("Gestionar"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage(
      "Selección manual",
    ),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "El icono de la bandeja siempre muestra el estado de conexión",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage(
      "Minimizar en la bandeja",
    ),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "Inspecciona HTTPS con el certificado local.",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM descifra el tráfico HTTPS de los dominios coincidentes. Actívalo solo para módulos de confianza.",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage(
      "Tráfico del mes",
    ),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage("Usado este mes"),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Abre el resto de opciones de interfaz VPN.",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "Más ajustes de VPN",
    ),
    "businessMultiplier": m12,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage("Pila de red"),
    "businessNoExitInfo": MessageLookupByLibrary.simpleMessage(
      "Sin datos de salida",
    ),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage(
      "Sin conexión",
    ),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage(
      "Conexión bajo demanda",
    ),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "Añade una red Wi-Fi para pausar la aplicación al conectarte.",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "Consulta estadísticas en el panel",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "Importa la configuración de la suscripción",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "Consulta el estado de conexión de las líneas",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "Usar otro enlace de suscripción",
    ),
    "businessOnboardingFailedDays": m13,
    "businessOnboardingFailedExpiredDescription": m14,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("Esta suscripción ha caducado"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "Plan",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "El enlace que pegaste",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "Renovar ahora",
    ),
    "businessOnboardingFailedRetainedConfig": MessageLookupByLibrary.simpleMessage(
      "Tu configuración anterior se conserva y el cliente puede seguir funcionando.",
    ),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Volver a validar",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "Estado",
    ),
    "businessOnboardingFailedStep": m15,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "Conéctate a Tianji Cloud en tres pasos",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "Importar y conectar",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "Escanear QR / elegir archivo",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "Pega un enlace de Tianji Cloud",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Enlace de suscripción",
    ),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage(
      "Licencias de código abierto",
    ),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "Basado en FlClash · GPL-3.0",
    ),
    "businessOrdinaryWebExit": MessageLookupByLibrary.simpleMessage(
      "Salida para sitios web habituales",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("Salida"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage(
      "Ajustes sobrescritos",
    ),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "Otro programa está usando el puerto 7890 y TianjiCloud no puede escucharlo. La configuración de red no se ha cambiado; puedes seguir navegando normalmente.",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage(
      "Privacidad · Términos del servicio",
    ),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Actualización automática",
    ),
    "businessProfileAddClipboardRecognized": MessageLookupByLibrary.simpleMessage(
      "Se detectó un enlace de suscripción de Tianji Cloud en el portapapeles.",
    ),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "Añadir reglas a una suscripción existente",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "Configuración personalizada",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage(
      "Archivo local",
    ),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "Copiar desde el panel de usuario",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage(
      "Enlace de suscripción",
    ),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "Más opciones",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "Déjalo vacío para usar el nombre del plan de la suscripción",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "Nombre (opcional)",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage(
      "Importar y verificar",
    ),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage(
      "Añadir suscripción",
    ),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage(
      "Pega el enlace de suscripción",
    ),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Enlace de suscripción",
    ),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "La importación se valida primero. Un error de análisis no sustituirá el perfil activo.",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage(
      "Eliminar esta suscripción",
    ),
    "businessProfileEditDeleteDescription": MessageLookupByLibrary.simpleMessage(
      "Solo elimina esta configuración local. Tu cuenta y plan de Tianji Cloud no se ven afectados.",
    ),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Eliminar suscripción",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage("Caduca"),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("Sobrescrituras activas: "),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " elementos",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "Sobrescrituras y scripts",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " grupos",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("Ocultar"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage(
      "Líneas",
    ),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage(
      "Administrar",
    ),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("Abrir"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("Plan"),
    "businessProfileEditPreviewDescription": MessageLookupByLibrary.simpleMessage(
      "Vista previa de solo lectura. Usa la configuración personalizada para modificar.",
    ),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "Este enlace contiene un token personal. No lo compartas.",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "Ver configuración original",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage(
      "Renovar / mejorar",
    ),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("Mostrar"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Detalles del plan",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage(
      "Editar suscripción",
    ),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "Arrastra para cambiar el orden. Las suscripciones anteriores aparecen primero en el panel y la bandeja.",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage(
      "Reordenar suscripciones",
    ),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage(
      "Conjuntos de proxy y reglas",
    ),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage(
      "Densidad de tarjetas de proxy",
    ),
    "businessProxyCheckedGroup": m16,
    "businessProxyDnsRemote": MessageLookupByLibrary.simpleMessage(
      "Los dominios del tráfico proxy se resuelven en la línea",
    ),
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage(
      "Iconos de proxy",
    ),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "Los cambios se aplicarán en la próxima conexión",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Conjuntos de proxy",
    ),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage(
      "Reconectar ahora",
    ),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage(
      "Buscar aplicaciones",
    ),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "Omitir proxy para apps marcadas",
    ),
    "businessProxySelectedCount": m17,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "Proxy solo para apps marcadas",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("Proxy"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage(
      "Sin marcar",
    ),
    "businessRecheck": MessageLookupByLibrary.simpleMessage(
      "Verificar de nuevo",
    ),
    "businessRegionAT": MessageLookupByLibrary.simpleMessage("Austria"),
    "businessRegionAU": MessageLookupByLibrary.simpleMessage("Australia"),
    "businessRegionBE": MessageLookupByLibrary.simpleMessage("Bélgica"),
    "businessRegionBR": MessageLookupByLibrary.simpleMessage("Brasil"),
    "businessRegionCA": MessageLookupByLibrary.simpleMessage("Canadá"),
    "businessRegionCO": MessageLookupByLibrary.simpleMessage("Colombia"),
    "businessRegionCZ": MessageLookupByLibrary.simpleMessage("Chequia"),
    "businessRegionDE": MessageLookupByLibrary.simpleMessage("Alemania"),
    "businessRegionFR": MessageLookupByLibrary.simpleMessage("Francia"),
    "businessRegionGB": MessageLookupByLibrary.simpleMessage("Reino Unido"),
    "businessRegionHK": MessageLookupByLibrary.simpleMessage("Hong Kong"),
    "businessRegionIT": MessageLookupByLibrary.simpleMessage("Italia"),
    "businessRegionJP": MessageLookupByLibrary.simpleMessage("Japón"),
    "businessRegionKR": MessageLookupByLibrary.simpleMessage("Corea del Sur"),
    "businessRegionLocalDns": MessageLookupByLibrary.simpleMessage(
      "Los dominios de China continental se resuelven localmente",
    ),
    "businessRegionRO": MessageLookupByLibrary.simpleMessage("Rumanía"),
    "businessRegionSE": MessageLookupByLibrary.simpleMessage("Suecia"),
    "businessRegionSG": MessageLookupByLibrary.simpleMessage("Singapur"),
    "businessRegionTW": MessageLookupByLibrary.simpleMessage("Taiwán"),
    "businessRegionUS": MessageLookupByLibrary.simpleMessage("Estados Unidos"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("Reemplazar"),
    "businessResidential": MessageLookupByLibrary.simpleMessage("Residencial"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "Banda ancha residencial",
    ),
    "businessResidentialLockedHint": m18,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage(
      "Residencial",
    ),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage("Restaurar…"),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "Restaurar desde un archivo o WebDAV",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "Solo cambia la línea predeterminada. La IA y el streaming conservan sus reglas, al igual que las conexiones directas y los bloqueos.",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "El enrutamiento inteligente no está activo. Esta línea predeterminada no se está usando.",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "Administra reglas y proveedores.",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage(
      "Conjuntos de reglas",
    ),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage(
      "Coloca el QR de la suscripción dentro del marco",
    ),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage(
      "Buscar nombre de línea o región",
    ),
    "businessSelected": MessageLookupByLibrary.simpleMessage("Seleccionado"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "La suscripción o el modo cambió. Abre de nuevo la selección.",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage(
      "No requiere inicio de sesión",
    ),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage(
      "Acerca de Tianji Cloud",
    ),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage(
      "Apariencia",
    ),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("General"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS y recursos",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage("Atajos"),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage(
      "Iconos y UA",
    ),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "Entradas y puertos",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "Red (avanzado)",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("Otros"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage(
      "Reglas y sobrescrituras",
    ),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "Inicio y ventana",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage(
      "Adaptador virtual TUN",
    ),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage(
      "Enrutamiento inteligente",
    ),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage(
      "Ordenar por latencia",
    ),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "Elige la pila de red usada por la VPN.",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Actualización automática de suscripción",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Se actualiza cuando cambian las líneas",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "Detalles de la suscripción",
    ),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage(
          "Ajustes DNS proporcionados por esta suscripción.",
        ),
    "businessSubscriptionUpdatedAt": m19,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage(
      "Suscripciones",
    ),
    "businessSubstitutedCategories": m20,
    "businessSwitchMode": MessageLookupByLibrary.simpleMessage("Cambiar modo"),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "Enruta HTTP mediante el proxy del sistema.",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "Proxy del sistema (HTTP)",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Toca para conectar",
    ),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("Probar todo"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage(
      "Apariencia",
    ),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "Apariencia e idioma",
    ),
    "businessToolsApplicationCount": m21,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("Explorar"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "Conexiones y solicitudes",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("General"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage(
      "Conectar directamente dispositivos de la red local",
    ),
    "businessToolsPassedCount": m22,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage(
      "Proxy por aplicación",
    ),
    "businessToolsRequestCount": m23,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "Recursos de enrutamiento",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage(
      "Registros de ejecución",
    ),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "Chino simplificado",
    ),
    "businessTrafficNotOnTianji": MessageLookupByLibrary.simpleMessage(
      "El tráfico no pasa por Tianji",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage(
      "Tráfico de este mes solo en este dispositivo",
    ),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "Acceso directo a impresoras, NAS y otros dispositivos LAN",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage(
      "Enrutar el tráfico de todas las aplicaciones",
    ),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage(
      "Nombre del adaptador",
    ),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage(
      "Rutas excluidas",
    ),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("rutas"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "TCP y UDP usan la pila de espacio de usuario gVisor",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "TCP y UDP usan la pila de red en espacio de usuario mipstack",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("Mixto"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP usa la pila del sistema y UDP gVisor, con amplia compatibilidad",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "TCP y UDP usan la pila de red del sistema operativo",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "El adaptador virtual gestiona todas las aplicaciones, incluidos terminales, juegos y aplicaciones que ignoran el proxy del sistema. El servicio del sistema debe ejecutarse como administrador.",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage(
      "Captura del tráfico",
    ),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage(
      "Interfaz de red virtual (TUN)",
    ),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage(
      "Texto y diseño",
    ),
    "businessUpdateAvailable": m24,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("Cada día"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage("Cada hora"),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage(
      "Cada 12 horas",
    ),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage("Cada 6 horas"),
    "businessUsagePercent": m25,
    "businessVersion": MessageLookupByLibrary.simpleMessage("Versión"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Ver diagnóstico",
    ),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "Permite el acceso a VPN al conectarte por primera vez",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage(
      "Copia de seguridad WebDAV",
    ),
    "businessWifiRulesCount": m26,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Dominios excluidos"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Los dominios excluidos solo se aplican mientras el proxy del sistema esté activado.",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage(
      "Omitir direcciones privadas",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Caché"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage(
      "Algoritmo de caché",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "La caché está dañada. ¿Borrarla?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Tamaño de caché"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Permite el acceso a la cámara en los ajustes del sistema para escanear códigos QR, o elige una imagen de código QR del álbum.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Se requiere permiso de cámara",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Cámara no disponible",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Deseleccionar todo",
    ),
    "cannotSave": MessageLookupByLibrary.simpleMessage("No se puede guardar"),
    "certificate": MessageLookupByLibrary.simpleMessage("Certificado"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "No se pudo cambiar de proxy; se ha restaurado la selección anterior",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Cambios incompatibles",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("Novedades"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("Correcciones"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage("Rendimiento"),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Reversiones"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Verificar certificados TLS",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "Con la verificación TLS desactivada, las suscripciones y las copias de seguridad quedan expuestas a ataques de intermediario.",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage(
      "Buscar actualizaciones",
    ),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "La app ya está actualizada",
    ),
    "checkingExit": MessageLookupByLibrary.simpleMessage(
      "Comprobando la salida…",
    ),
    "chooseFile": MessageLookupByLibrary.simpleMessage("Elegir archivo"),
    "cipher": MessageLookupByLibrary.simpleMessage("Cifrado"),
    "clearData": MessageLookupByLibrary.simpleMessage("Borrar datos"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "Esto elimina todos los perfiles, ajustes y datos locales, y luego cierra la app. Ábrela de nuevo para empezar de cero.",
    ),
    "clearDataFailed": m27,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage(
      "Borrar la caché DNS",
    ),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo borrar la caché DNS",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Borrar búsqueda"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage(
      "Huella del cliente",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Exportar al portapapeles",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Importar desde el portapapeles",
    ),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "No hay nombres de paquete válidos en el portapapeles",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo copiar al portapapeles. Puede que la selección sea demasiado grande",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Cerrar"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage(
      "Cerrar todas las conexiones",
    ),
    "closeConnection": MessageLookupByLibrary.simpleMessage("Cerrar conexión"),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Cerrar conexiones",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("Estilo de color"),
    "columns": MessageLookupByLibrary.simpleMessage("Columnas"),
    "compact": MessageLookupByLibrary.simpleMessage("Compacto"),
    "compatible": MessageLookupByLibrary.simpleMessage(
      "Modo de compatibilidad",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres borrar todos los datos?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres eliminar este grupo de proxies?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres salir de la ventana actual?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres forzar el fallo del núcleo?",
    ),
    "congestionControl": MessageLookupByLibrary.simpleMessage(
      "Control de congestión",
    ),
    "congestionController": MessageLookupByLibrary.simpleMessage(
      "Control de congestión TCP",
    ),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "El control de congestión TCP solo funciona con la pila mips.",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "connecting": MessageLookupByLibrary.simpleMessage("Conectando…"),
    "connection": MessageLookupByLibrary.simpleMessage("Conexión"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage(
      "Añadir una regla para este dominio",
    ),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage("Bloqueado"),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage(
      "Cerrar esta conexión",
    ),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("Grupo"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage(
      "Este dispositivo",
    ),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage(
      "Regla aplicada",
    ),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage(
      "Ruta del proceso",
    ),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage(
      "Buscar dominio, aplicación o regla",
    ),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage(
      "Dominio detectado",
    ),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage(
      "Dirección de origen",
    ),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage(
      "Hora de inicio",
    ),
    "connectionStats": MessageLookupByLibrary.simpleMessage(
      "Estadísticas de conexión",
    ),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Conexiones activas, solicitudes recientes y consultas DNS",
    ),
    "connectionSummary": m28,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("Transcurrido"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage("IP de destino"),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage(
      "Ruta del tráfico",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Conexiones"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage(
      "Conexiones y solicitudes",
    ),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("En vivo"),
    "connectivity": MessageLookupByLibrary.simpleMessage("Conectividad: "),
    "content": MessageLookupByLibrary.simpleMessage("Contenido"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "El contenido no puede estar vacío",
    ),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Controlar las reglas añadidas globales",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copiar"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage("Copiar como Base64"),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("Copiar como cURL"),
    "copyDestination": MessageLookupByLibrary.simpleMessage("Copiar destino"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copiar variables de entorno",
    ),
    "copyHost": MessageLookupByLibrary.simpleMessage("Copiar host"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copiar enlace"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("Copiar solicitud"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("Copiar respuesta"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage(
      "Copiar cuerpo de la respuesta",
    ),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Copiar enlace de suscripción",
    ),
    "copySuccess": MessageLookupByLibrary.simpleMessage(
      "Copiado correctamente",
    ),
    "core": MessageLookupByLibrary.simpleMessage("Núcleo"),
    "coreBlockedByPolicyTip": m29,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Smart App Control de Windows bloqueó TianjiCloudCore.exe porque no está firmado. Abre Seguridad de Windows → Control de aplicaciones y navegador → Configuración de Smart App Control, elige Desactivado y vuelve a iniciar 天机云. Smart App Control no se puede volver a activar sin reinstalar Windows.",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Estado del núcleo"),
    "country": MessageLookupByLibrary.simpleMessage("Región"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Fallo detectado"),
    "crashDetectedTip": m30,
    "crashTest": MessageLookupByLibrary.simpleMessage("Prueba de fallo"),
    "create": MessageLookupByLibrary.simpleMessage("Crear"),
    "createProfileFromUrlTip": m31,
    "creationTime": MessageLookupByLibrary.simpleMessage("Fecha de creación"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("Vence"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage(
      "Contiene el botón de inicio y no se puede quitar",
    ),
    "currentUsage": MessageLookupByLibrary.simpleMessage("Uso del periodo"),
    "custom": MessageLookupByLibrary.simpleMessage("Personalizado"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("Añadir proxy"),
    "customColor": MessageLookupByLibrary.simpleMessage("Color personalizado"),
    "customGroupMemberSummary": m32,
    "customGroupRuleUsage": m33,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("Grupos"),
    "customImportDroppedSubRules": m34,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage(
      "Importar desde un enlace",
    ),
    "customIssueCoreRejected": m35,
    "customIssueDialerLoop": m36,
    "customIssueDuplicateName": m37,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "El nombre está vacío",
    ),
    "customIssueGroupLoop": m38,
    "customIssueInvalidEmptyFallback": m39,
    "customIssueInvalidFilter": m40,
    "customIssueMissingDialer": m41,
    "customIssueMissingProviders": m42,
    "customIssueMissingProxies": m43,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "No hay proxies ni proveedores de proxies seleccionados, por lo que el núcleo rechaza este grupo",
    ),
    "customIssueReservedName": m44,
    "customIssuesSummary": m45,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage(
      "Vista previa de la configuración combinada",
    ),
    "customProfile": MessageLookupByLibrary.simpleMessage("Personalizado"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage(
      "Proveedores y encadenamiento",
    ),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Proxies personalizados",
    ),
    "customProxyGroupUsage": m46,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "Los proxies de la suscripción aparecen junto a estos proxies.",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage(
      "Sin referencias",
    ),
    "customResources": MessageLookupByLibrary.simpleMessage("Personalizado"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("Mis reglas"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage(
      "Añadir desde ajustes preestablecidos",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Cortar"),
    "dark": MessageLookupByLibrary.simpleMessage("Oscuro"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Panel"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage(
      "Disponibles para añadir",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "No se pudo guardar el cambio; se ha revertido",
    ),
    "daysAgo": m47,
    "daysAgoShort": m48,
    "daysUnit": MessageLookupByLibrary.simpleMessage("días"),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage(
      "Descifrar sin confianza local",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Resuelve los nombres de los demás servidores DNS. Solo direcciones IP.",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage(
      "Selección predeterminada",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("Predeterminado"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "La configuración debe ser un mapa YAML con un nombre y un tipo",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("Latencia"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("Fallido"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Prueba de latencia"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage(
      "Tiempo de espera de la prueba de latencia",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Eliminar"),
    "deleteMultipTip": m49,
    "deleteTip": m50,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Un cliente proxy multiplataforma basado en ClashMeta, sencillo de usar, de código abierto y sin anuncios.",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage(
      "Base de datos de sistemas autónomos",
    ),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 es el rango de mapeo fake-IP; la resolución DNS real se realiza en la salida, sin pasar por el ISP local.",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage(
      "Base de datos de ubicación IP",
    ),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage(
      "Base de datos de categorías de dominio",
    ),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage(
      "Actualizado",
    ),
    "desktopResourceUpdateNote": m51,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "Reglas enviadas por la suscripción",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destino"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "GeoIP de destino",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "ASN de la IP de destino",
    ),
    "details": m52,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Depende de una API de terceros; solo con fines informativos",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Modo desarrollador"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "El modo desarrollador está activado.",
    ),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("No superado"),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("Correcto"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("Repetir"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage(
      "Verificación de salida de la ruta predeterminada",
    ),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("Iniciar"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage(
      "Diagnóstico rápido",
    ),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "No están disponibles las comprobaciones de salida DNS, WebRTC del navegador y NTP.",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage(
      "No se pudo comprobar",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage("Proxy de marcación"),
    "dialerProxyLoopStopped": m53,
    "dialog": MessageLookupByLibrary.simpleMessage("Diálogo"),
    "direct": MessageLookupByLibrary.simpleMessage("Directo"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Resuelve los dominios de las conexiones directas.",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage(
      "Desactivar reenvío ICMP",
    ),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "Con el reenvío ICMP desactivado, TUN responde él mismo al ping, por lo que ping ya no muestra la latencia real.",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage(
      "Desactivar keep-alive TCP",
    ),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Desactivar UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Desactivado"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "¿Descartar los cambios?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Aviso legal"),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "Esta declaración explica la naturaleza, los riesgos y las responsabilidades del uso del Software. No es un término adicional a la GPL-3.0 ni limita ninguno de los derechos que esa licencia te otorga, incluidos los de ejecutar, copiar, modificar y distribuir el Software. Si ambas difieren, prevalece la GPL-3.0.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "Relación con la licencia de código abierto",
    ),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "He leído y entiendo esta declaración",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "Para confirmar que lo entiendes, lee la siguiente declaración y marca la casilla de abajo:",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage(
      "Confirma la declaración",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "Esta declaración puede revisarse en versiones posteriores; cada versión incluye la que le corresponde.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Cambios en esta declaración",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Antes de usar 天机云 («el Software»), lee atentamente esta declaración y asegúrate de entenderla. Tocar «Aceptar» significa que has leído y entendido lo que sigue. Si no quieres continuar, toca «Salir».",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "En la máxima medida permitida por la ley aplicable, ni los desarrolladores ni ningún colaborador serán responsables de ningún daño directo, indirecto, incidental, especial, punitivo o emergente derivado del uso o de la imposibilidad de usar el Software, incluidos, entre otros, la pérdida de datos, los daños al dispositivo, los fallos de red, la interrupción de la actividad, el lucro cesante o cualquier disputa legal resultante, incluso si se les hubiera advertido de la posibilidad de tales daños.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Limitación de responsabilidad",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "El Software es de código abierto bajo la licencia GPL-3.0. Según esa licencia puedes ejecutarlo, estudiarlo, modificarlo y distribuirlo; al distribuir el Software o una versión modificada, debes proporcionar también su código fuente bajo GPL-3.0 y conservar los avisos de derechos de autor originales.\n\nLos componentes de terceros del Software, incluido el núcleo Clash.Meta, siguen sus propias licencias. Los autores originales no son responsables de los problemas de las versiones modificadas o distribuidas por otros.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Licencia de código abierto",
    ),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "El Software en sí no proporciona ningún servidor proxy, nodo, suscripción ni servicio de acceso a la red, y no mantiene ninguna relación de asociación, representación ni garantía con ningún proveedor de dichos servicios.",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "El Software no recopila ni sube tus URL de suscripción, los detalles de los nodos, el contenido de las configuraciones, los sitios web visitados, los registros de conexión, el contenido del tráfico ni los registros. Estos datos permanecen en tu dispositivo y los desarrolladores no tienen acceso a ellos.\n\nEl Software solo accede a la red cuando usas una función que lo necesita, como obtener la URL de suscripción que indicaste al actualizar un perfil o conectarse a GitHub al buscar actualizaciones.\n\nEl Software no incluye ningún servicio de analítica ni de informes de fallos en ninguna plataforma.",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Recopilación de datos y privacidad",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "Eres responsable de asegurarte de que el uso del Software sea legal donde vives, y asumes tú solo la responsabilidad legal de todo lo que hagas con él y de sus consecuencias.\n\nLas suscripciones, los nodos y las configuraciones que importas son decisión tuya. Que su origen sea legal, su contenido seguro y su servicio fiable es un asunto entre tú y sus proveedores.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Tu responsabilidad",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage(
      "Escribe la declaración anterior",
    ),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "No coincide con la declaración",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "Para confirmar que lo entiendes, escribe la siguiente declaración completa en el campo de abajo:",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage(
      "Repite la declaración",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "El Software es un cliente proxy de red de código abierto basado en el núcleo Clash.Meta (mihomo). Solo ofrece herramientas locales como la gestión de configuración, el enrutamiento basado en reglas y el reenvío de tráfico.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Naturaleza del software",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Los enlaces de suscripción, los archivos de configuración, los conjuntos de reglas, los scripts, los recursos externos y los enlaces externos los proporcionan terceros. Los desarrolladores no pueden revisar ni garantizar, ni lo hacen, su legalidad, exactitud, seguridad o disponibilidad.\n\nCualquier fuga de datos, pérdida económica, bloqueo de cuenta u otra pérdida causada por contenido de terceros debe resolverse entre tú y el tercero; los desarrolladores no asumen ninguna responsabilidad por ello.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Contenido de terceros",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "Cualquier actividad comercial que alguien realice con el Software, incluida la distribución de pago, la venta en paquete o su uso como parte de un servicio comercial, no tiene relación con los desarrolladores del Software, que no la respaldan, apoyan ni garantizan.\n\nEres responsable de cumplir las leyes del país o región donde te encuentres y asumes las consecuencias de cualquier uso ilegal del Software.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Sobre el uso",
    ),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "El Software se proporciona “tal cual” y “según disponibilidad”, sin garantía de ningún tipo, expresa o implícita, incluidas, entre otras, las garantías de comerciabilidad, idoneidad para un fin concreto, no infracción, disponibilidad ininterrumpida, ausencia de errores o ausencia de vulnerabilidades de seguridad.\n\nLos desarrolladores no garantizan que el Software satisfaga tus necesidades ni que funcione sin interrupciones ni errores.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "Sin garantía",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Desconectado"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Nueva versión disponible",
    ),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("Bloqueado"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage(
      "Caché DNS borrada",
    ),
    "dnsExit": MessageLookupByLibrary.simpleMessage("Salida DNS"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage(
      "Sin resultado disponible",
    ),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("Tratamiento"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "Sin esta entrada, TUN secuestra todas las consultas DNS al puerto 53 (any:53).",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("Secuestro de DNS"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Modo DNS"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Las entradas añadidas aquí sustituyen el DNS de todos los perfiles de URL y de archivo; lo que no añadas conserva el ajuste del propio perfil. Los perfiles personalizados definen su DNS en su contenido.",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("Por proxy"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("Consultas DNS"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "DNS y recursos",
    ),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("DNS ascendente"),
    "docked": MessageLookupByLibrary.simpleMessage("Fija"),
    "domain": MessageLookupByLibrary.simpleMessage("Dominio"),
    "done": MessageLookupByLibrary.simpleMessage("Hecho"),
    "download": MessageLookupByLibrary.simpleMessage("Descarga"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Ancho de banda de descarga",
    ),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Descargando actualización",
    ),
    "duration": MessageLookupByLibrary.simpleMessage("Duración"),
    "edit": MessageLookupByLibrary.simpleMessage("Editar"),
    "editDashboard": MessageLookupByLibrary.simpleMessage("Editar panel"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Editar reglas globales",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Editar proxy"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Editar grupo de proxies",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Editar regla"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Editar SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Editor no disponible",
    ),
    "elapsed": MessageLookupByLibrary.simpleMessage("Tardó"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage(
      "Respaldo si está vacío",
    ),
    "emptyTip": m54,
    "en": MessageLookupByLibrary.simpleMessage("Inglés"),
    "enabled": MessageLookupByLibrary.simpleMessage("Activado"),
    "entries": MessageLookupByLibrary.simpleMessage(" entradas"),
    "error": MessageLookupByLibrary.simpleMessage("Error"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("Detalles del error"),
    "es": MessageLookupByLibrary.simpleMessage("Español"),
    "eventAlerts": MessageLookupByLibrary.simpleMessage("Avisos de eventos"),
    "exclude": MessageLookupByLibrary.simpleMessage(
      "Ocultar de aplicaciones recientes",
    ),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage(
      "Puertos de destino excluidos",
    ),
    "excludeFilter": MessageLookupByLibrary.simpleMessage(
      "Filtro de exclusión",
    ),
    "excludeInterface": MessageLookupByLibrary.simpleMessage(
      "Interfaces excluidas",
    ),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage(
      "Puertos de origen excluidos",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Excluir SSID"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "Al conectarte a una red Wi-Fi con un SSID excluido, el estado de ejecución de la app cambia automáticamente.",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage(
      "ID de usuario excluidos",
    ),
    "existsTip": m55,
    "exit": MessageLookupByLibrary.simpleMessage("Salir"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage(
      "Salir de pantalla completa",
    ),
    "exitNodes": MessageLookupByLibrary.simpleMessage("Nodos de salida"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Estado esperado"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Fecha de vencimiento"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("Caducada"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage(
      "Exportar certificado",
    ),
    "exportFile": MessageLookupByLibrary.simpleMessage("Exportar archivo"),
    "exportHar": MessageLookupByLibrary.simpleMessage("Exportar HAR"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Exportar registros"),
    "exportShort": MessageLookupByLibrary.simpleMessage("Exportar"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage(
      "Exportación completada",
    ),
    "extend": MessageLookupByLibrary.simpleMessage("Extensión"),
    "extendMode": MessageLookupByLibrary.simpleMessage("Modo de extensión"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage(
      "Sobrescrituras y scripts de extensión",
    ),
    "extendScript": MessageLookupByLibrary.simpleMessage("Script de extensión"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Controlador externo",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "El controlador externo permite controlar el núcleo en el puerto 9090.",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage(
      "Clave del controlador externo",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("Enlace externo"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Muy grande"),
    "fade": MessageLookupByLibrary.simpleMessage("Fundido"),
    "failedCount": m56,
    "failedItem": m57,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Filtro Fake-IP"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "Estos dominios reciben su IP real en lugar de una Fake-IP. En modo whitelist, solo ellos reciben Fake-IP.",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Modo de filtro Fake-IP",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Rango Fake-IP"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Rango Fake-IP (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("TTL de Fake-IP"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Se usan en lugar de Nameserver cuando el filtro de respaldo considera contaminada su respuesta.",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage(
      "Filtro de respaldo",
    ),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Estos dominios se resuelven directamente con Fallback.",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Los dominios de estas categorías GeoSite se resuelven directamente con Fallback.",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "Si Nameserver devuelve una IP de estos rangos, se usa la respuesta de Fallback.",
    ),
    "file": MessageLookupByLibrary.simpleMessage("Archivo"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "El archivo se ha modificado. ¿Guardar los cambios?",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Filtro"),
    "filters": MessageLookupByLibrary.simpleMessage("Filtros"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Buscar proceso"),
    "floating": MessageLookupByLibrary.simpleMessage("Flotante"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Seguir perfil"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Seguir el sistema"),
    "followSystemAccent": MessageLookupByLibrary.simpleMessage(
      "Usar el color de énfasis del sistema",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Familia de fuente"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Tamaño"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage("Forzar mapeo DNS"),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "Forzar mapeo DNS también analiza las conexiones cuyo dominio provino de un mapeo DNS.",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage("Forzar dominios"),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Los dominios forzados también se analizan; las demás conexiones que ya tienen dominio se dejan como están.",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres forzar el reinicio del núcleo?",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Francés"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Las entradas añadidas aquí sustituyen el ajuste correspondiente de todos los perfiles; lo que no añadas conserva el ajuste del propio perfil, o el valor predeterminado del núcleo si el perfil no lo define.",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage(
      "Generar certificado",
    ),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m58,
    "geoUpdated": m59,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Modo geo de poca memoria",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Ir"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Descargar"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage(
      "Ir a la configuración de las reglas añadidas",
    ),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Ir a la configuración del script",
    ),
    "grid": MessageLookupByLibrary.simpleMessage("Cuadrícula"),
    "groupBy": MessageLookupByLibrary.simpleMessage("Agrupar por"),
    "groupCount": m60,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("grupos"),
    "groupTimeoutCount": m61,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "¿Guardar los cambios en la caché?",
    ),
    "hashByInUser": MessageLookupByLibrary.simpleMessage(
      "Hash por usuario de entrada",
    ),
    "headerRewrite": MessageLookupByLibrary.simpleMessage(
      "Reescritura de cabeceras",
    ),
    "healthCheck": MessageLookupByLibrary.simpleMessage(
      "Comprobación de estado",
    ),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "El servicio auxiliar (Helper) no está disponible; no se puede activar el modo TUN. Reinstala 天机云 para restaurarlo.",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("Hex"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Ocultar de la lista"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Ocultar IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Ocultar contraseña"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Ocultar proxies sin respuesta",
    ),
    "hopInterval": MessageLookupByLibrary.simpleMessage("Intervalo de salto"),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostname": MessageLookupByLibrary.simpleMessage("Nombre de host"),
    "hotkeyConflictWith": m62,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Los atajos globales funcionan incluso con la ventana oculta. Toca una acción para grabar su combinación de teclas.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Gestión de atajos",
    ),
    "hotkeyNeedsModifier": m63,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Sin asignar"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "No registrado; puede que otra app lo esté usando",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("horas"),
    "hoursAgo": m64,
    "hoursAgoShort": m65,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage(
      "No se registró por falta de memoria.",
    ),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "Leído como Protobuf sin esquema: solo números de campo, y los tipos son supuestos.",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage(
      "Solo se registró el comienzo de este cuerpo.",
    ),
    "httpBodyUndecoded": m66,
    "httpCapture": MessageLookupByLibrary.simpleMessage("Captura HTTP"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "Registra las solicitudes a los hosts indicados en Nombre de host, para verlas en los detalles de la conexión. Los registros solo se guardan en memoria.",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage(
      "Máximo de registros",
    ),
    "httpCaptureLimitDesc": m67,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "No hay ningún host indicado, así que no se registra nada. Añade hosts en Nombre de host, en la página MITM, o desde los detalles de una conexión.",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage(
      "La captura está desactivada",
    ),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "Una solicitud puede llevar cookies, tokens, contraseñas y contenido de formularios. Revisa qué compartes y con quién.",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage(
      "Contiene datos privados",
    ),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage(
      "El registro de esta solicitud se ha borrado",
    ),
    "httpRequests": MessageLookupByLibrary.simpleMessage("Solicitudes HTTP"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "Las solicitudes enviadas antes de activar la captura, o ya borradas, no aparecen.",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage("Descifrado HTTPS"),
    "hue": MessageLookupByLibrary.simpleMessage("Tono"),
    "icon": MessageLookupByLibrary.simpleMessage("Icono"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("Registros de iconos"),
    "iconSets": MessageLookupByLibrary.simpleMessage("Conjuntos de iconos"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "Aún no hay conjuntos de iconos. Añádelos en Recursos de perfil personalizado → Conjuntos de iconos",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Estilo de icono"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("Relleno"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Oculto"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Simple"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("URL del icono"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignorar optimización de batería",
    ),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("Actualizar ahora"),
    "import": MessageLookupByLibrary.simpleMessage("Importar"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage(
      "Este archivo no es una configuración importable",
    ),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "Al importar se reemplazan los grupos de proxies, las reglas y los ajustes que tiene ahora este perfil",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage(
      "Importar desde archivo",
    ),
    "importFromLink": MessageLookupByLibrary.simpleMessage(
      "Importar desde enlace",
    ),
    "importSubscription": MessageLookupByLibrary.simpleMessage(
      "Importar suscripción",
    ),
    "importUrl": MessageLookupByLibrary.simpleMessage("Importar desde URL"),
    "inProgress": MessageLookupByLibrary.simpleMessage("En curso"),
    "inUse": MessageLookupByLibrary.simpleMessage("En uso"),
    "inbound": MessageLookupByLibrary.simpleMessage("Entrada"),
    "includeInterface": MessageLookupByLibrary.simpleMessage(
      "Interfaces incluidas",
    ),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "Solo el tráfico que llega por las interfaces incluidas pasa por TUN, y las interfaces excluidas dejan de aplicarse.",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage(
      "ID de usuario incluidos",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("No caduca"),
    "init": MessageLookupByLibrary.simpleMessage("Inicio"),
    "initFailed": MessageLookupByLibrary.simpleMessage("Error al iniciar"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "天机云 encontró un error al iniciarse y no puede continuar. Copia los detalles para informar del problema. Si sigue ocurriendo, borrar los datos suele permitir que la app vuelva a iniciarse.",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("Origen de la solicitud"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("De"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Introduce el nombre del grupo de proxies",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Introduce el contenido de la regla",
    ),
    "installCertificate": MessageLookupByLibrary.simpleMessage(
      "Instalar en el sistema",
    ),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage(
      "Certificado instalado",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Se denegó el permiso de lista de apps, por lo que no se pueden mostrar las apps instaladas. Concédelo manualmente en los ajustes del sistema.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Este sistema oculta la lista de apps instaladas hasta que se concede el permiso. Autorízalo para configurar el proxy por app.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Se requiere permiso de lista de apps",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage(
      "Fuentes instaladas",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Selección inteligente",
    ),
    "intercept": MessageLookupByLibrary.simpleMessage("Bloquear"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Nombre de interfaz"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Interfaz de salida",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Ninguna"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage(
      "Personalizada",
    ),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Seguir configuración",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Intervalo"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("IP de intranet"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Archivo de copia de seguridad no válido",
    ),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "Introduce un rango de IP en formato CIDR, como 192.168.0.0/16",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "Una marca DSCP no puede superar 63",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage(
      "Introduce un dominio o una dirección IP",
    ),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage(
      "No es un conjunto de iconos válido",
    ),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage(
      "No es un enlace de suscripción ni un enlace para compartir proxies",
    ),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "Introduce una dirección y un puerto, como 0.0.0.0:1053",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Solo se admite tcp o udp",
    ),
    "invalidOfCount": m68,
    "invalidPolicy": m69,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "Introduce un puerto o un rango como 443 u 8000-9000",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "Este código QR no contiene un enlace de perfil",
    ),
    "invalidProxy": m70,
    "invalidProxyProvider": m71,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Introduce números o rangos como 80 u 8000-9000, separados por /",
    ),
    "invalidRuleSet": m72,
    "invalidSubRule": m73,
    "ipAddress": MessageLookupByLibrary.simpleMessage("Dirección IP"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Historial de abusos"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Proxy"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Indicadores"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Organización"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo determinar el tipo de IP",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Buena"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Nivel"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Normal"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage(
      "Comprobar de nuevo",
    ),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("Arriesgada"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("Calidad"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Respondido por"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Fuentes"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "IP de salida distinta",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("Sin tipo"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage(
      "Límite de solicitudes",
    ),
    "ipType": MessageLookupByLibrary.simpleMessage("Tipo"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Empresarial"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Centro de datos"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Red móvil"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Residencial"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("Tipo desconocido"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("Versión de IP"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "El tráfico IPv6 solo se recibe mientras IPv6 esté activado.",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage(
      "Tiempo de espera IPv6 (ms)",
    ),
    "itemsCount": m74,
    "ja": MessageLookupByLibrary.simpleMessage("Japonés"),
    "justNow": MessageLookupByLibrary.simpleMessage("Ahora mismo"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage(
      "Inactividad de keep-alive TCP",
    ),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Intervalo de keep-alive TCP",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Clave"),
    "ko": MessageLookupByLibrary.simpleMessage("Coreano"),
    "label": MessageLookupByLibrary.simpleMessage("Etiqueta"),
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "large": MessageLookupByLibrary.simpleMessage("Grande"),
    "lastBackupTime": MessageLookupByLibrary.simpleMessage(
      "Última copia de seguridad",
    ),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Última actualización"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "El inicio no se completó",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "La última vez, la app se cerró inesperadamente mientras se iniciaba. En este inicio se ha omitido la configuración automática; puedes iniciarla manualmente para reintentarlo.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Diseño"),
    "light": MessageLookupByLibrary.simpleMessage("Claro"),
    "lineIssueTip": m75,
    "lineRate": MessageLookupByLibrary.simpleMessage("Tasa"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("Ajuste de línea"),
    "link": MessageLookupByLibrary.simpleMessage("Enlace"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("Liquid Glass"),
    "list": MessageLookupByLibrary.simpleMessage("Lista"),
    "listen": MessageLookupByLibrary.simpleMessage("Escucha"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Marca de enrutamiento de escucha",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "La marca de enrutamiento de escucha solo funciona en Linux.",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage(
      "Conexiones en vivo",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Cargando…"),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localFile": MessageLookupByLibrary.simpleMessage("Archivo local"),
    "localImage": MessageLookupByLibrary.simpleMessage("Imagen local"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Permiso de red local denegado: con la pila gvisor, la LAN no es accesible.",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("Proxies locales"),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Permiso de ubicación",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Se denegó el permiso de ubicación, por lo que no se puede leer el nombre de la red Wi-Fi actual. Activa el permiso de ubicación manualmente en los ajustes del sistema.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "El sistema requiere el permiso de ubicación para leer el nombre de la red Wi-Fi. En Android elige “Permitir todo el tiempo”; de lo contrario, no se podrá leer el nombre de la red Wi-Fi mientras la app esté en segundo plano.",
    ),
    "locationPermissionGuide": m76,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Se requiere permiso de ubicación",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Registro"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("Error"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("Información"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("Advertencia"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Nivel de registro"),
    "logRedactionNotice": MessageLookupByLibrary.simpleMessage(
      "Los informes exportados ocultan tokens de suscripción, contraseñas, UUID, claves privadas y encabezados Authorization o Cookie.",
    ),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Si desactivas Logcat, se oculta la entrada de registros.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Registros"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Registros y diagnóstico",
    ),
    "logsRunning": MessageLookupByLibrary.simpleMessage(
      "Registros de ejecución",
    ),
    "logsTest": MessageLookupByLibrary.simpleMessage("Prueba de registros"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Exención de loopback de UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Amplio"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Directo continental",
    ),
    "mapLocal": MessageLookupByLibrary.simpleMessage("Mapeo local"),
    "matchCase": MessageLookupByLibrary.simpleMessage(
      "Coincidir mayúsculas y minúsculas",
    ),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage(
      "Coincidir con IP de origen",
    ),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("Reglas aplicadas"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("Máximo de fallos"),
    "maxLengthTip": m77,
    "maximize": MessageLookupByLibrary.simpleMessage("Maximizar"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Memoria residente",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage("App y compartida"),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage("Heap inactivo"),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage("Heap en uso"),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "El núcleo no se está ejecutando",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Sobrecarga del runtime",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage(
      "Pilas de goroutines",
    ),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Estimado a partir de la memoria residente del proceso; puede diferir de lo que indica el sistema.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "El núcleo se ejecuta dentro del proceso de la app. Su parte se estima a partir de las estadísticas del runtime, y el resto cuenta como memoria de la app y compartida.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage(
      "Información de memoria",
    ),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Memoria que usan la app y el núcleo",
    ),
    "memoryReleased": MessageLookupByLibrary.simpleMessage("Memoria liberada"),
    "memoryReleasedSize": m78,
    "messageTest": MessageLookupByLibrary.simpleMessage("Prueba de mensaje"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "Esto es un mensaje.",
    ),
    "method": MessageLookupByLibrary.simpleMessage("Método"),
    "minimize": MessageLookupByLibrary.simpleMessage("Minimizar"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Minimizar al salir",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("minutos"),
    "minutesAgo": m79,
    "minutesAgoShort": m80,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage(
      "Añadir un archivo local",
    ),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage(
      "Añadir una regla de mapeo local",
    ),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage(
      "Añadir una regla de rechazo",
    ),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("Adjuntos"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "Las líneas hacen referencia a los adjuntos por nombre de archivo, como script-path=a.js.",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "Solo se descifran las apps que confían en certificados de usuario, sobre todo los navegadores.",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "Expórtalo y confía en él en los dispositivos que quieras descifrar.",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "Los navegadores Flatpak necesitan que importes el certificado exportado a mano.",
    ),
    "mitmCertificateSavedTip": m81,
    "mitmCertutilMissing": m82,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "El cliente rechazó el certificado. Instala la CA o excluye este host si la app fija su certificado.",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage(
      "Descifrar este host",
    ),
    "mitmDecryptHostTip": m83,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "天机云 podrá leer todo lo que se envíe a los hosts descifrados, incluidas cookies y contraseñas. Actívalo solo para los hosts que quieras reescribir.",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage(
      "Excluir del descifrado",
    ),
    "mitmExcludeHostTip": m84,
    "mitmFileTooLarge": m85,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "Un - al principio excluye un host, y decide la primera coincidencia.",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage(
      "Líneas ignoradas",
    ),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "Se detectó root: el certificado se añadirá a los certificados de confianza del sistema como el módulo de Magisk, KernelSU o APatch «TianjiCloud MITM CA». Todas las apps del dispositivo confiarán en él, y quien tenga su clave privada podrá descifrar el tráfico HTTPS del dispositivo. Para deshacerlo, regenera el certificado o quita el módulo en el gestor de root y reinicia. Si se deniega root, se instalará como certificado de usuario.",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "No se detectó root: el certificado solo puede instalarse como certificado de usuario. Solo se descifran las apps que confían en certificados de usuario, sobre todo los navegadores; las demás fallan en los hosts que indiques, así que no indiques sus hosts. Desde Android 11 terminas la instalación tú mismo en los ajustes del sistema.",
    ),
    "mitmMissingStores": m86,
    "mitmModule": MessageLookupByLibrary.simpleMessage("Módulo"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "No es un módulo de Surge, un plugin de Loon, un fragmento de Quantumult X ni una sobrescritura de Stash",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Las reglas de enrutamiento van antes que las del perfil.",
    ),
    "mitmModuleScriptsChanged": m87,
    "mitmModuleSystemTip": m88,
    "mitmModules": MessageLookupByLibrary.simpleMessage("Módulos"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("Nuevo módulo"),
    "mitmOldCertificateLeftTip": m89,
    "mitmOldSystemCertificateLeftTip": m90,
    "mitmRemoveOldCertificateTip": m91,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "El certificado se aplicará después de reiniciar el dispositivo.",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "No se encontró Magisk, KernelSU ni APatch para conservar el certificado. Vuelve a instalarlo después de reiniciar el dispositivo.",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage(
      "Reglas de enrutamiento",
    ),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "Este módulo es una sobrescritura de Stash, así que la regla se copió para que la añadas a mano.",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage("Ejecutar ahora"),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage(
      "El script terminó sin salida",
    ),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "Sus scripts leen y modifican el tráfico de los hosts que coinciden, incluidas las cookies y los tokens, y pueden enviar sus propias solicitudes. Actívalo solo si confías en su origen.",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage(
      "¿Ejecutar los scripts de este módulo?",
    ),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage(
      "Las reescrituras condicionales no son compatibles",
    ),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage(
      "Desactivado por un argumento",
    ),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage(
      "Este evento no es compatible",
    ),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage(
      "Las reescrituras jq no son compatibles",
    ),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage(
      "Las reescrituras del cuerpo JSON no son compatibles",
    ),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage(
      "Su archivo aún no se ha descargado",
    ),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "Solo se admiten las políticas DIRECT y REJECT",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "No se admite reescribir todos los encabezados como un solo texto",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "El archivo que nombra esta línea no está adjunto; usa una URL o adjúntalo",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage(
      "Este tipo de regla no es compatible",
    ),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage(
      "Este tipo de script no es compatible",
    ),
    "mitmSkipSection": m92,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage(
      "Este ajuste no es compatible",
    ),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage(
      "No se puede leer esta línea",
    ),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo añadir el certificado a las raíces de confianza del sistema",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("Comprobando…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage(
      "No instalado",
    ),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("De confianza"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage(
      "Sin confianza completa",
    ),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Puerto mixto"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage(
      "Validez del plan",
    ),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Tráfico restante",
    ),
    "mode": MessageLookupByLibrary.simpleMessage("Modo"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage("Icono monocromo"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monocromo"),
    "monthsAgo": m93,
    "monthsAgoShort": m94,
    "more": MessageLookupByLibrary.simpleMessage("Más"),
    "name": MessageLookupByLibrary.simpleMessage("Nombre"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Servidores DNS predeterminados, como 223.5.5.5, tls://1.1.1.1 o https://dns.google/dns-query.",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Los dominios coincidentes usan el servidor DNS indicado aquí en lugar de Nameserver y Fallback.",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage(
      "Barra inferior",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Red"),
    "networkAccessDeniedError": m95,
    "networkBadResponseError": m96,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "Se canceló la solicitud",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "No se pudo conectar con el servidor. Comprueba tu conexión de red o los ajustes del proxy",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "No se pudo resolver la dirección del servidor. Comprueba que la URL sea correcta y que el DNS funcione",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("Nombre de la red"),
    "networkNotFoundError": m97,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Demasiadas solicitudes (HTTP 429). Espera un momento e inténtalo de nuevo",
    ),
    "networkRequestFailed": m98,
    "networkSecret": MessageLookupByLibrary.simpleMessage("Clave de la red"),
    "networkServerError": m99,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Velocidad de red"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage(
      "Control del tráfico",
    ),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "Se agotó el tiempo de espera de la solicitud. Comprueba tu red o el proxy e inténtalo de nuevo",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Falló la conexión segura. Puede que el certificado del servidor no sea válido o que la conexión esté siendo interceptada",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Tipo de red"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Coincidencia siguiente"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noData": MessageLookupByLibrary.simpleMessage("Sin datos"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Sin información"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "No volver a recordármelo",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Sin red"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Apps sin red"),
    "noResolve": MessageLookupByLibrary.simpleMessage("No resolver IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "No resolver nombre de host",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage(
      "No hay resultados",
    ),
    "nodes": MessageLookupByLibrary.simpleMessage("Nodos"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "Este recurso externo no es un archivo de texto",
    ),
    "none": MessageLookupByLibrary.simpleMessage("Ninguno"),
    "notRunning": MessageLookupByLibrary.simpleMessage("Detenido"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "No se puede seleccionar el grupo de proxies actual",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalo de sincronización (minutos)",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Añade un perfil para empezar",
    ),
    "nullTip": m100,
    "numberRangeTip": m101,
    "numberTip": m102,
    "obfs": MessageLookupByLibrary.simpleMessage("Ofuscación"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("Host de ofuscación"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("Modo de ofuscación"),
    "obfsParam": MessageLookupByLibrary.simpleMessage(
      "Parámetro de ofuscación",
    ),
    "obfsPassword": MessageLookupByLibrary.simpleMessage(
      "Contraseña de ofuscación",
    ),
    "onDemand": MessageLookupByLibrary.simpleMessage("Bajo demanda"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "Comprobando el acceso a internet…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "El portapapeles está vacío",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "Comprueba el enlace de suscripción completo de arriba antes de importarlo.",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Suscripción de Tianji Cloud",
    ),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("Conectar"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo conectar. Inténtalo más tarde.",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "Conectado, pero sin acceso a internet",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage("Conectando…"),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "Cuando conecte, se hará una petición real a internet para confirmarlo.",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("Continuar"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "Pega o escanea el enlace de suscripción del panel y conéctate en unos pasos.",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("Salida"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("Caduca"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Puede que el plan haya caducado o que hayas agotado el tráfico de este mes. Renueva o restablece el tráfico y pulsa «Reintentar».",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "No hay nodos utilizables en esta suscripción",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "Puede que la suscripción se restableciera en el panel. Copia de nuevo la dirección de suscripción desde tu panel de usuario y pégala aquí.",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "El enlace de suscripción ha caducado",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Pulsa «Copiar dirección de suscripción» en tu panel de usuario y pégala aquí.",
        ),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage(
          "Esto no es un enlace de suscripción",
        ),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "Comprueba tu red e inténtalo de nuevo.",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "No se pudo importar",
    ),
    "onboardingFailureUnreachableDescription": MessageLookupByLibrary.simpleMessage(
      "Puede que tu red actual bloquee este dominio. La página de estado tiene direcciones alternativas, o inténtalo más tarde.",
    ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "No se puede acceder a la dirección de suscripción",
    ),
    "onboardingImported": m103,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage(
      "Obteniendo suscripción…",
    ),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "Leyendo la lista de nodos y los datos del plan",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "Acceso a internet · verificado",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "¿Aún no tienes dirección de suscripción? Abre tu panel de usuario para copiarla ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "El nodo actual puede no estar disponible temporalmente. Cambiar de nodo suele resolverlo.",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("Ahora no"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage(
      "Abrir panel de usuario",
    ),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage(
      "Pegar de nuevo",
    ),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "Pegar enlace de suscripción del portapapeles",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "El portapapeles solo se lee cuando pulsas el botón. El enlace de suscripción solo se guarda en este dispositivo.",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Tráfico restante",
    ),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage(
      "Escanear el código QR del panel",
    ),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage(
      "Cambiar de nodo",
    ),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Importa una suscripción para empezar",
    ),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage(
      "Ver dirección alternativa",
    ),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "El sistema preguntará si permites que Tianji Cloud cree una conexión VPN. Pulsa «Aceptar». Solo tienes que autorizarlo una vez.",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage(
      "Se necesita un permiso del sistema",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Contar solo el tráfico del proxy",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Abrir ajustes"),
    "optional": MessageLookupByLibrary.simpleMessage("Opcional"),
    "options": MessageLookupByLibrary.simpleMessage("Opciones"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("URL original"),
    "other": MessageLookupByLibrary.simpleMessage("Otros"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Otros colaboradores",
    ),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage(
      "Otras configuraciones",
    ),
    "outbound": MessageLookupByLibrary.simpleMessage("Salida"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("Salida"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("IP de salida"),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Modo de salida"),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "Normalmente, mantén «Reglas». El modo global también envía el tráfico de China continental por el proxy; el modo directo desactiva todas las líneas.",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "El modo directo está activo",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "El modo global está activo",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage(
      "Restaurar reglas",
    ),
    "overrideDestination": MessageLookupByLibrary.simpleMessage(
      "Sobrescribir destino",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage(
      "Entradas de sobrescritura",
    ),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("Sobrescrituras"),
    "overview": MessageLookupByLibrary.simpleMessage("Resumen"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage("Analizar IP pura"),
    "password": MessageLookupByLibrary.simpleMessage("Contraseña"),
    "paste": MessageLookupByLibrary.simpleMessage("Pegar"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage(
      "Importar del portapapeles",
    ),
    "peers": MessageLookupByLibrary.simpleMessage("Pares"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("Elegir del álbum"),
    "pinWindow": MessageLookupByLibrary.simpleMessage("Fijar ventana"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage("Vincula WebDAV"),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Introduce un nombre para el script",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Sube un código QR válido",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("Complemento"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage(
      "Cifrado del complemento",
    ),
    "pluginHost": MessageLookupByLibrary.simpleMessage("Host del complemento"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("Modo del complemento"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage(
      "Contraseña del complemento",
    ),
    "pluginPath": MessageLookupByLibrary.simpleMessage("Ruta del complemento"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage(
      "Usuario del complemento",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Puerto"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Introduce un puerto diferente",
    ),
    "portHopping": MessageLookupByLibrary.simpleMessage("Salto de puertos"),
    "portTip": m104,
    "portValue": m105,
    "ports": MessageLookupByLibrary.simpleMessage("Puertos"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("Clave precompartida"),
    "preferred": MessageLookupByLibrary.simpleMessage("Preferido"),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Requisitos previos"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Pulsa una combinación de teclas",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Vista previa"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("Solo lectura"),
    "previousMatch": MessageLookupByLibrary.simpleMessage(
      "Coincidencia anterior",
    ),
    "privateKey": MessageLookupByLibrary.simpleMessage("Clave privada"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage(
      "Frase de contraseña de la clave privada",
    ),
    "process": MessageLookupByLibrary.simpleMessage("Proceso"),
    "profile": MessageLookupByLibrary.simpleMessage("Perfil"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Crea proxies, grupos y reglas locales",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Copia el enlace desde tu panel",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "Las importaciones se validan primero. Un error de análisis no sustituye el perfil activo.",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("Introduce un intervalo válido"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Introduce el intervalo de actualización automática",
        ),
    "profileDaysLeft": m106,
    "profileExpiresIn": m107,
    "profileExpiryNotifications": MessageLookupByLibrary.simpleMessage(
      "Avisos de vencimiento y consumo",
    ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "El perfil se ha modificado. ¿Desactivar la actualización automática?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Introduce el nombre del perfil",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage(
      "Vista previa de la configuración",
    ),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Se aplica solo a este perfil; lo que no añadas usa su valor predeterminado.",
    ),
    "profileShowPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Mostrar información del plan en inicio",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "Los cambios se aplican al instante; si falla el análisis, se conserva la configuración actual.",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Se aplica solo a este perfil y tiene prioridad sobre las entradas de sobrescritura de TUN de los ajustes de red.",
    ),
    "profileUpdatedAt": m108,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Introduce una URL de perfil válida",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Introduce la URL del perfil",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Perfiles"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Ordenar perfiles"),
    "project": MessageLookupByLibrary.simpleMessage("Proyecto"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocolo"),
    "protocolParam": MessageLookupByLibrary.simpleMessage(
      "Parámetro del protocolo",
    ),
    "protocolVersion": MessageLookupByLibrary.simpleMessage(
      "Versión del protocolo",
    ),
    "providerCount": m109,
    "providerInUse": m110,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Solo se admiten proveedores remotos",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("Recursos externos"),
    "proxies": MessageLookupByLibrary.simpleMessage("Proxies"),
    "proxiesCount": m111,
    "proxiesProfileLabel": m112,
    "proxiesRemovedTip": m113,
    "proxiesReplacedTip": m114,
    "proxyAvailability": m115,
    "proxyChains": MessageLookupByLibrary.simpleMessage("Cadena de proxies"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Grupo de proxies"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "El grupo de proxies está vacío",
    ),
    "proxyGroupInUse": m116,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "Los grupos aparecen aquí cuando se inicia el núcleo",
    ),
    "proxyGroupsCount": m117,
    "proxyProviders": MessageLookupByLibrary.simpleMessage(
      "Proveedores de proxies",
    ),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Solo resuelve los nombres de los servidores proxy.",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Los nombres de servidores proxy coincidentes usan el servidor DNS indicado aquí en lugar de Proxy Server Nameserver.",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Tipo de proxy"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Depurar caché"),
    "publicKey": MessageLookupByLibrary.simpleMessage("Clave pública"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Negro puro"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Modo negro puro"),
    "qrcode": MessageLookupByLibrary.simpleMessage("Código QR"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Escanea un código QR para obtener un perfil",
    ),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "Este enlace es demasiado largo para un código QR. Usa Copiar enlace.",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("Acciones rápidas"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Edición rápida"),
    "quickLines": MessageLookupByLibrary.simpleMessage("Líneas rápidas"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage(
      "Consultas DNS recientes",
    ),
    "recentRequests": MessageLookupByLibrary.simpleMessage(
      "Solicitudes recientes",
    ),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("Sugeridos"),
    "recordType": MessageLookupByLibrary.simpleMessage("Tipo de registro"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Puerto Redir"),
    "redo": MessageLookupByLibrary.simpleMessage("Rehacer"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage(
      "Regenerar certificado",
    ),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "El nuevo certificado sustituye al actual, que 天机云 quita de las raíces de confianza de este dispositivo cuando puede. Cada otro dispositivo que confía en el actual tiene que instalar el nuevo.",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("Expresión regular"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Liberar memoria"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo liberar la memoria",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Remoto"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage("Destino remoto"),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage(
      "Resolución DNS remota",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Quitar"),
    "rename": MessageLookupByLibrary.simpleMessage("Renombrar"),
    "renew": MessageLookupByLibrary.simpleMessage("Renovar"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Renovar / mejorar plan",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("Reemplazar"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Reemplazar todo"),
    "request": MessageLookupByLibrary.simpleMessage("Solicitud"),
    "requestBody": MessageLookupByLibrary.simpleMessage(
      "Cuerpo de la solicitud",
    ),
    "requestHeaders": MessageLookupByLibrary.simpleMessage(
      "Encabezados de solicitud",
    ),
    "requests": MessageLookupByLibrary.simpleMessage("Solicitudes"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Solicitudes y actualizaciones",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Obligatorio"),
    "reset": MessageLookupByLibrary.simpleMessage("Restablecer"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "Esta página tiene cambios. ¿Seguro que quieres restablecer?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres restablecer?",
    ),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "Una vez conectado, el tráfico que necesita un proxy utiliza esta línea.",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo aplicar esta línea. Reintenta o elige otra línea.",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("Aplicando…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "Los vídeos y descargas grandes usan líneas normales, sin consumir tráfico residencial.",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Desvío de grandes transferencias no confirmado; vídeos y descargas pueden usar tráfico residencial.",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "No se está capturando el tráfico del equipo. Activa el proxy del sistema o TUN abajo.",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage("Cambiar salida"),
    "residentialChoose": MessageLookupByLibrary.simpleMessage("Elegir salida"),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "Elige la salida residencial desde el panel. Otros grupos no pueden cambiarla mientras el enrutamiento residencial esté activo.",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "La IA y los grupos que necesitan proxy seguirán la ruta seleccionada.",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Elegir salida residencial",
    ),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "El tráfico proxy predeterminado usa la salida residencial elegida; el tráfico directo sigue la suscripción. El desvío de descargas se indica abajo cuando está activo. El servidor puede usar salidas alternativas para ciertos destinos.",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "Cargando líneas residenciales…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "Leyendo las líneas disponibles en tu suscripción.",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Gestionar suscripción",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "La salida residencial seleccionada ya no está en esta suscripción.",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "El tráfico con proxy se bloquea hasta que elijas otra salida. El tráfico directo de China continental no cambia.",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage(
      "No hay líneas residenciales disponibles",
    ),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "Esta suscripción no tiene ninguna salida residencial utilizable ahora mismo. Sigue usando la política de la suscripción o revisa el panel de suscripción.",
    ),
    "residentialNoticeBody": m118,
    "residentialNoticeChange": MessageLookupByLibrary.simpleMessage(
      "Elegir otra",
    ),
    "residentialNoticeRetry": MessageLookupByLibrary.simpleMessage(
      "Reintentar",
    ),
    "residentialNoticeTitle": MessageLookupByLibrary.simpleMessage(
      "La línea residencial no está disponible temporalmente",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage(
      "Salida residencial",
    ),
    "residentialPending": MessageLookupByLibrary.simpleMessage(
      "Cambiando de línea. Espera un momento.",
    ),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "La nueva salida está activa, pero no se pudieron cerrar las conexiones existentes. Pueden seguir usando la salida anterior hasta que se reconecten.",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "La tarjeta de IP muestra la salida de su destino de comprobación actual, no una salida única para todos los sitios.",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("Seleccionada"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "Política de la suscripción",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage(
      "Salida residencial",
    ),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage(
      "No disponible",
    ),
    "residentialUseExit": m119,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage(
      "Usar la política de la suscripción",
    ),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "No hay una salida residencial seleccionada. El tráfico con proxy sigue la política de la suscripción.",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Intervalo de actualización automática",
    ),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "El intervalo de actualización automática debe ser mayor que 0",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Recursos"),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respetar reglas"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Respetar reglas enruta las conexiones DNS según las reglas y requiere un Proxy Server Nameserver.",
    ),
    "response": MessageLookupByLibrary.simpleMessage("Respuesta"),
    "responseBody": MessageLookupByLibrary.simpleMessage(
      "Cuerpo de la respuesta",
    ),
    "responseCode": MessageLookupByLibrary.simpleMessage("Código de respuesta"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage(
      "Encabezados de respuesta",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Reiniciar"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres reiniciar el núcleo?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restaurar"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Restaurar todos los datos",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restaurar solo los perfiles",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Estrategia de restauración",
    ),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage(
      "Sobrescribir",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Restauración completada",
    ),
    "result": MessageLookupByLibrary.simpleMessage("Resultado"),
    "retry": MessageLookupByLibrary.simpleMessage("Reintentar"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Direcciones de ruta"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage(
      "Direcciones excluidas de la ruta",
    ),
    "routingMark": MessageLookupByLibrary.simpleMessage(
      "Marca de enrutamiento",
    ),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "Recursos de enrutamiento",
    ),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Decide qué tráfico usa el proxy o va directo",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Ruso"),
    "rule": MessageLookupByLibrary.simpleMessage("Regla"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Regla lógica AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el dominio completo",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con una palabra clave del dominio",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con una expresión regular de dominio",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un sufijo de dominio",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Coincidencia con comodines; solo se admiten * y ?",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con la marca DSCP (solo entrada UDP de tproxy)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el rango de puertos de destino",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el código de país de la IP",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con los dominios de Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el nombre de la entrada",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el puerto de entrada",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el tipo de entrada",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el nombre de usuario de entrada; separa varios usuarios con /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el ASN de la IP",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un rango de direcciones IP; IP-CIDR6 es solo un alias",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un rango de direcciones IP",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un rango de sufijo de IP",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con todas las solicitudes, sin necesidad de condiciones",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con TCP o UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Regla lógica NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("Regla lógica OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el nombre del proceso; en Android coincide con el nombre del paquete",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con una expresión regular del nombre del proceso; en Android coincide con el nombre del paquete",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con comodines en el nombre del proceso; solo se admiten * y ?",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con la ruta completa del proceso",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con una expresión regular de la ruta del proceso",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con comodines en la ruta del proceso; solo se admiten * y ?",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el nombre de rematch; separa varios nombres con /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Hace referencia a un conjunto de reglas; requiere rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el código de país de la IP de origen",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el ASN de la IP de origen",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un rango de direcciones IP de origen",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con un rango de sufijo de IP de origen",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el rango de puertos de origen",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con una subregla; cuidado con los paréntesis",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Coincide con el ID de usuario de Linux",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("La regla está vacía"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "Las reglas deben ser una lista YAML con una regla por elemento, por ejemplo - DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent directo",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Bloquear DNS sobre TLS",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage(
      "Bloquear bucle del proxy",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage(
      "Bloquear QUIC",
    ),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage(
      "Bloquear STUN",
    ),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage("LAN directa"),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple y Microsoft directos",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage(
      "Proveedores de reglas",
    ),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Conjunto de reglas"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage(
      "El conjunto de reglas no tiene entradas utilizables",
    ),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage(
      "No se puede leer este archivo mrs",
    ),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "El conjunto de reglas mezcla dominios y rangos de IP, por lo que no se puede determinar su tipo",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Destino de la regla"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "La regla debe empezar con un tipo admitido, por ejemplo DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("Reglas"),
    "rulesCount": m120,
    "runTime": MessageLookupByLibrary.simpleMessage("Tiempo de ejecución"),
    "running": MessageLookupByLibrary.simpleMessage("En ejecución"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage(
      "Configuración de ejecución",
    ),
    "safeMode": MessageLookupByLibrary.simpleMessage("Modo seguro"),
    "safeModeAppTitle": m121,
    "saturation": MessageLookupByLibrary.simpleMessage("Saturación"),
    "save": MessageLookupByLibrary.simpleMessage("Guardar"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "¿Guardar los cambios?",
    ),
    "scene": MessageLookupByLibrary.simpleMessage("Escena"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("IA"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "Los servicios de IA usan las rutas del modo IA; el tráfico a China continental va directo",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("Diario"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "El tráfico pesado evita automáticamente la salida residencial; el tráfico a China continental va directo",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage(
      "El tráfico a China continental va directo",
    ),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage(
      "Escenas pausadas en modo residencial",
    ),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage(
      "Escenas no disponibles",
    ),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "Esta suscripción aún no tiene grupos de escena. Contacta con soporte o gestiona el enrutamiento desde la página Proxies.",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "No se pudieron cambiar algunas reglas",
    ),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("Streaming"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "El streaming usa las rutas del modo de vídeo; el tráfico a China continental va directo",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Modo script: reescribe todo el perfil con un script de extensión",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Ir a la selección",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Buscar"),
    "seconds": MessageLookupByLibrary.simpleMessage("segundos"),
    "secondsCount": m122,
    "secretKey": MessageLookupByLibrary.simpleMessage("Clave"),
    "sectionsInEffect": m123,
    "select": MessageLookupByLibrary.simpleMessage("Seleccionar"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Seleccionar todo"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Selecciona un conjunto de reglas",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Selecciona una estrategia de división",
    ),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage(
      "Confirmando la salida…",
    ),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "El grupo automático eligió otro nodo. Selecciona un nodo manualmente para fijarlo.",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "Aún no se captura el tráfico del dispositivo. Activa el proxy del sistema o TUN abajo.",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage(
      "Comprobar de nuevo",
    ),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "La línea residencial controla el tráfico proxy. Cámbiala en su tarjeta o vuelve al enrutamiento de la suscripción.",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "La salida difiere de tu selección. No se pudo confirmar el motivo. Comprueba de nuevo.",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "La salida difiere de tu selección. Comprobando el motivo…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("Enviar"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage(
      "Enviar desde el teléfono",
    ),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "¿Importar el enlace enviado desde el teléfono?",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "Este dispositivo no está conectado a una red local",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "Enlace de suscripción o enlace para compartir un proxy",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "Enviado. Confirma la importación en el otro dispositivo.",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage(
      "Enviar un enlace a 天机云",
    ),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Para recibir un enlace desde el teléfono, 天机云 necesita el permiso Dispositivos cercanos, que le da acceso a la red local. Actívalo en los ajustes de la aplicación.",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "Escanea el código con la cámara del teléfono y pega el enlace en la página que se abre. Ambos dispositivos deben estar en la misma red.",
    ),
    "server": MessageLookupByLibrary.simpleMessage("Servidor"),
    "serviceAbnormalCount": m124,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage(
      "Todo disponible",
    ),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Disponible"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Bloqueado"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Comprobar todo"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("Próximamente"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "ISP no permitido",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage(
      "Error en la comprobación",
    ),
    "serviceManage": MessageLookupByLibrary.simpleMessage(
      "Gestionar servicios",
    ),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Solo originales",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Sin comprobar"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Acceso restringido",
    ),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage(
      "Se muestra en el panel",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage(
      "Estado del servicio",
    ),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("No disponible"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Región no compatible",
    ),
    "settingEntries": MessageLookupByLibrary.simpleMessage("ajustes"),
    "settings": MessageLookupByLibrary.simpleMessage("Ajustes"),
    "settingsCount": m125,
    "shareLinkUnreadable": m126,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage(
      "No se pudo leer ningún proxy de los enlaces",
    ),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "Escanea con 天机云 en otro dispositivo para importar este perfil.",
    ),
    "show": MessageLookupByLibrary.simpleMessage("Mostrar"),
    "showLess": MessageLookupByLibrary.simpleMessage("Contraer"),
    "showMore": MessageLookupByLibrary.simpleMessage("Expandir"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Botón de detener en la notificación",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("Mostrar contraseña"),
    "sidebar": MessageLookupByLibrary.simpleMessage("Barra lateral"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Inicio silencioso"),
    "singleImport": MessageLookupByLibrary.simpleMessage("Importar uno"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "Introduce aquí un solo enlace; para varios, usa la edición rápida de la lista",
    ),
    "singleValueTip": m127,
    "size": MessageLookupByLibrary.simpleMessage("Tamaño"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage(
      "Omitir verificación de certificado",
    ),
    "skipDomain": MessageLookupByLibrary.simpleMessage("Omitir dominios"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage(
      "Omitir direcciones de destino",
    ),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage(
      "Omitir la verificación del certificado del servidor",
    ),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage(
      "Omitir direcciones de origen",
    ),
    "slide": MessageLookupByLibrary.simpleMessage("Deslizar"),
    "sliders": MessageLookupByLibrary.simpleMessage("Reguladores"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("Protocolos"),
    "sniffer": MessageLookupByLibrary.simpleMessage("Sniffer"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Puerto SOCKS"),
    "softStyle": MessageLookupByLibrary.simpleMessage("Suave"),
    "sort": MessageLookupByLibrary.simpleMessage("Ordenar"),
    "source": MessageLookupByLibrary.simpleMessage("Origen"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("IP de origen"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Proxy especial"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Reglas especiales"),
    "spectrum": MessageLookupByLibrary.simpleMessage("Espectro"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Estadísticas de velocidad",
    ),
    "splitStrategy": MessageLookupByLibrary.simpleMessage(
      "Estrategia de división",
    ),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "La estrategia de división no puede estar vacía",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("No hay SSID"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Modo de pila"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("Seguimiento de pila"),
    "standard": MessageLookupByLibrary.simpleMessage("Estándar"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Modo estándar: añade reglas sobre el perfil",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Iniciar"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage(
      "Empezar desde cero",
    ),
    "startVpn": MessageLookupByLibrary.simpleMessage("Iniciando VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Inicio y segundo plano",
    ),
    "status": MessageLookupByLibrary.simpleMessage("Estado"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "Con DNS desactivado, se usa el DNS del sistema.",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Detener"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage(
      "¿Detener la descarga de la actualización?",
    ),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Deteniendo VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Estrategia"),
    "strictRoute": MessageLookupByLibrary.simpleMessage("Ruta estricta"),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "La ruta estricta evita que el tráfico, como el DNS, eluda TUN y, con IPv6 desactivado, bloquea las conexiones IPv6 de este dispositivo.",
    ),
    "style": MessageLookupByLibrary.simpleMessage("Estilo"),
    "submit": MessageLookupByLibrary.simpleMessage("Enviar"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("Detalles"),
    "subscriptionExpiryNoticeBody": m128,
    "subscriptionExpiryNoticeTitle": m129,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Información de la suscripción",
    ),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Enlace de suscripción",
    ),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Introduce tu contraseña para sudo",
    ),
    "suspended": MessageLookupByLibrary.simpleMessage("Suspendido…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Cambiar de perfil"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("Cambiar"),
    "sync": MessageLookupByLibrary.simpleMessage("Sincronizar"),
    "system": MessageLookupByLibrary.simpleMessage("Sistema"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Apps del sistema"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Proxy del sistema"),
    "systemService": MessageLookupByLibrary.simpleMessage(
      "Servicio del sistema",
    ),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("Anómalo"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "Se ejecuta con permisos de administrador para configurar y restaurar el adaptador virtual, las rutas y el proxy del sistema.",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("Instalar"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage(
      "No instalado",
    ),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("Reparar"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Instalado y en ejecución",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Pestaña"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage(
      "Animación de pestañas",
    ),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage(
      "Toca el icono para reintentar",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage(
      "Toca para autorizar",
    ),
    "target": MessageLookupByLibrary.simpleMessage("Destino"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrente"),
    "testInterval": MessageLookupByLibrary.simpleMessage("Intervalo de prueba"),
    "testUrl": MessageLookupByLibrary.simpleMessage("URL de prueba"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("Probar al usarse"),
    "textScale": MessageLookupByLibrary.simpleMessage("Escala del texto"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Así se verá el texto en la app",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Tema"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Color del tema"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Modo del tema"),
    "tight": MessageLookupByLibrary.simpleMessage("Ajustado"),
    "time": MessageLookupByLibrary.simpleMessage("Hora"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage(
      "Tiempo hasta el primer byte",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage("Tiempo agotado"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("Tintado"),
    "tip": MessageLookupByLibrary.simpleMessage("Consejo"),
    "toggle": MessageLookupByLibrary.simpleMessage("Alternar"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Tolerancia"),
    "tools": MessageLookupByLibrary.simpleMessage("Herramientas"),
    "torch": MessageLookupByLibrary.simpleMessage("Linterna"),
    "total": MessageLookupByLibrary.simpleMessage("Total"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("Descargado"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Tráfico total"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("Subido"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Puerto TProxy"),
    "traffic": MessageLookupByLibrary.simpleMessage("Tráfico"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage(
      "Directo a China este mes",
    ),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage(
      "Directo (región sin confirmar)",
    ),
    "trafficPeak": m130,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage(
      "Ahorrado este mes",
    ),
    "trafficStats": MessageLookupByLibrary.simpleMessage(
      "Estadísticas de tráfico",
    ),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Tráfico directo en China continental, tráfico VPN y tráfico de proxy ahorrado este mes en este dispositivo.",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "Solo este dispositivo, este mes. Se cuenta el tráfico capturado por la aplicación.",
    ),
    "trafficTotal": m131,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Uso de tráfico"),
    "transport": MessageLookupByLibrary.simpleMessage("Transporte"),
    "transportHeaders": m132,
    "trayCopyProxyCommand": MessageLookupByLibrary.simpleMessage(
      "Copiar comando proxy para terminal",
    ),
    "trayDisconnect": MessageLookupByLibrary.simpleMessage("Desconectar"),
    "trayNotConnected": MessageLookupByLibrary.simpleMessage("Sin conexión"),
    "trayOpenApp": MessageLookupByLibrary.simpleMessage("Abrir Tianji Cloud…"),
    "trayPreferences": MessageLookupByLibrary.simpleMessage("Preferencias"),
    "trayShowMainWindow": MessageLookupByLibrary.simpleMessage(
      "Mostrar ventana principal",
    ),
    "trayTun": MessageLookupByLibrary.simpleMessage(
      "Adaptador de red virtual (TUN)",
    ),
    "trustCertificate": MessageLookupByLibrary.simpleMessage(
      "Confiar en el certificado",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo autorizar TUN, por lo que se desactivó.",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "TUN solo funciona en modo administrador.",
    ),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Las entradas añadidas aquí sustituyen los ajustes de TUN de todos los perfiles; lo que no añadas conserva el ajuste del propio perfil. Las entradas que añade un perfil personalizado tienen prioridad.",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Desactivar"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Activar"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage(
      "Modo de retransmisión UDP",
    ),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("Tiempo de espera UDP"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "El tiempo de espera UDP se indica en segundos y solo funciona con las pilas gvisor, system y mixed.",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("Ultra"),
    "undo": MessageLookupByLibrary.simpleMessage("Deshacer"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Latencia unificada"),
    "unknown": MessageLookupByLibrary.simpleMessage("Desconocido"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Error de red desconocido",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Restaurar tamaño"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Sin nombre"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("Desfijar ventana"),
    "update": MessageLookupByLibrary.simpleMessage("Actualizar"),
    "updateAll": MessageLookupByLibrary.simpleMessage("Actualizar todo"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo descargar la actualización.",
    ),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "Se inició la descarga de la actualización. Consulta el progreso en el panel.",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage(
      "Prueba de descarga de actualización",
    ),
    "updateFailed": MessageLookupByLibrary.simpleMessage("Error al actualizar"),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "No se pudo instalar la actualización. Puedes descargarla desde la página de la versión.",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage(
      "No se pudo verificar la actualización descargada.",
    ),
    "updateReady": MessageLookupByLibrary.simpleMessage("Actualización lista"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage(
      "La actualización se descargó. Toca para instalarla.",
    ),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "天机云 se cerrará para instalar la actualización y se volverá a abrir al terminar.",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Subida"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Ancho de banda de subida",
    ),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("Reescritura de URL"),
    "urlTip": m133,
    "useHosts": MessageLookupByLibrary.simpleMessage("Usar hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Usar hosts del sistema",
    ),
    "usedShort": MessageLookupByLibrary.simpleMessage("usado"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage("Tráfico usado"),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "username": MessageLookupByLibrary.simpleMessage("Usuario"),
    "validUntil": m134,
    "value": MessageLookupByLibrary.simpleMessage("Valor"),
    "view": MessageLookupByLibrary.simpleMessage("Ver"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Ver todo"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("IPv4 virtual"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("Vivo"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "La configuración de la VPN cambió. Toca para reiniciar",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Configuración de WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Modo lista blanca"),
    "writeToSystem": MessageLookupByLibrary.simpleMessage(
      "Escribir en el sistema",
    ),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "Escribir en el sistema también ajusta el reloj del sistema; Android lo ignora.",
    ),
    "yearsAgo": m135,
    "yearsAgoShort": m136,
    "yes": MessageLookupByLibrary.simpleMessage("Sí"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Chino simplificado"),
    "zzAutoUpdateHours": m137,
    "zzAutoUpdateIntervalLabel": m138,
    "zzExpiryDate": m139,
    "zzProfileBasedOnOverrides": m140,
    "zzProfileExpiredDays": m141,
    "zzProfileImportHint": m142,
    "zzProfileImportedOn": m143,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("Portapapeles"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("Archivo local"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("Escanear"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("Restantes"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("días"),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage(
      "Renovar / mejorar",
    ),
    "zzTotalQuota": m144,
  };
}
