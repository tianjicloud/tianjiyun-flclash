// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(count) => "Выбрано: ${count}";

  static String m1(name) => "«${name}» добавлен в локальные прокси";

  static String m2(name) => "«${name}» уже есть в локальных прокси";

  static String m3(count, skipped) =>
      "Будет добавлено: ${count}, пропущено (уже есть): ${skipped}";

  static String m4(time) => "Проверено в ${time}";

  static String m5(line) => "Трафик пойдёт через «${line}»";

  static String m6(name, status) => "Сейчас: ${name} · ${status}";

  static String m7(actual, expected) =>
      "Выход находится в регионе «${actual}», а выбранная линия — в регионе «${expected}»";

  static String m8(name, ip) =>
      "Выбранная линия «${name}» совпадает с выходом ${ip}";

  static String m9(date) => "Срок истекает ${date}";

  static String m10(month, day) => "${day}.${month}";

  static String m11(date) =>
      "План истекает ${date}. Продлите его, чтобы сохранить линии";

  static String m12(value) => "Коэффициент ${value}×";

  static String m13(days) => "Истёк ${days} дн. назад";

  static String m14(date) =>
      "Срок действия плана истёк ${date}. Продлите его и повторно проверьте ту же ссылку.";

  static String m15(step, total) =>
      "Шаг ${step} из ${total} · Проверка подписки";

  static String m16(count) => "Отмечено · ${count}";

  static String m17(count) => "Выбрано приложений: ${count}";

  static String m18(name) =>
      "Домашняя группа закреплена за «${name}». Измените её в списке домашних линий.";

  static String m19(time) => "Подписка обновлена ${time}";

  static String m20(categories) =>
      "Категории с прямым выходом через дата-центр: ${categories}";

  static String m21(count) => "Приложений: ${count}";

  static String m22(count) => "Пройдено: ${count}";

  static String m23(count) => "Запросов: ${count}";

  static String m24(version) => "Доступна новая версия: ${version}";

  static String m25(percent) => "Использовано ${percent}%";

  static String m26(count) => "Правила Wi-Fi: ${count}";

  static String m27(detail) => "Не удалось очистить данные: ${detail}";

  static String m28(count, download, upload) =>
      "Всего подключений: ${count} · Загрузка ${download} · Отправка ${upload} · Выберите строку, чтобы увидеть цепочку и совпавшее правило";

  static String m29(code) =>
      "Windows отказалась запускать TianjiCloudCore.exe (ошибка ${code}). Политики контроля приложений, такие как Smart App Control или AppLocker, блокируют неподписанные программы; разрешите 天机云 в этой политике или отключите её и повторите попытку.";

  static String m30(name) =>
      "Приложение два раза подряд не смогло завершить запуск. Чтобы разорвать цикл, профиль ${name} снят с выбора, а автоматическая настройка пропущена. Вы можете выбрать его снова в любой момент.";

  static String m31(url) => "Создать профиль по ссылке ${url}?";

  static String m32(members, count) => "${members} и ещё ${count}";

  static String m33(count) => "Используется в правилах: ${count}";

  static String m34(count, label) =>
      "${Intl.plural(count, one: 'Пользовательские профили не поддерживают подправила, поэтому отброшено ${label} правило SUB-RULE', few: 'Пользовательские профили не поддерживают подправила, поэтому отброшено ${label} правила SUB-RULE', many: 'Пользовательские профили не поддерживают подправила, поэтому отброшено ${label} правил SUB-RULE', other: 'Пользовательские профили не поддерживают подправила, поэтому отброшено ${label} правила SUB-RULE')}";

  static String m35(message) =>
      "Ядро не может разобрать этот прокси: ${message}";

  static String m36(proxy, target) =>
      "${proxy} подключается через ${target}, а ${target} снова ведёт к ${proxy}, поэтому подключение зацикливается";

  static String m37(name) =>
      "Имя ${name} уже занято другим прокси или группой прокси";

  static String m38(path) =>
      "Группы прокси ссылаются друг на друга по кругу: ${path}";

  static String m39(name) =>
      "Резервом для пустой группы может быть только прокси, а ${name} не существует или является группой прокси";

  static String m40(name, message) =>
      "${name}: недопустимое регулярное выражение: ${message}";

  static String m41(name) => "Прокси для подключения ${name} не существует";

  static String m42(names) => "Эти провайдеры прокси не существуют: ${names}";

  static String m43(names) => "Эти прокси или политики не существуют: ${names}";

  static String m44(name) =>
      "${name} — встроенное имя политики, его нельзя использовать";

  static String m45(count) =>
      "Проблем: ${count}, применение профиля может завершиться ошибкой";

  static String m46(count) => "Используется в группах: ${count}";

  static String m47(count) =>
      "${Intl.plural(count, one: '${count} день назад', few: '${count} дня назад', many: '${count} дней назад', other: '${count} дня назад')}";

  static String m48(count) => "${count} дн. назад";

  static String m49(label) =>
      "Вы уверены, что хотите удалить выбранные элементы (${label})?";

  static String m50(label) => "Вы уверены, что хотите удалить «${label}»?";

  static String m51(hours) =>
      "Ресурсы проверяются каждые ${hours} ч.; при ошибке загрузки продолжает использоваться предыдущая версия.";

  static String m52(label) => "Сведения: ${label}";

  static String m53(name) =>
      "Подключение через ${name} ведёт обратно к прокси, который его использует, поэтому соединение остановлено";

  static String m54(label) => "Поле «${label}» не может быть пустым";

  static String m55(label) => "«${label}» уже существует";

  static String m56(count) => "Ошибок: ${count}. Нажмите, чтобы посмотреть";

  static String m57(label, message) => "${label}: ${message}";

  static String m58(name) => "${name}: уже последняя версия";

  static String m59(name) => "${name}: обновлено";

  static String m60(count) => "Групп: ${count}";

  static String m61(count) => "Тайм-аут: ${count}";

  static String m62(action) =>
      "Уже используется для «${action}». При сохранении будет перенесено сюда.";

  static String m63(modifiers) =>
      "Добавьте хотя бы одну из клавиш: ${modifiers}";

  static String m64(count) =>
      "${Intl.plural(count, one: '${count} час назад', few: '${count} часа назад', many: '${count} часов назад', other: '${count} часа назад')}";

  static String m65(count) => "${count} ч назад";

  static String m66(encoding) =>
      "Не удалось декодировать ${encoding}, показаны данные в том виде, в каком они были переданы.";

  static String m67(memory, body) =>
      "Когда записей станет столько или они займут ${memory} памяти, самые старые удаляются первыми. От каждого тела сохраняются первые ${body}.";

  static String m68(invalid, total) =>
      "Недействительно: ${invalid} из ${total}";

  static String m69(target) => "${target} — недопустимая политика";

  static String m70(proxyName) => "${proxyName} — недопустимый прокси";

  static String m71(providerName) =>
      "${providerName} — недопустимый провайдер прокси";

  static String m72(ruleSet) => "${ruleSet} — недопустимый набор правил";

  static String m73(subRule) => "${subRule} — недопустимый SUB_RULE";

  static String m74(count) =>
      "${Intl.plural(count, one: '${count} элемент', few: '${count} элемента', many: '${count} элементов', other: '${count} элемента')}";

  static String m75(line, message) => "Строка ${line}: ${message}";

  static String m76(appName) =>
      "1. Откройте Системные настройки > Конфиденциальность и безопасность\n2. Выберите Службы геолокации\n3. Найдите и отметьте ${appName} в списке\n\nПосле настройки вернитесь в приложение и продолжайте работу. Спасибо за сотрудничество.";

  static String m77(label, max) => "«${label}» — не более ${max} символов";

  static String m78(size) => "Освобождено ${size}";

  static String m79(count) =>
      "${Intl.plural(count, one: '${count} минуту назад', few: '${count} минуты назад', many: '${count} минут назад', other: '${count} минуты назад')}";

  static String m80(count) => "${count} мин назад";

  static String m81(fileName) =>
      "Файл ${fileName} сохранён в «Загрузки». Установите его в настройках: Безопасность › Шифрование и учётные данные › Установка сертификата › Сертификат ЦС.";

  static String m82(command) =>
      "Chrome и Firefox используют собственные хранилища сертификатов, для которых нужен certutil: ${command}";

  static String m83(host) =>
      "Добавить ${host} в список имён хостов? 天机云 сможет читать всё, что на него отправляется, включая cookie и пароли.";

  static String m84(host) =>
      "Добавить -${host} в начало списка имён хостов? После этого узел никогда не будет расшифровываться.";

  static String m85(size) => "Файл больше ${size} МБ";

  static String m86(stores) => "Ещё не добавлен в: ${stores}";

  static String m87(name) =>
      "Скрипты модуля ${name} изменились, модуль выключен";

  static String m88(system) =>
      "Написан для ${system}; некоторые строки могут не подходить к приложениям на этом устройстве.";

  static String m89(name) =>
      "Не удалось удалить старый сертификат ${name}. Удалите его из доверенных корневых сертификатов вручную.";

  static String m90(name) =>
      "Старый сертификат ${name} всё ещё среди доверенных системных сертификатов. Разрешите 天机云 доступ root в менеджере root и создайте сертификат заново или удалите там модуль «TianjiCloud MITM CA» и перезагрузите устройство.";

  static String m91(name) =>
      "Удалите старый сертификат ${name} в настройках: Безопасность › Шифрование и учётные данные › Надёжные учётные данные › Пользователь, затем установите новый.";

  static String m92(section) => "Раздел [${section}] не поддерживается";

  static String m93(count) =>
      "${Intl.plural(count, one: '${count} месяц назад', few: '${count} месяца назад', many: '${count} месяцев назад', other: '${count} месяца назад')}";

  static String m94(count) => "${count} мес. назад";

  static String m95(code) =>
      "Сервер запретил доступ (HTTP ${code}). Возможно, ссылка устарела или учётные данные неверны";

  static String m96(code) => "Сервер отклонил запрос (HTTP ${code})";

  static String m97(code) =>
      "По этому адресу ничего не найдено (HTTP ${code}). Проверьте правильность URL";

  static String m98(detail) => "Сетевой запрос не выполнен: ${detail}";

  static String m99(code) =>
      "На сервере произошла ошибка (HTTP ${code}). Повторите попытку позже";

  static String m100(label) => "Пока нет: ${label}";

  static String m101(label, min, max) =>
      "Значение «${label}» должно быть от ${min} до ${max}";

  static String m102(label) => "Значение «${label}» должно быть числом";

  static String m103(count) => "Импортировано · ${count} узлов";

  static String m104(label) =>
      "Значение «${label}» должно быть от 1024 до 49151";

  static String m105(port) => "Порт ${port}";

  static String m106(days) => "Осталось дней: ${days}";

  static String m107(date, days) => "Истекает ${date}, осталось дней: ${days}";

  static String m108(time) => "Обновлено ${time}";

  static String m109(count) => "${count} элементов";

  static String m110(label, profiles) =>
      "«${label}» всё ещё используется профилями: ${profiles}. После удаления они будут работать неправильно. Вы уверены, что хотите удалить его?";

  static String m111(count, label) =>
      "${Intl.plural(count, other: '${label} прокси')}";

  static String m112(name, count) => "${name} и другие (${count} прокси)";

  static String m113(removed) =>
      "Будут удалены прокси: ${removed}. Строка с изменённым именем считается новым прокси, а пользовательские профили, ссылающиеся на удалённые, пометят их как отсутствующие. Применить?";

  static String m114(removed, added) =>
      "Будут удалены прокси: ${removed}. Будут добавлены: ${added}. Строка с изменённым именем считается новым прокси, а пользовательские профили, ссылающиеся на удалённые, пометят их как отсутствующие. Применить?";

  static String m115(label) =>
      "На «${label}» всё ещё ссылаются правила, группы прокси, прокси для подключения, DNS или NTP этого профиля, и после удаления эти ссылки перестанут работать. Вы уверены, что хотите удалить её?";

  static String m116(count, label) =>
      "${Intl.plural(count, one: '${label} группа прокси', few: '${label} группы прокси', many: '${label} групп прокси', other: '${label} группы прокси')}";

  static String m117(line) =>
      "Три проверки линии «${line}» подряд завершились неудачно. Проверьте линию или повторите попытку.";

  static String m118(name) => "Использовать ${name}";

  static String m119(count, label) =>
      "${Intl.plural(count, one: '${label} правило', few: '${label} правила', many: '${label} правил', other: '${label} правила')}";

  static String m120(appName) => "${appName} (Безопасный режим)";

  static String m121(count) =>
      "${Intl.plural(count, one: '${count} секунда', few: '${count} секунды', many: '${count} секунд', other: '${count} секунды')}";

  static String m122(count) => "Действуют: ${count}";

  static String m123(count) => "Проблем: ${count}";

  static String m124(count) =>
      "${Intl.plural(count, one: '${count} настройка', few: '${count} настройки', many: '${count} настроек', other: '${count} настройки')}";

  static String m125(link) => "Не удалось прочитать прокси из ${link}";

  static String m126(label) => "«${label}» — только одно значение";

  static String m127(name, date) => "${name} · ${date}";

  static String m128(days) => "До окончания плана осталось ${days} дн.";

  static String m129(value) => "Пик ${value}";

  static String m130(value) => "Всего ${value}";

  static String m131(transport) => "Заголовки ${transport}";

  static String m132(label) => "Значение «${label}» должно быть URL";

  static String m133(date) => "Действителен до ${date}";

  static String m134(count) =>
      "${Intl.plural(count, one: '${count} год назад', few: '${count} года назад', many: '${count} лет назад', other: '${count} года назад')}";

  static String m135(count) =>
      "${Intl.plural(count, one: '${count} г. назад', few: '${count} г. назад', many: '${count} л. назад', other: '${count} г. назад')}";

  static String m136(hours) => "автообновление каждые ${hours} ч";

  static String m137(count, unit) => "Автообновление каждые ${count} ${unit}";

  static String m138(date) => "Истекает ${date}";

  static String m139(count) =>
      "На основе текущей подписки · правил переопределения: ${count}";

  static String m140(count) => "Ссылка подписки · истекла ${count} дн. назад";

  static String m141(scheme) =>
      "Можно вставить ссылку из буфера обмена, выбрать локальный YAML-файл или открыть ${scheme} в браузере для импорта ссылки.";

  static String m142(date) => "Локальный файл · импортирован ${date}";

  static String m143(quota) => "Всего ${quota}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О программе"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Контроль доступа"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Через VPN проходят только выбранные приложения",
    ),
    "accessControlDisabledDesc": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений отключён",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Выбранные приложения исключаются из VPN",
    ),
    "accessControlSelectedCount": m0,
    "account": MessageLookupByLibrary.simpleMessage("Аккаунт"),
    "action": MessageLookupByLibrary.simpleMessage("Действие"),
    "actionDelayTest": MessageLookupByLibrary.simpleMessage(
      "Проверить все задержки",
    ),
    "actionDirectMode": MessageLookupByLibrary.simpleMessage("Прямой режим"),
    "actionGlobalMode": MessageLookupByLibrary.simpleMessage(
      "Глобальный режим",
    ),
    "actionMode": MessageLookupByLibrary.simpleMessage("Переключить режим"),
    "actionProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "actionRuleMode": MessageLookupByLibrary.simpleMessage("Режим правил"),
    "actionStart": MessageLookupByLibrary.simpleMessage("Старт/Стоп"),
    "actionTun": MessageLookupByLibrary.simpleMessage("TUN"),
    "actionUpdateProfiles": MessageLookupByLibrary.simpleMessage(
      "Обновить профили",
    ),
    "actionView": MessageLookupByLibrary.simpleMessage("Показать/Скрыть"),
    "add": MessageLookupByLibrary.simpleMessage("Добавить"),
    "addCustomProxy": MessageLookupByLibrary.simpleMessage("Добавить прокси"),
    "addFilters": MessageLookupByLibrary.simpleMessage("Добавить фильтры"),
    "addNodes": MessageLookupByLibrary.simpleMessage("Добавить узлы"),
    "addOverrideEntry": MessageLookupByLibrary.simpleMessage(
      "Добавить параметр",
    ),
    "addProfile": MessageLookupByLibrary.simpleMessage("Добавить профиль"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Добавить группу прокси",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Добавить правило"),
    "addSettingEntry": MessageLookupByLibrary.simpleMessage(
      "Добавить параметр",
    ),
    "addSsid": MessageLookupByLibrary.simpleMessage("Добавить SSID"),
    "addToLocalProxies": MessageLookupByLibrary.simpleMessage(
      "Добавить в локальные прокси",
    ),
    "addedRules": MessageLookupByLibrary.simpleMessage("Добавленные правила"),
    "addedToLocalProxies": m1,
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Дополнительные параметры",
    ),
    "additionalPrefix": MessageLookupByLibrary.simpleMessage("Префикс имени"),
    "additionalSuffix": MessageLookupByLibrary.simpleMessage("Суффикс имени"),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес WebDAV",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Расширенная конфигурация",
    ),
    "ageEncryptedProfile": MessageLookupByLibrary.simpleMessage(
      "Зашифрованный профиль",
    ),
    "ageSecretKey": MessageLookupByLibrary.simpleMessage("Секретный ключ age"),
    "ageSecretKeyRequiredTip": MessageLookupByLibrary.simpleMessage(
      "Профиль зашифрован с помощью age, для расшифровки нужен секретный ключ age",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("Согласен"),
    "all": MessageLookupByLibrary.simpleMessage("Все"),
    "allReferencedProxies": MessageLookupByLibrary.simpleMessage(
      "Все используемые прокси",
    ),
    "allReferencedProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Все используемые провайдеры прокси",
    ),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Разрешить приложениям обходить VPN",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Разрешить LAN"),
    "allowedIps": MessageLookupByLibrary.simpleMessage("Разрешённые IP"),
    "alreadyInLocalProxies": m2,
    "answers": MessageLookupByLibrary.simpleMessage("Ответы"),
    "app": MessageLookupByLibrary.simpleMessage("Приложение"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений",
    ),
    "appBackground": MessageLookupByLibrary.simpleMessage("Фон"),
    "appIconDesign": MessageLookupByLibrary.simpleMessage(
      "Дизайн значка приложения",
    ),
    "appProxiesEmpty": MessageLookupByLibrary.simpleMessage(
      "Нет локальных прокси",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Добавлять системный DNS",
    ),
    "applied": MessageLookupByLibrary.simpleMessage("Применено"),
    "applyNow": MessageLookupByLibrary.simpleMessage("Применить сейчас"),
    "arguments": MessageLookupByLibrary.simpleMessage("Аргументы"),
    "authentication": MessageLookupByLibrary.simpleMessage("Аутентификация"),
    "authenticationSystemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Пока включена аутентификация, системный прокси не применяется.",
    ),
    "authorize": MessageLookupByLibrary.simpleMessage("Разрешить"),
    "authorized": MessageLookupByLibrary.simpleMessage("Разрешено"),
    "auto": MessageLookupByLibrary.simpleMessage("Авто"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Автопроверка обновлений",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Автозакрытие соединений",
    ),
    "autoInclude": MessageLookupByLibrary.simpleMessage(
      "Автоматическое включение",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoRun": MessageLookupByLibrary.simpleMessage("Автовключение"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Автовключение запускает прокси при открытии приложения.",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Автонастройка системного DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Автообновление"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Назад"),
    "backgroundAurora": MessageLookupByLibrary.simpleMessage("Сияние"),
    "backgroundBlur": MessageLookupByLibrary.simpleMessage("Размытие фона"),
    "backgroundGlobe": MessageLookupByLibrary.simpleMessage("Глобус"),
    "backgroundMountains": MessageLookupByLibrary.simpleMessage("Горы"),
    "backgroundNebula": MessageLookupByLibrary.simpleMessage("Туманность"),
    "backgroundOrbit": MessageLookupByLibrary.simpleMessage("Орбита"),
    "backgroundPlanet": MessageLookupByLibrary.simpleMessage("Планета"),
    "backgroundSolid": MessageLookupByLibrary.simpleMessage("Сплошной цвет"),
    "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование и восстановление",
    ),
    "backupFromNewerVersion": MessageLookupByLibrary.simpleMessage(
      "Резервная копия создана более новой версией приложения. Обновите приложение перед восстановлением",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage(
      "Резервная копия создана",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Основная информация"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Базовые политики"),
    "batchImport": MessageLookupByLibrary.simpleMessage("Массовый импорт"),
    "batchLineInputTip": MessageLookupByLibrary.simpleMessage(
      "По одному элементу в строке",
    ),
    "batchLinkInputTip": MessageLookupByLibrary.simpleMessage(
      "По одной ссылке на строку",
    ),
    "batchPreviewTip": m3,
    "batchUrlInputTip": MessageLookupByLibrary.simpleMessage(
      "По одному URL на строку",
    ),
    "binaryData": MessageLookupByLibrary.simpleMessage("Двоичные данные"),
    "bind": MessageLookupByLibrary.simpleMessage("Привязать"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage(
      "Режим чёрного списка",
    ),
    "blockQuic": MessageLookupByLibrary.simpleMessage("Блокировать QUIC"),
    "bodyRewrite": MessageLookupByLibrary.simpleMessage("Перезапись тела"),
    "brandName": MessageLookupByLibrary.simpleMessage("Tianji Cloud"),
    "brightness": MessageLookupByLibrary.simpleMessage("Яркость"),
    "businessAboutBackupTitle": MessageLookupByLibrary.simpleMessage(
      "О приложении и резервных копиях",
    ),
    "businessAboutPanel": MessageLookupByLibrary.simpleMessage(
      "Панель пользователя и продление",
    ),
    "businessAccentColor": MessageLookupByLibrary.simpleMessage("Цвет акцента"),
    "businessAdvancedNetworkSettings": MessageLookupByLibrary.simpleMessage(
      "Расширенные сетевые настройки",
    ),
    "businessAiServiceLabel": MessageLookupByLibrary.simpleMessage(
      "Сервисы ИИ",
    ),
    "businessAiServices": MessageLookupByLibrary.simpleMessage(
      "ChatGPT · Claude",
    ),
    "businessAllLines": MessageLookupByLibrary.simpleMessage("Все линии"),
    "businessAllowBypassDescription": MessageLookupByLibrary.simpleMessage(
      "Разрешить выбранным приложениям обходить VPN.",
    ),
    "businessAppProxyTitle": MessageLookupByLibrary.simpleMessage(
      "Прокси для приложений",
    ),
    "businessAuthorizeTun": MessageLookupByLibrary.simpleMessage(
      "Авторизовать адаптер",
    ),
    "businessAutoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Работать в фоне после входа в Windows",
    ),
    "businessAutoLaunchTitle": MessageLookupByLibrary.simpleMessage(
      "Запускать при входе",
    ),
    "businessAutoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Использовать прежнюю линию и режим",
    ),
    "businessAutoRunTitle": MessageLookupByLibrary.simpleMessage(
      "Подключаться при запуске",
    ),
    "businessAutoTest": MessageLookupByLibrary.simpleMessage("Автотест"),
    "businessBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Сохранить профили и настройки приложения в файл.",
    ),
    "businessBackupNow": MessageLookupByLibrary.simpleMessage(
      "Создать резервную копию",
    ),
    "businessCards": MessageLookupByLibrary.simpleMessage("Карточки"),
    "businessChangeLine": MessageLookupByLibrary.simpleMessage("Сменить линию"),
    "businessCheckedAt": m4,
    "businessChooseLine": MessageLookupByLibrary.simpleMessage("Сменить линию"),
    "businessClientVersion": MessageLookupByLibrary.simpleMessage(
      "Версия клиента",
    ),
    "businessClientVersionDesc": MessageLookupByLibrary.simpleMessage(
      "Установленная версия клиента",
    ),
    "businessCloseAllConnections": MessageLookupByLibrary.simpleMessage(
      "Закрыть все",
    ),
    "businessCloseWindow": MessageLookupByLibrary.simpleMessage(
      "При закрытии окна",
    ),
    "businessConnectVia": m5,
    "businessConnectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Подключено · Есть проблема",
    ),
    "businessConnectedDisconnect": MessageLookupByLibrary.simpleMessage(
      "Подключено · нажмите для отключения",
    ),
    "businessConnectedProbeFailed": MessageLookupByLibrary.simpleMessage(
      "Подключено · Не удалось проверить выход",
    ),
    "businessConnectedUnverified": MessageLookupByLibrary.simpleMessage(
      "Подключено · Выход не проверен",
    ),
    "businessCopyErrorInfo": MessageLookupByLibrary.simpleMessage(
      "Скопировать сведения об ошибке",
    ),
    "businessCurrent": MessageLookupByLibrary.simpleMessage("Текущий"),
    "businessCurrentExitIp": MessageLookupByLibrary.simpleMessage(
      "Текущий внешний IP",
    ),
    "businessCurrentLine": MessageLookupByLibrary.simpleMessage(
      "Текущий маршрут",
    ),
    "businessCurrentLineState": m6,
    "businessCurrentNode": MessageLookupByLibrary.simpleMessage("Текущий узел"),
    "businessDatacenter": MessageLookupByLibrary.simpleMessage("Дата-центр"),
    "businessDelayTestShort": MessageLookupByLibrary.simpleMessage(
      "Проверить скорость",
    ),
    "businessDelayTimeout": MessageLookupByLibrary.simpleMessage("Тайм-аут"),
    "businessDeveloperDescription": MessageLookupByLibrary.simpleMessage(
      "Диагностика и инструменты разработчика.",
    ),
    "businessDeveloperOptionsDescription": MessageLookupByLibrary.simpleMessage(
      "Эти параметры помогают диагностировать проблемы. Обычно менять их не нужно.",
    ),
    "businessDeveloperOptionsTitle": MessageLookupByLibrary.simpleMessage(
      "Параметры разработчика",
    ),
    "businessDisclaimerAgree": MessageLookupByLibrary.simpleMessage(
      "Согласиться и продолжить",
    ),
    "businessDisclaimerSubtitle": MessageLookupByLibrary.simpleMessage(
      "Показывается при первом запуске",
    ),
    "businessDisclaimerTitle": MessageLookupByLibrary.simpleMessage(
      "Прочитайте перед использованием",
    ),
    "businessDisconnect": MessageLookupByLibrary.simpleMessage("Отключить"),
    "businessDnsAndSniffing": MessageLookupByLibrary.simpleMessage(
      "DNS и анализ доменов",
    ),
    "businessDnsFailed": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "businessDnsModeDescription": MessageLookupByLibrary.simpleMessage(
      "Выбор способа формирования DNS-ответов.",
    ),
    "businessDnsNoUpstream": MessageLookupByLibrary.simpleMessage(
      "Пользовательские DNS-серверы не настроены.",
    ),
    "businessDnsProxyResolved": MessageLookupByLibrary.simpleMessage(
      "Разрешено через прокси",
    ),
    "businessDnsResourcePreview": MessageLookupByLibrary.simpleMessage(
      "Предпросмотр ресурсов маршрутизации",
    ),
    "businessDnsServers": MessageLookupByLibrary.simpleMessage("DNS-серверы"),
    "businessDnsSucceeded": MessageLookupByLibrary.simpleMessage("Успешно"),
    "businessDomainSniffingDescription": MessageLookupByLibrary.simpleMessage(
      "Определять имена хостов в поддерживаемом трафике.",
    ),
    "businessEnableRules": MessageLookupByLibrary.simpleMessage(
      "Включить умную маршрутизацию",
    ),
    "businessErrorSolutions": MessageLookupByLibrary.simpleMessage(
      "Попробуйте выполнить следующие действия",
    ),
    "businessErrorStepChangePort": MessageLookupByLibrary.simpleMessage(
      "Измените порт в Настройки → Входящие подключения и порты",
    ),
    "businessErrorStepClosePort": MessageLookupByLibrary.simpleMessage(
      "Закройте программу, использующую порт 7890, и снова откройте TianjiCloud",
    ),
    "businessExitAnomaly": MessageLookupByLibrary.simpleMessage(
      "Сбой линии. Обратитесь в поддержку",
    ),
    "businessExitCheckPassed": MessageLookupByLibrary.simpleMessage(
      "Проверка выхода пройдена",
    ),
    "businessExitCountryMismatch": m7,
    "businessExitKindMismatch": MessageLookupByLibrary.simpleMessage(
      "Тип выхода не совпадает с выбранной линией",
    ),
    "businessExitMismatch": MessageLookupByLibrary.simpleMessage(
      "Фактический выход не совпадает с выбранной линией",
    ),
    "businessExitProbeDescription": MessageLookupByLibrary.simpleMessage(
      "Проверка выхода не вернула результат. Прокси может продолжать работать. Повторите проверку или запустите диагностику.",
    ),
    "businessExitProbeUnavailable": MessageLookupByLibrary.simpleMessage(
      "Не удалось подтвердить выход",
    ),
    "businessExitTunDescription": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер не авторизован. Терминал и некоторые приложения обходят прокси и видят ваш локальный IP. Авторизуйте его один раз, чтобы исправить это.",
    ),
    "businessExitVerified": MessageLookupByLibrary.simpleMessage(
      "Подключено · Выход проверен",
    ),
    "businessExitVerifiedDetail": m8,
    "businessExitVerifiedShort": MessageLookupByLibrary.simpleMessage(
      "Выход проверен",
    ),
    "businessExpiryDate": m9,
    "businessExpiryDateShort": m10,
    "businessExpiryNotice": m11,
    "businessFollowSystem": MessageLookupByLibrary.simpleMessage(
      "Как в системе",
    ),
    "businessGroupHeader": MessageLookupByLibrary.simpleMessage("Группы"),
    "businessGroupLocked": MessageLookupByLibrary.simpleMessage(
      "Заблокировано",
    ),
    "businessHelp": MessageLookupByLibrary.simpleMessage("Помощь"),
    "businessHome": MessageLookupByLibrary.simpleMessage("Главная"),
    "businessHotkeyHint": MessageLookupByLibrary.simpleMessage(
      "Выберите строку, чтобы задать или изменить сочетание клавиш",
    ),
    "businessImportAgain": MessageLookupByLibrary.simpleMessage(
      "Импортировать снова",
    ),
    "businessImportRenew": MessageLookupByLibrary.simpleMessage("Продлить"),
    "businessIntercept": MessageLookupByLibrary.simpleMessage("Блокировать"),
    "businessKernelRestart": MessageLookupByLibrary.simpleMessage(
      "Перезапустить ядро",
    ),
    "businessKernelStartFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось запустить сетевое ядро",
    ),
    "businessKernelUptime": MessageLookupByLibrary.simpleMessage(
      "Время работы",
    ),
    "businessLegal": MessageLookupByLibrary.simpleMessage(
      "Правовая информация",
    ),
    "businessLineCount": MessageLookupByLibrary.simpleMessage("линий"),
    "businessLineFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось завершить переключение. Повторите попытку.",
    ),
    "businessLineSelectionHint": MessageLookupByLibrary.simpleMessage(
      "Ручной выбор имеет приоритет: выбранная линия становится выходом. После переключения IP выхода проверяется; при несовпадении будет указана причина.",
    ),
    "businessLineSelectionHintShort": MessageLookupByLibrary.simpleMessage(
      "Выбранная линия станет выходом; после переключения проверим IP выхода.",
    ),
    "businessLineTitle": MessageLookupByLibrary.simpleMessage(
      "Линия по умолчанию",
    ),
    "businessLines": MessageLookupByLibrary.simpleMessage("Линии"),
    "businessLinesEmpty": MessageLookupByLibrary.simpleMessage(
      "Линии ещё не загружены. Проверьте подписку.",
    ),
    "businessLinesLoading": MessageLookupByLibrary.simpleMessage(
      "Загрузка доступных линий…",
    ),
    "businessLocalExport": MessageLookupByLibrary.simpleMessage(
      "Экспорт в локальный файл",
    ),
    "businessLocalPorts": MessageLookupByLibrary.simpleMessage(
      "Локальные порты",
    ),
    "businessLocked": MessageLookupByLibrary.simpleMessage("Закреплено"),
    "businessLockedExit": MessageLookupByLibrary.simpleMessage(
      "Выход закреплён",
    ),
    "businessMainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Прямое подключение к материковому Китаю",
    ),
    "businessManage": MessageLookupByLibrary.simpleMessage("Управлять"),
    "businessManualSelect": MessageLookupByLibrary.simpleMessage(
      "Выбор вручную",
    ),
    "businessMinimizeDesc": MessageLookupByLibrary.simpleMessage(
      "Значок в трее всегда показывает состояние соединения",
    ),
    "businessMinimizeToTray": MessageLookupByLibrary.simpleMessage(
      "Свернуть в трей",
    ),
    "businessMitmDescription": MessageLookupByLibrary.simpleMessage(
      "Проверка HTTPS с локальным сертификатом.",
    ),
    "businessMitmWarning": MessageLookupByLibrary.simpleMessage(
      "MITM расшифровывает HTTPS-трафик для совпавших доменов. Включайте его только для доверенных модулей.",
    ),
    "businessMonthTraffic": MessageLookupByLibrary.simpleMessage(
      "Трафик за месяц",
    ),
    "businessMonthUsed": MessageLookupByLibrary.simpleMessage(
      "Использовано за месяц",
    ),
    "businessMoreVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Открыть остальные параметры интерфейса VPN.",
    ),
    "businessMoreVpnSettings": MessageLookupByLibrary.simpleMessage(
      "Другие настройки VPN",
    ),
    "businessMultiplier": m12,
    "businessNetworkStack": MessageLookupByLibrary.simpleMessage(
      "Сетевой стек",
    ),
    "businessNoExitInfo": MessageLookupByLibrary.simpleMessage(
      "Нет данных о выходе",
    ),
    "businessNotConnected": MessageLookupByLibrary.simpleMessage(
      "Не подключено",
    ),
    "businessOnDemandConnection": MessageLookupByLibrary.simpleMessage(
      "Подключение по требованию",
    ),
    "businessOnDemandEmpty": MessageLookupByLibrary.simpleMessage(
      "Добавьте сеть Wi-Fi, чтобы при подключении к ней приостанавливать приложение.",
    ),
    "businessOnboardingFactDashboard": MessageLookupByLibrary.simpleMessage(
      "Смотрите статистику подключений на панели",
    ),
    "businessOnboardingFactImport": MessageLookupByLibrary.simpleMessage(
      "Импортируйте конфигурацию подписки",
    ),
    "businessOnboardingFactStatus": MessageLookupByLibrary.simpleMessage(
      "Проверяйте состояние подключения линий",
    ),
    "businessOnboardingFailedChangeLink": MessageLookupByLibrary.simpleMessage(
      "Использовать другую ссылку подписки",
    ),
    "businessOnboardingFailedDays": m13,
    "businessOnboardingFailedExpiredDescription": m14,
    "businessOnboardingFailedExpiredTitle":
        MessageLookupByLibrary.simpleMessage("Срок действия подписки истёк"),
    "businessOnboardingFailedPackage": MessageLookupByLibrary.simpleMessage(
      "План",
    ),
    "businessOnboardingFailedPastedUrl": MessageLookupByLibrary.simpleMessage(
      "Вставленная ссылка",
    ),
    "businessOnboardingFailedRenew": MessageLookupByLibrary.simpleMessage(
      "Продлить",
    ),
    "businessOnboardingFailedRetainedConfig":
        MessageLookupByLibrary.simpleMessage(
          "Предыдущая конфигурация сохранена, клиент продолжает работать.",
        ),
    "businessOnboardingFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Проверить снова",
    ),
    "businessOnboardingFailedStatus": MessageLookupByLibrary.simpleMessage(
      "Статус",
    ),
    "businessOnboardingFailedStep": m15,
    "businessOnboardingHeroTitle": MessageLookupByLibrary.simpleMessage(
      "Подключение к Tianji Cloud за три шага",
    ),
    "businessOnboardingImportConnect": MessageLookupByLibrary.simpleMessage(
      "Импортировать и подключиться",
    ),
    "businessOnboardingScanFile": MessageLookupByLibrary.simpleMessage(
      "Сканировать QR-код / выбрать файл",
    ),
    "businessOnboardingUrlHint": MessageLookupByLibrary.simpleMessage(
      "Вставьте ссылку Tianji Cloud",
    ),
    "businessOnboardingUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку",
    ),
    "businessOpenSource": MessageLookupByLibrary.simpleMessage(
      "Лицензии открытого ПО",
    ),
    "businessOpenSourceDescription": MessageLookupByLibrary.simpleMessage(
      "На основе FlClash · GPL-3.0",
    ),
    "businessOrdinaryWebExit": MessageLookupByLibrary.simpleMessage(
      "Выход для обычных сайтов",
    ),
    "businessOutboundLabel": MessageLookupByLibrary.simpleMessage("Выход"),
    "businessOverrideSettings": MessageLookupByLibrary.simpleMessage(
      "Переопределения подписки",
    ),
    "businessPortConflictTip": MessageLookupByLibrary.simpleMessage(
      "Порт 7890 занят другой программой, поэтому TianjiCloud не может его прослушивать. Сетевые настройки не изменены, вы можете продолжить просмотр сайтов.",
    ),
    "businessPrivacyTerms": MessageLookupByLibrary.simpleMessage(
      "Политика конфиденциальности · Условия обслуживания",
    ),
    "businessProfileAddAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Автообновление",
    ),
    "businessProfileAddClipboardRecognized":
        MessageLookupByLibrary.simpleMessage(
          "В буфере обнаружена ссылка на подписку Tianji Cloud.",
        ),
    "businessProfileAddCustomDescription": MessageLookupByLibrary.simpleMessage(
      "Добавить правила к существующей подписке",
    ),
    "businessProfileAddCustomTitle": MessageLookupByLibrary.simpleMessage(
      "Своя конфигурация",
    ),
    "businessProfileAddFileDescription": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "businessProfileAddFileTitle": MessageLookupByLibrary.simpleMessage(
      "Локальный файл",
    ),
    "businessProfileAddLinkDescription": MessageLookupByLibrary.simpleMessage(
      "Скопируйте из панели пользователя",
    ),
    "businessProfileAddLinkTitle": MessageLookupByLibrary.simpleMessage(
      "Ссылка подписки",
    ),
    "businessProfileAddMoreOptions": MessageLookupByLibrary.simpleMessage(
      "Дополнительные параметры",
    ),
    "businessProfileAddNameHint": MessageLookupByLibrary.simpleMessage(
      "Оставьте пустым, чтобы использовать название плана из подписки",
    ),
    "businessProfileAddNameLabel": MessageLookupByLibrary.simpleMessage(
      "Название (необязательно)",
    ),
    "businessProfileAddSubmit": MessageLookupByLibrary.simpleMessage(
      "Импортировать и проверить",
    ),
    "businessProfileAddTitle": MessageLookupByLibrary.simpleMessage(
      "Добавить подписку",
    ),
    "businessProfileAddUrlHint": MessageLookupByLibrary.simpleMessage(
      "Вставьте ссылку подписки",
    ),
    "businessProfileAddUrlLabel": MessageLookupByLibrary.simpleMessage(
      "Ссылка подписки",
    ),
    "businessProfileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "При импорте сначала выполняется проверка. Ошибка разбора не заменит активный профиль.",
    ),
    "businessProfileEditDelete": MessageLookupByLibrary.simpleMessage(
      "Удалить подписку",
    ),
    "businessProfileEditDeleteDescription": MessageLookupByLibrary.simpleMessage(
      "Удаляется только локальная конфигурация. Аккаунт и тариф Tianji Cloud не затрагиваются.",
    ),
    "businessProfileEditDeleteTitle": MessageLookupByLibrary.simpleMessage(
      "Удалить подписку",
    ),
    "businessProfileEditExpire": MessageLookupByLibrary.simpleMessage(
      "Истекает",
    ),
    "businessProfileEditExtendDescription":
        MessageLookupByLibrary.simpleMessage("Активных переопределений: "),
    "businessProfileEditExtendSuffix": MessageLookupByLibrary.simpleMessage(
      " items",
    ),
    "businessProfileEditExtensionTitle": MessageLookupByLibrary.simpleMessage(
      "Переопределения и скрипты",
    ),
    "businessProfileEditGroupCountSuffix": MessageLookupByLibrary.simpleMessage(
      " групп",
    ),
    "businessProfileEditHide": MessageLookupByLibrary.simpleMessage("Скрыть"),
    "businessProfileEditLineCountSeparator":
        MessageLookupByLibrary.simpleMessage(" · "),
    "businessProfileEditLineLabel": MessageLookupByLibrary.simpleMessage(
      "Линии",
    ),
    "businessProfileEditManage": MessageLookupByLibrary.simpleMessage(
      "Управлять",
    ),
    "businessProfileEditOpen": MessageLookupByLibrary.simpleMessage("Открыть"),
    "businessProfileEditPlan": MessageLookupByLibrary.simpleMessage("Тариф"),
    "businessProfileEditPreviewDescription": MessageLookupByLibrary.simpleMessage(
      "Предпросмотр только для чтения. Для изменений используйте пользовательскую конфигурацию.",
    ),
    "businessProfileEditPrivacy": MessageLookupByLibrary.simpleMessage(
      "Ссылка содержит личный токен. Не передавайте её другим.",
    ),
    "businessProfileEditRawTitle": MessageLookupByLibrary.simpleMessage(
      "Просмотр исходной конфигурации",
    ),
    "businessProfileEditRenew": MessageLookupByLibrary.simpleMessage(
      "Продлить / улучшить",
    ),
    "businessProfileEditShow": MessageLookupByLibrary.simpleMessage("Показать"),
    "businessProfileEditSummaryTitle": MessageLookupByLibrary.simpleMessage(
      "Информация о тарифе",
    ),
    "businessProfileEditTitle": MessageLookupByLibrary.simpleMessage(
      "Изменить подписку",
    ),
    "businessProfilesSortDescription": MessageLookupByLibrary.simpleMessage(
      "Перетащите подписку, чтобы изменить порядок. Подписки выше отображаются первыми на панели и в трее.",
    ),
    "businessProfilesSortTitle": MessageLookupByLibrary.simpleMessage(
      "Изменить порядок подписок",
    ),
    "businessProvidersTitle": MessageLookupByLibrary.simpleMessage(
      "Наборы прокси и правил",
    ),
    "businessProxyCardDensity": MessageLookupByLibrary.simpleMessage(
      "Плотность карточек прокси",
    ),
    "businessProxyCheckedGroup": m16,
    "businessProxyDnsRemote": MessageLookupByLibrary.simpleMessage(
      "Домены прокси-трафика разрешаются на стороне линии",
    ),
    "businessProxyIcons": MessageLookupByLibrary.simpleMessage("Значки прокси"),
    "businessProxyNextConnection": MessageLookupByLibrary.simpleMessage(
      "Изменения вступят в силу при следующем подключении",
    ),
    "businessProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Наборы прокси",
    ),
    "businessProxyReconnect": MessageLookupByLibrary.simpleMessage(
      "Переподключить сейчас",
    ),
    "businessProxySearchHint": MessageLookupByLibrary.simpleMessage(
      "Поиск приложений",
    ),
    "businessProxySelectedBypass": MessageLookupByLibrary.simpleMessage(
      "Обходить прокси для отмеченных приложений",
    ),
    "businessProxySelectedCount": m17,
    "businessProxySelectedOnly": MessageLookupByLibrary.simpleMessage(
      "Проксировать отмеченные приложения",
    ),
    "businessProxyTraffic": MessageLookupByLibrary.simpleMessage("Прокси"),
    "businessProxyUncheckedGroup": MessageLookupByLibrary.simpleMessage(
      "Не отмечено",
    ),
    "businessRecheck": MessageLookupByLibrary.simpleMessage("Проверить снова"),
    "businessRegionAT": MessageLookupByLibrary.simpleMessage("Австрия"),
    "businessRegionAU": MessageLookupByLibrary.simpleMessage("Австралия"),
    "businessRegionBE": MessageLookupByLibrary.simpleMessage("Бельгия"),
    "businessRegionBR": MessageLookupByLibrary.simpleMessage("Бразилия"),
    "businessRegionCA": MessageLookupByLibrary.simpleMessage("Канада"),
    "businessRegionCO": MessageLookupByLibrary.simpleMessage("Колумбия"),
    "businessRegionCZ": MessageLookupByLibrary.simpleMessage("Чехия"),
    "businessRegionDE": MessageLookupByLibrary.simpleMessage("Германия"),
    "businessRegionFR": MessageLookupByLibrary.simpleMessage("Франция"),
    "businessRegionGB": MessageLookupByLibrary.simpleMessage("Великобритания"),
    "businessRegionHK": MessageLookupByLibrary.simpleMessage("Гонконг"),
    "businessRegionIT": MessageLookupByLibrary.simpleMessage("Италия"),
    "businessRegionJP": MessageLookupByLibrary.simpleMessage("Япония"),
    "businessRegionKR": MessageLookupByLibrary.simpleMessage("Южная Корея"),
    "businessRegionLocalDns": MessageLookupByLibrary.simpleMessage(
      "Домены материкового Китая разрешаются локально",
    ),
    "businessRegionRO": MessageLookupByLibrary.simpleMessage("Румыния"),
    "businessRegionSE": MessageLookupByLibrary.simpleMessage("Швеция"),
    "businessRegionSG": MessageLookupByLibrary.simpleMessage("Сингапур"),
    "businessRegionTW": MessageLookupByLibrary.simpleMessage("Тайвань"),
    "businessRegionUS": MessageLookupByLibrary.simpleMessage("США"),
    "businessReplace": MessageLookupByLibrary.simpleMessage("Заменить"),
    "businessResidential": MessageLookupByLibrary.simpleMessage("Резидентский"),
    "businessResidentialBroadband": MessageLookupByLibrary.simpleMessage(
      "Домашний широкополосный доступ",
    ),
    "businessResidentialLockedHint": m18,
    "businessResidentialShort": MessageLookupByLibrary.simpleMessage(
      "Резидентский",
    ),
    "businessRestoreAction": MessageLookupByLibrary.simpleMessage(
      "Восстановить…",
    ),
    "businessRestoreFromFileWebDav": MessageLookupByLibrary.simpleMessage(
      "Восстановить из файла или WebDAV",
    ),
    "businessRoutingDesc": MessageLookupByLibrary.simpleMessage(
      "Меняется только линия по умолчанию. Правила ИИ, стриминга, прямых соединений и блокировок сохраняются.",
    ),
    "businessRuleModeRequired": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация выключена. Эта линия по умолчанию сейчас не применяется.",
    ),
    "businessRuleOverrideDescription": MessageLookupByLibrary.simpleMessage(
      "Управление правилами и провайдерами.",
    ),
    "businessRuleProviders": MessageLookupByLibrary.simpleMessage(
      "Наборы правил",
    ),
    "businessScanPrompt": MessageLookupByLibrary.simpleMessage(
      "Поместите QR-код подписки в рамку",
    ),
    "businessSearchHint": MessageLookupByLibrary.simpleMessage(
      "Поиск линии или региона",
    ),
    "businessSelected": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "businessSelectionStale": MessageLookupByLibrary.simpleMessage(
      "Подписка или режим изменились. Откройте выбор линии заново.",
    ),
    "businessServiceNoLogin": MessageLookupByLibrary.simpleMessage(
      "Вход не требуется",
    ),
    "businessSettingsAbout": MessageLookupByLibrary.simpleMessage(
      "О Tianji Cloud",
    ),
    "businessSettingsAppearance": MessageLookupByLibrary.simpleMessage(
      "Внешний вид",
    ),
    "businessSettingsCommon": MessageLookupByLibrary.simpleMessage("Основное"),
    "businessSettingsDnsResources": MessageLookupByLibrary.simpleMessage(
      "DNS и ресурсы",
    ),
    "businessSettingsHotkeys": MessageLookupByLibrary.simpleMessage(
      "Горячие клавиши",
    ),
    "businessSettingsIconsUa": MessageLookupByLibrary.simpleMessage(
      "Значки и UA",
    ),
    "businessSettingsInboundPorts": MessageLookupByLibrary.simpleMessage(
      "Входящие подключения и порты",
    ),
    "businessSettingsNetworkAdvanced": MessageLookupByLibrary.simpleMessage(
      "Сеть (дополнительно)",
    ),
    "businessSettingsOther": MessageLookupByLibrary.simpleMessage("Другое"),
    "businessSettingsRules": MessageLookupByLibrary.simpleMessage(
      "Правила и переопределения",
    ),
    "businessSettingsStartupWindow": MessageLookupByLibrary.simpleMessage(
      "Запуск и окно",
    ),
    "businessSettingsTun": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер TUN",
    ),
    "businessSmartRouting": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация",
    ),
    "businessSortByDelay": MessageLookupByLibrary.simpleMessage(
      "Сортировать по задержке",
    ),
    "businessStackModeDescription": MessageLookupByLibrary.simpleMessage(
      "Выберите сетевой стек VPN.",
    ),
    "businessSubscriptionAutoUpdate": MessageLookupByLibrary.simpleMessage(
      "Автообновление подписки",
    ),
    "businessSubscriptionAutoUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Обновлять после изменения линий",
    ),
    "businessSubscriptionDetails": MessageLookupByLibrary.simpleMessage(
      "Сведения о подписке",
    ),
    "businessSubscriptionOverridesDescription":
        MessageLookupByLibrary.simpleMessage("Настройки DNS из этой подписки."),
    "businessSubscriptionUpdatedAt": m19,
    "businessSubscriptions": MessageLookupByLibrary.simpleMessage("Подписки"),
    "businessSubstitutedCategories": m20,
    "businessSwitchMode": MessageLookupByLibrary.simpleMessage("Сменить режим"),
    "businessSystemProxyDescription": MessageLookupByLibrary.simpleMessage(
      "Направлять HTTP через системный прокси.",
    ),
    "businessSystemProxyHttp": MessageLookupByLibrary.simpleMessage(
      "Системный прокси (HTTP)",
    ),
    "businessTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы подключиться",
    ),
    "businessTestAll": MessageLookupByLibrary.simpleMessage("Проверить все"),
    "businessToolsAppearance": MessageLookupByLibrary.simpleMessage(
      "Внешний вид",
    ),
    "businessToolsAppearanceLanguage": MessageLookupByLibrary.simpleMessage(
      "Внешний вид и язык",
    ),
    "businessToolsApplicationCount": m21,
    "businessToolsBrowse": MessageLookupByLibrary.simpleMessage("Обзор"),
    "businessToolsConnectionRequests": MessageLookupByLibrary.simpleMessage(
      "Подключения и запросы",
    ),
    "businessToolsGeneral": MessageLookupByLibrary.simpleMessage("Общие"),
    "businessToolsLocalDirect": MessageLookupByLibrary.simpleMessage(
      "Подключать устройства локальной сети напрямую",
    ),
    "businessToolsPassedCount": m22,
    "businessToolsPerAppProxy": MessageLookupByLibrary.simpleMessage(
      "Прокси для приложений",
    ),
    "businessToolsRequestCount": m23,
    "businessToolsRoutingResources": MessageLookupByLibrary.simpleMessage(
      "Ресурсы маршрутизации",
    ),
    "businessToolsRuntimeLogs": MessageLookupByLibrary.simpleMessage(
      "Журнал работы",
    ),
    "businessToolsSimplifiedChinese": MessageLookupByLibrary.simpleMessage(
      "Упрощённый китайский",
    ),
    "businessTrafficNotOnTianji": MessageLookupByLibrary.simpleMessage(
      "Трафик не проходит через линию Tianji",
    ),
    "businessTrafficScope": MessageLookupByLibrary.simpleMessage(
      "Трафик за месяц только на этом устройстве",
    ),
    "businessTunBypassPrivateDescription": MessageLookupByLibrary.simpleMessage(
      "Прямой доступ к принтерам, NAS и другим устройствам LAN",
    ),
    "businessTunCaption": MessageLookupByLibrary.simpleMessage(
      "Маршрутизировать трафик всех приложений",
    ),
    "businessTunDevice": MessageLookupByLibrary.simpleMessage("Имя адаптера"),
    "businessTunExcludedRoutes": MessageLookupByLibrary.simpleMessage(
      "Исключённые маршруты",
    ),
    "businessTunMtu": MessageLookupByLibrary.simpleMessage("MTU"),
    "businessTunRouteCount": MessageLookupByLibrary.simpleMessage("маршрутов"),
    "businessTunStackGvisorDescription": MessageLookupByLibrary.simpleMessage(
      "TCP и UDP используют пользовательский сетевой стек gVisor",
    ),
    "businessTunStackMipsDescription": MessageLookupByLibrary.simpleMessage(
      "TCP и UDP используют сетевой стек mipstack в пространстве пользователя",
    ),
    "businessTunStackMixed": MessageLookupByLibrary.simpleMessage("Смешанный"),
    "businessTunStackMixedDescription": MessageLookupByLibrary.simpleMessage(
      "TCP использует системный стек, UDP — gVisor; высокая совместимость",
    ),
    "businessTunStackSystemDescription": MessageLookupByLibrary.simpleMessage(
      "TCP и UDP используют сетевой стек ОС",
    ),
    "businessTunTakeoverDescription": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер обрабатывает трафик всех приложений, включая терминалы, игры и приложения без системного прокси. Системная служба должна работать от имени администратора.",
    ),
    "businessTunTakeoverMode": MessageLookupByLibrary.simpleMessage(
      "Перехват трафика",
    ),
    "businessTunTitle": MessageLookupByLibrary.simpleMessage(
      "Виртуальный сетевой интерфейс (TUN)",
    ),
    "businessTypographyLayout": MessageLookupByLibrary.simpleMessage(
      "Текст и макет",
    ),
    "businessUpdateAvailable": m24,
    "businessUpdateDaily": MessageLookupByLibrary.simpleMessage("Ежедневно"),
    "businessUpdateHour1": MessageLookupByLibrary.simpleMessage("Каждый час"),
    "businessUpdateHour12": MessageLookupByLibrary.simpleMessage(
      "Каждые 12 часов",
    ),
    "businessUpdateHour6": MessageLookupByLibrary.simpleMessage(
      "Каждые 6 часов",
    ),
    "businessUsagePercent": m25,
    "businessVersion": MessageLookupByLibrary.simpleMessage("Версия"),
    "businessViewDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Открыть диагностику",
    ),
    "businessVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "businessVpnPermission": MessageLookupByLibrary.simpleMessage(
      "При первом подключении разрешите VPN",
    ),
    "businessWebDavBackup": MessageLookupByLibrary.simpleMessage(
      "Резервная копия WebDAV",
    ),
    "businessWifiRulesCount": m26,
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Исключённые домены"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Исключённые домены действуют только при включённом системном прокси.",
    ),
    "bypassPrivateRoute": MessageLookupByLibrary.simpleMessage(
      "Обходить частные адреса",
    ),
    "cache": MessageLookupByLibrary.simpleMessage("Кэш"),
    "cacheAlgorithm": MessageLookupByLibrary.simpleMessage("Алгоритм кэша"),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Кэш повреждён. Очистить его?",
    ),
    "cacheMaxSize": MessageLookupByLibrary.simpleMessage("Размер кэша"),
    "cameraPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешите доступ к камере в системных настройках, чтобы сканировать QR-коды, или выберите изображение QR-кода из галереи.",
    ),
    "cameraPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется доступ к камере",
    ),
    "cameraUnavailable": MessageLookupByLibrary.simpleMessage(
      "Камера недоступна",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage("Снять выделение"),
    "cannotSave": MessageLookupByLibrary.simpleMessage("Не удалось сохранить"),
    "certificate": MessageLookupByLibrary.simpleMessage("Сертификат"),
    "changeProxyFailedTip": MessageLookupByLibrary.simpleMessage(
      "Не удалось переключить прокси; восстановлен предыдущий выбор",
    ),
    "changelogBreaking": MessageLookupByLibrary.simpleMessage(
      "Важные изменения",
    ),
    "changelogFeatures": MessageLookupByLibrary.simpleMessage("Новые функции"),
    "changelogFixes": MessageLookupByLibrary.simpleMessage("Исправления"),
    "changelogPerformance": MessageLookupByLibrary.simpleMessage(
      "Производительность",
    ),
    "changelogReverts": MessageLookupByLibrary.simpleMessage("Откаты"),
    "checkCertificate": MessageLookupByLibrary.simpleMessage(
      "Проверять TLS-сертификаты",
    ),
    "checkCertificateDesc": MessageLookupByLibrary.simpleMessage(
      "Без проверки TLS-сертификатов подписки и резервные копии уязвимы для атаки «человек посередине».",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Проверить обновления"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "У вас уже последняя версия",
    ),
    "checkingExit": MessageLookupByLibrary.simpleMessage("Проверяем выход…"),
    "chooseFile": MessageLookupByLibrary.simpleMessage("Выбрать файл"),
    "cipher": MessageLookupByLibrary.simpleMessage("Шифр"),
    "clearData": MessageLookupByLibrary.simpleMessage("Очистить данные"),
    "clearDataAndExitTip": MessageLookupByLibrary.simpleMessage(
      "Все профили, настройки и локальные данные будут удалены, после чего приложение закроется. Откройте его снова, чтобы начать заново.",
    ),
    "clearDataFailed": m27,
    "clearDnsCache": MessageLookupByLibrary.simpleMessage("Очистить кэш DNS"),
    "clearDnsCacheFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось очистить кэш DNS",
    ),
    "clearSearch": MessageLookupByLibrary.simpleMessage("Очистить поиск"),
    "clientFingerprint": MessageLookupByLibrary.simpleMessage(
      "Отпечаток клиента",
    ),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Экспорт в буфер обмена",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Импорт из буфера обмена",
    ),
    "clipboardNoPackageNames": MessageLookupByLibrary.simpleMessage(
      "В буфере обмена нет допустимых имён пакетов",
    ),
    "clipboardWriteFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось скопировать в буфер обмена. Возможно, выделение слишком велико",
    ),
    "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
    "closeAllConnections": MessageLookupByLibrary.simpleMessage(
      "Закрыть все подключения",
    ),
    "closeConnection": MessageLookupByLibrary.simpleMessage(
      "Закрыть соединение",
    ),
    "closeConnections": MessageLookupByLibrary.simpleMessage(
      "Закрыть соединения",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Цвет"),
    "colorStyle": MessageLookupByLibrary.simpleMessage("Стиль палитры"),
    "columns": MessageLookupByLibrary.simpleMessage("Столбцы"),
    "compact": MessageLookupByLibrary.simpleMessage("Компактный"),
    "compatible": MessageLookupByLibrary.simpleMessage("Режим совместимости"),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить все данные?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить эту группу прокси?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите закрыть текущее окно?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно завершить ядро со сбоем?",
    ),
    "congestionControl": MessageLookupByLibrary.simpleMessage(
      "Управление перегрузкой",
    ),
    "congestionController": MessageLookupByLibrary.simpleMessage(
      "Управление перегрузкой TCP",
    ),
    "congestionControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Управление перегрузкой TCP действует только со стеком mips.",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "connecting": MessageLookupByLibrary.simpleMessage("Подключение…"),
    "connection": MessageLookupByLibrary.simpleMessage("Соединение"),
    "connectionAddDomainRule": MessageLookupByLibrary.simpleMessage(
      "Добавить правило для домена",
    ),
    "connectionBlockedLabel": MessageLookupByLibrary.simpleMessage(
      "Заблокировано",
    ),
    "connectionCloseThis": MessageLookupByLibrary.simpleMessage(
      "Закрыть это соединение",
    ),
    "connectionGroup": MessageLookupByLibrary.simpleMessage("Группа"),
    "connectionLocalDevice": MessageLookupByLibrary.simpleMessage(
      "Это устройство",
    ),
    "connectionMatchedRule": MessageLookupByLibrary.simpleMessage(
      "Совпавшее правило",
    ),
    "connectionProcessPath": MessageLookupByLibrary.simpleMessage(
      "Путь процесса",
    ),
    "connectionSearchHint": MessageLookupByLibrary.simpleMessage(
      "Поиск домена, приложения или правила",
    ),
    "connectionSniffedDomain": MessageLookupByLibrary.simpleMessage(
      "Обнаруженный домен",
    ),
    "connectionSourceAddress": MessageLookupByLibrary.simpleMessage(
      "Исходный адрес",
    ),
    "connectionStartTime": MessageLookupByLibrary.simpleMessage("Время начала"),
    "connectionStats": MessageLookupByLibrary.simpleMessage(
      "Статистика подключений",
    ),
    "connectionStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Подключения, запросы и DNS-запросы",
    ),
    "connectionSummary": m28,
    "connectionSustained": MessageLookupByLibrary.simpleMessage("Длительность"),
    "connectionTargetIp": MessageLookupByLibrary.simpleMessage("IP назначения"),
    "connectionTrafficPath": MessageLookupByLibrary.simpleMessage(
      "Маршрут трафика",
    ),
    "connections": MessageLookupByLibrary.simpleMessage("Соединения"),
    "connectionsAndRequests": MessageLookupByLibrary.simpleMessage(
      "Подключения и запросы",
    ),
    "connectionsLiveShort": MessageLookupByLibrary.simpleMessage("Активные"),
    "connectivity": MessageLookupByLibrary.simpleMessage("Подключение: "),
    "content": MessageLookupByLibrary.simpleMessage("Содержимое"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Содержимое не может быть пустым",
    ),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Управление глобальными добавленными правилами",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
    "copyAsBase64": MessageLookupByLibrary.simpleMessage(
      "Копировать как Base64",
    ),
    "copyAsCurl": MessageLookupByLibrary.simpleMessage("Копировать как cURL"),
    "copyDestination": MessageLookupByLibrary.simpleMessage(
      "Копировать адрес назначения",
    ),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Копировать переменные окружения",
    ),
    "copyHost": MessageLookupByLibrary.simpleMessage("Копировать хост"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Копировать ссылку"),
    "copyRequest": MessageLookupByLibrary.simpleMessage("Копировать запрос"),
    "copyResponse": MessageLookupByLibrary.simpleMessage("Копировать ответ"),
    "copyResponseBody": MessageLookupByLibrary.simpleMessage(
      "Копировать тело ответа",
    ),
    "copySubscriptionLink": MessageLookupByLibrary.simpleMessage(
      "Копировать ссылку подписки",
    ),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Скопировано"),
    "core": MessageLookupByLibrary.simpleMessage("Ядро"),
    "coreBlockedByPolicyTip": m29,
    "coreBlockedBySmartAppControlTip": MessageLookupByLibrary.simpleMessage(
      "Smart App Control в Windows заблокировал неподписанный TianjiCloudCore.exe. Откройте Безопасность Windows → Управление приложениями и браузером → Параметры Smart App Control, выберите «Выкл.» и снова запустите 天机云. Повторно включить Smart App Control без переустановки Windows нельзя.",
    ),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Статус ядра"),
    "country": MessageLookupByLibrary.simpleMessage("Регион"),
    "crashDetected": MessageLookupByLibrary.simpleMessage("Обнаружен сбой"),
    "crashDetectedTip": m30,
    "crashTest": MessageLookupByLibrary.simpleMessage("Тест сбоя"),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "createProfileFromUrlTip": m31,
    "creationTime": MessageLookupByLibrary.simpleMessage("Время создания"),
    "currentExpiry": MessageLookupByLibrary.simpleMessage("Истекает"),
    "currentOutboundDesc": MessageLookupByLibrary.simpleMessage(
      "Содержит кнопку запуска, удалить нельзя",
    ),
    "currentUsage": MessageLookupByLibrary.simpleMessage(
      "Использовано за период",
    ),
    "custom": MessageLookupByLibrary.simpleMessage("Вручную"),
    "customAddProxy": MessageLookupByLibrary.simpleMessage("Добавить прокси"),
    "customColor": MessageLookupByLibrary.simpleMessage("Свой цвет"),
    "customGroupMemberSummary": m32,
    "customGroupRuleUsage": m33,
    "customGroupsLabel": MessageLookupByLibrary.simpleMessage("Группы"),
    "customImportDroppedSubRules": m34,
    "customImportFromLink": MessageLookupByLibrary.simpleMessage(
      "Импортировать по ссылке",
    ),
    "customIssueCoreRejected": m35,
    "customIssueDialerLoop": m36,
    "customIssueDuplicateName": m37,
    "customIssueEmptyName": MessageLookupByLibrary.simpleMessage(
      "Имя не задано",
    ),
    "customIssueGroupLoop": m38,
    "customIssueInvalidEmptyFallback": m39,
    "customIssueInvalidFilter": m40,
    "customIssueMissingDialer": m41,
    "customIssueMissingProviders": m42,
    "customIssueMissingProxies": m43,
    "customIssueNoProxySource": MessageLookupByLibrary.simpleMessage(
      "Не выбраны ни прокси, ни провайдеры прокси, поэтому ядро отклонит эту группу",
    ),
    "customIssueReservedName": m44,
    "customIssuesSummary": m45,
    "customPreviewMerged": MessageLookupByLibrary.simpleMessage(
      "Предпросмотр итоговой конфигурации",
    ),
    "customProfile": MessageLookupByLibrary.simpleMessage("Пользовательский"),
    "customProvidersAndDialers": MessageLookupByLibrary.simpleMessage(
      "Провайдеры и цепочки",
    ),
    "customProxyCardTitle": MessageLookupByLibrary.simpleMessage(
      "Пользовательские прокси",
    ),
    "customProxyGroupUsage": m46,
    "customProxySubscriptionNote": MessageLookupByLibrary.simpleMessage(
      "Прокси подписки будут показаны вместе с этими прокси.",
    ),
    "customProxyUnreferenced": MessageLookupByLibrary.simpleMessage(
      "Не используется",
    ),
    "customResources": MessageLookupByLibrary.simpleMessage("Пользовательские"),
    "customRuleCardTitle": MessageLookupByLibrary.simpleMessage("Мои правила"),
    "customRulePresets": MessageLookupByLibrary.simpleMessage(
      "Добавить из набора",
    ),
    "cut": MessageLookupByLibrary.simpleMessage("Вырезать"),
    "dark": MessageLookupByLibrary.simpleMessage("Тёмная"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Панель"),
    "dashboardAddableSection": MessageLookupByLibrary.simpleMessage(
      "Можно добавить",
    ),
    "databaseWriteFailedTip": MessageLookupByLibrary.simpleMessage(
      "Не удалось сохранить изменение; оно отменено",
    ),
    "daysAgo": m47,
    "daysAgoShort": m48,
    "daysUnit": MessageLookupByLibrary.simpleMessage("дн."),
    "decryptUntrusted": MessageLookupByLibrary.simpleMessage(
      "Расшифровывать без локального доверия",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешает имена других DNS-серверов. Только IP-адреса.",
    ),
    "defaultSelected": MessageLookupByLibrary.simpleMessage(
      "Выбор по умолчанию",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("По умолчанию"),
    "definitionNotMap": MessageLookupByLibrary.simpleMessage(
      "Конфигурация должна быть YAML-словарём с полями name и type",
    ),
    "delay": MessageLookupByLibrary.simpleMessage("Задержка"),
    "delayFailed": MessageLookupByLibrary.simpleMessage("Сбой"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Тест задержки"),
    "delayTestTimeout": MessageLookupByLibrary.simpleMessage(
      "Тайм-аут теста задержки",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteMultipTip": m49,
    "deleteTip": m50,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Многоплатформенный прокси-клиент на основе ClashMeta: простой и удобный, с открытым исходным кодом и без рекламы.",
    ),
    "desktopAsnDescription": MessageLookupByLibrary.simpleMessage(
      "База данных автономных систем",
    ),
    "desktopFakeIpExplanation": MessageLookupByLibrary.simpleMessage(
      "198.18.0.0/16 — диапазон адресов fake-IP; реальные DNS-запросы выполняются на выходном узле, минуя местного провайдера.",
    ),
    "desktopGeoIpDescription": MessageLookupByLibrary.simpleMessage(
      "База данных местоположений IP",
    ),
    "desktopGeoSiteDescription": MessageLookupByLibrary.simpleMessage(
      "База категорий доменов",
    ),
    "desktopResourceLatest": MessageLookupByLibrary.simpleMessage("Актуально"),
    "desktopResourceUpdateNote": m51,
    "desktopRuleSetDescription": MessageLookupByLibrary.simpleMessage(
      "Правила из подписки",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Назначение"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "GeoIP назначения",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "ASN IP назначения",
    ),
    "details": m52,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Использует сторонний API; только для справки",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Режим разработчика"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Режим разработчика включён.",
    ),
    "diagnosticsFailed": MessageLookupByLibrary.simpleMessage("Не пройдено"),
    "diagnosticsPassed": MessageLookupByLibrary.simpleMessage("Пройдено"),
    "diagnosticsRunAgain": MessageLookupByLibrary.simpleMessage("Повторить"),
    "diagnosticsSelection": MessageLookupByLibrary.simpleMessage(
      "Проверка выхода маршрута по умолчанию",
    ),
    "diagnosticsStart": MessageLookupByLibrary.simpleMessage("Начать"),
    "diagnosticsTitle": MessageLookupByLibrary.simpleMessage(
      "Быстрая диагностика",
    ),
    "diagnosticsUnavailableNotice": MessageLookupByLibrary.simpleMessage(
      "Проверки выхода DNS, WebRTC браузера и NTP недоступны.",
    ),
    "diagnosticsUnverified": MessageLookupByLibrary.simpleMessage(
      "Не удалось проверить",
    ),
    "dialerProxy": MessageLookupByLibrary.simpleMessage(
      "Прокси для подключения",
    ),
    "dialerProxyLoopStopped": m53,
    "dialog": MessageLookupByLibrary.simpleMessage("Диалог"),
    "direct": MessageLookupByLibrary.simpleMessage("Прямой"),
    "directNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешает домены прямых соединений.",
    ),
    "disableIcmpForwarding": MessageLookupByLibrary.simpleMessage(
      "Отключить пересылку ICMP",
    ),
    "disableIcmpForwardingDesc": MessageLookupByLibrary.simpleMessage(
      "При отключённой пересылке ICMP TUN сам отвечает на ping, поэтому ping больше не показывает реальную задержку.",
    ),
    "disableKeepAlive": MessageLookupByLibrary.simpleMessage(
      "Отключить TCP keep-alive",
    ),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Отключить UDP"),
    "disabled": MessageLookupByLibrary.simpleMessage("Выключено"),
    "discardChanges": MessageLookupByLibrary.simpleMessage(
      "Отменить изменения?",
    ),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "Отказ от ответственности",
    ),
    "disclaimerAcceptContent": MessageLookupByLibrary.simpleMessage(
      "Это заявление описывает характер, риски и ответственность при использовании Программы. Оно не является дополнительным условием к GPL-3.0 и не ограничивает никаких прав, которые даёт вам эта лицензия, включая право запускать, копировать, изменять и распространять Программу. При расхождении действует GPL-3.0.",
    ),
    "disclaimerAcceptTitle": MessageLookupByLibrary.simpleMessage(
      "Связь с открытой лицензией",
    ),
    "disclaimerAcknowledgeLabel": MessageLookupByLibrary.simpleMessage(
      "Я прочитал(а) и понимаю это заявление",
    ),
    "disclaimerAcknowledgeTip": MessageLookupByLibrary.simpleMessage(
      "Чтобы подтвердить, что вы ознакомились с ним, прочитайте следующее заявление и отметьте пункт ниже:",
    ),
    "disclaimerAcknowledgeTitle": MessageLookupByLibrary.simpleMessage(
      "Подтвердите заявление",
    ),
    "disclaimerChangesContent": MessageLookupByLibrary.simpleMessage(
      "Это заявление может меняться в следующих версиях; к каждой версии относится заявление, поставляемое с ней.",
    ),
    "disclaimerChangesTitle": MessageLookupByLibrary.simpleMessage(
      "Изменения заявления",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Перед использованием 天机云 («Программа») внимательно прочитайте это заявление и убедитесь, что понимаете его. Нажимая «Согласен», вы подтверждаете, что прочитали и поняли изложенное ниже. Если не хотите продолжать, нажмите «Выход».",
    ),
    "disclaimerLiabilityContent": MessageLookupByLibrary.simpleMessage(
      "В максимальной степени, допустимой применимым законодательством, ни разработчики, ни участники проекта не несут ответственности за любой прямой, косвенный, случайный, особый, штрафной или последующий ущерб, возникший в результате использования или невозможности использования Программы, включая, помимо прочего, потерю данных, повреждение устройства, сбои сети, прерывание деятельности, упущенную выгоду или связанные с этим правовые споры, даже если они были предупреждены о возможности такого ущерба.",
    ),
    "disclaimerLiabilityTitle": MessageLookupByLibrary.simpleMessage(
      "Ограничение ответственности",
    ),
    "disclaimerLicenseContent": MessageLookupByLibrary.simpleMessage(
      "Программа распространяется с открытым исходным кодом по лицензии GPL-3.0. По этой лицензии вы можете запускать, изучать, изменять и распространять её; распространяя Программу или её изменённую версию, вы должны также предоставить исходный код по GPL-3.0 и сохранить исходные уведомления об авторских правах.\n\nСторонние компоненты Программы, включая ядро Clash.Meta, распространяются по своим лицензиям. Исходные авторы не отвечают за проблемы версий, изменённых или распространяемых другими.",
    ),
    "disclaimerLicenseTitle": MessageLookupByLibrary.simpleMessage(
      "Лицензия с открытым исходным кодом",
    ),
    "disclaimerNoServiceStatement": MessageLookupByLibrary.simpleMessage(
      "Сама Программа не предоставляет прокси-серверы, узлы, подписки или услуги доступа к сети и не состоит в партнёрских, агентских или гарантийных отношениях с поставщиками таких услуг.",
    ),
    "disclaimerPrivacyContent": MessageLookupByLibrary.simpleMessage(
      "Программа не собирает и не отправляет адреса ваших подписок, сведения об узлах, содержимое конфигураций, посещённые сайты, записи о подключениях, содержимое трафика и журналы. Эти данные хранятся только на вашем устройстве, и у разработчиков нет к ним доступа.\n\nПрограмма обращается к сети только при использовании соответствующих функций, например загружает указанный вами адрес подписки при обновлении профиля или обращается к GitHub при проверке обновлений.\n\nПрограмма не содержит никаких сервисов статистики или отчётов о сбоях ни на одной платформе.",
    ),
    "disclaimerPrivacyTitle": MessageLookupByLibrary.simpleMessage(
      "Сбор данных и конфиденциальность",
    ),
    "disclaimerResponsibilityContent": MessageLookupByLibrary.simpleMessage(
      "Вы самостоятельно убеждаетесь, что использование Программы законно в вашей стране или регионе, и единолично несёте юридическую ответственность за все действия с ней и их последствия.\n\nПодписки, узлы и конфигурации, которые вы импортируете, выбираете вы сами. Законность их источника, безопасность содержимого и надёжность сервиса — вопрос между вами и их поставщиками.",
    ),
    "disclaimerResponsibilityTitle": MessageLookupByLibrary.simpleMessage(
      "Ваша ответственность",
    ),
    "disclaimerRestateHint": MessageLookupByLibrary.simpleMessage(
      "Введите заявление выше",
    ),
    "disclaimerRestateMismatch": MessageLookupByLibrary.simpleMessage(
      "Не совпадает с текстом заявления",
    ),
    "disclaimerRestateTip": MessageLookupByLibrary.simpleMessage(
      "Чтобы подтвердить, что вы ознакомились с ним, полностью введите следующее заявление в поле ниже:",
    ),
    "disclaimerRestateTitle": MessageLookupByLibrary.simpleMessage(
      "Повторите заявление",
    ),
    "disclaimerSoftwareContent": MessageLookupByLibrary.simpleMessage(
      "Программа — это клиент сетевого прокси с открытым исходным кодом на основе ядра Clash.Meta (mihomo). Она предоставляет только локальные инструменты: управление конфигурациями, маршрутизацию по правилам и пересылку трафика.",
    ),
    "disclaimerSoftwareTitle": MessageLookupByLibrary.simpleMessage(
      "Характер программы",
    ),
    "disclaimerThirdPartyContent": MessageLookupByLibrary.simpleMessage(
      "Ссылки на подписки, файлы конфигурации, наборы правил, скрипты, внешние ресурсы и внешние ссылки предоставляются третьими лицами. Разработчики не могут проверять и не проверяют их законность, точность, безопасность и доступность и не дают на них никаких гарантий.\n\nУтечка данных, финансовые потери, блокировка аккаунта или иной ущерб, вызванные сторонним контентом, урегулируются между вами и третьим лицом; разработчики не несут за это никакой ответственности.",
    ),
    "disclaimerThirdPartyTitle": MessageLookupByLibrary.simpleMessage(
      "Сторонний контент",
    ),
    "disclaimerUsageContent": MessageLookupByLibrary.simpleMessage(
      "Любая коммерческая деятельность с использованием Программы, включая платное распространение, продажу в комплекте или использование в составе коммерческого сервиса, не связана с разработчиками Программы, которые её не одобряют, не поддерживают и не гарантируют.\n\nВы сами отвечаете за соблюдение законов страны или региона, где находитесь, и несёте последствия любого незаконного использования Программы.",
    ),
    "disclaimerUsageTitle": MessageLookupByLibrary.simpleMessage(
      "Об использовании",
    ),
    "disclaimerWarrantyContent": MessageLookupByLibrary.simpleMessage(
      "Программа предоставляется «как есть» и «по мере доступности», без каких-либо явных или подразумеваемых гарантий, включая, помимо прочего, гарантии товарной пригодности, пригодности для определённой цели, ненарушения прав, бесперебойной работы, отсутствия ошибок и уязвимостей.\n\nРазработчики не гарантируют, что Программа будет соответствовать вашим потребностям или работать без сбоев и ошибок.",
    ),
    "disclaimerWarrantyTitle": MessageLookupByLibrary.simpleMessage(
      "Отсутствие гарантий",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Отключено"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Доступна новая версия",
    ),
    "dnsBlocked": MessageLookupByLibrary.simpleMessage("Заблокировано"),
    "dnsCacheCleared": MessageLookupByLibrary.simpleMessage("Кэш DNS очищен"),
    "dnsExit": MessageLookupByLibrary.simpleMessage("Выход DNS"),
    "dnsExitUnavailable": MessageLookupByLibrary.simpleMessage(
      "Результат недоступен",
    ),
    "dnsHandling": MessageLookupByLibrary.simpleMessage("Обработка"),
    "dnsHijackDesc": MessageLookupByLibrary.simpleMessage(
      "Без этого параметра TUN перехватывает все DNS-запросы на порт 53 (any:53).",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("Перехват DNS"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Режим DNS"),
    "dnsOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Добавленные здесь параметры заменяют DNS всех профилей из URL и файлов; остальные остаются такими, как в профиле. DNS пользовательского профиля задаётся в его содержимом.",
    ),
    "dnsProxyRoute": MessageLookupByLibrary.simpleMessage("Через прокси"),
    "dnsQueries": MessageLookupByLibrary.simpleMessage("DNS-запросы"),
    "dnsResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "DNS и ресурсы",
    ),
    "dnsUpstream": MessageLookupByLibrary.simpleMessage("Вышестоящий DNS"),
    "docked": MessageLookupByLibrary.simpleMessage("Закреплённая"),
    "domain": MessageLookupByLibrary.simpleMessage("Домен"),
    "done": MessageLookupByLibrary.simpleMessage("Готово"),
    "download": MessageLookupByLibrary.simpleMessage("Загрузка"),
    "downloadBandwidth": MessageLookupByLibrary.simpleMessage(
      "Скорость загрузки",
    ),
    "downloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Загрузка обновления",
    ),
    "duration": MessageLookupByLibrary.simpleMessage("Длительность"),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editDashboard": MessageLookupByLibrary.simpleMessage("Изменить панель"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Редактировать глобальные правила",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Редактировать прокси"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Редактировать группу прокси",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Редактировать правило"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Изменить SSID"),
    "editorUnavailable": MessageLookupByLibrary.simpleMessage(
      "Редактор недоступен",
    ),
    "elapsed": MessageLookupByLibrary.simpleMessage("Время"),
    "emptyFallback": MessageLookupByLibrary.simpleMessage(
      "Резерв для пустой группы",
    ),
    "emptyTip": m54,
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "enabled": MessageLookupByLibrary.simpleMessage("Включено"),
    "entries": MessageLookupByLibrary.simpleMessage(" записей"),
    "error": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "errorDetails": MessageLookupByLibrary.simpleMessage("Подробности ошибки"),
    "es": MessageLookupByLibrary.simpleMessage("Испанский"),
    "eventAlerts": MessageLookupByLibrary.simpleMessage(
      "Уведомления о событиях",
    ),
    "exclude": MessageLookupByLibrary.simpleMessage("Скрыть из недавних задач"),
    "excludeDstPort": MessageLookupByLibrary.simpleMessage(
      "Исключённые порты назначения",
    ),
    "excludeFilter": MessageLookupByLibrary.simpleMessage("Фильтр исключения"),
    "excludeInterface": MessageLookupByLibrary.simpleMessage(
      "Исключённые интерфейсы",
    ),
    "excludeSrcPort": MessageLookupByLibrary.simpleMessage(
      "Исключённые исходные порты",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Исключённые SSID"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "При подключении к Wi-Fi с исключённым SSID состояние работы приложения переключается автоматически.",
    ),
    "excludeUid": MessageLookupByLibrary.simpleMessage(
      "Исключённые ID пользователей",
    ),
    "existsTip": m55,
    "exit": MessageLookupByLibrary.simpleMessage("Выход"),
    "exitFullScreen": MessageLookupByLibrary.simpleMessage(
      "Выйти из полноэкранного режима",
    ),
    "exitNodes": MessageLookupByLibrary.simpleMessage("Выходные узлы"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Ожидаемый статус"),
    "expireTime": MessageLookupByLibrary.simpleMessage("Срок действия"),
    "expiredStatus": MessageLookupByLibrary.simpleMessage("Истекла"),
    "exportCertificate": MessageLookupByLibrary.simpleMessage(
      "Экспортировать сертификат",
    ),
    "exportFile": MessageLookupByLibrary.simpleMessage("Экспорт файла"),
    "exportHar": MessageLookupByLibrary.simpleMessage("Экспорт HAR"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Экспорт логов"),
    "exportShort": MessageLookupByLibrary.simpleMessage("Экспорт"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Экспорт выполнен"),
    "extend": MessageLookupByLibrary.simpleMessage("Расширение"),
    "extendMode": MessageLookupByLibrary.simpleMessage("Режим расширения"),
    "extendOverridesScripts": MessageLookupByLibrary.simpleMessage(
      "Переопределения и скрипты расширения",
    ),
    "extendScript": MessageLookupByLibrary.simpleMessage("Скрипт расширения"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Внешний контроллер",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Внешний контроллер позволяет управлять ядром через порт 9090.",
    ),
    "externalControllerSecret": MessageLookupByLibrary.simpleMessage(
      "Секрет внешнего контроллера",
    ),
    "externalLink": MessageLookupByLibrary.simpleMessage("Внешняя ссылка"),
    "extraLarge": MessageLookupByLibrary.simpleMessage("Очень крупный"),
    "fade": MessageLookupByLibrary.simpleMessage("Растворение"),
    "failedCount": m56,
    "failedItem": m57,
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Фильтр Fake-IP"),
    "fakeipFilterDesc": MessageLookupByLibrary.simpleMessage(
      "Эти домены получают реальные IP вместо Fake-IP. В режиме whitelist Fake-IP получают только они.",
    ),
    "fakeipFilterMode": MessageLookupByLibrary.simpleMessage(
      "Режим фильтра Fake-IP",
    ),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Диапазон Fake-IP"),
    "fakeipRange6": MessageLookupByLibrary.simpleMessage(
      "Диапазон Fake-IP (IPv6)",
    ),
    "fakeipTtl": MessageLookupByLibrary.simpleMessage("TTL Fake-IP"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Используются вместо Nameserver, когда фильтр fallback считает его ответ подменённым.",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Фильтр fallback"),
    "fallbackFilterDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Эти домены сразу разрешаются через Fallback.",
    ),
    "fallbackFilterGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Домены из этих категорий GeoSite сразу разрешаются через Fallback.",
    ),
    "fallbackFilterIpcidrDesc": MessageLookupByLibrary.simpleMessage(
      "Если Nameserver возвращает IP из этих диапазонов, используется ответ Fallback.",
    ),
    "file": MessageLookupByLibrary.simpleMessage("Файл"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Файл изменён. Сохранить изменения?",
    ),
    "filter": MessageLookupByLibrary.simpleMessage("Фильтр"),
    "filters": MessageLookupByLibrary.simpleMessage("Фильтры"),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Поиск процесса"),
    "floating": MessageLookupByLibrary.simpleMessage("Плавающая"),
    "followProfile": MessageLookupByLibrary.simpleMessage("Как в профиле"),
    "followSystem": MessageLookupByLibrary.simpleMessage("Как в системе"),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Шрифт"),
    "fontSize": MessageLookupByLibrary.simpleMessage("Размер"),
    "forceDnsMapping": MessageLookupByLibrary.simpleMessage(
      "Принудительно для DNS-сопоставлений",
    ),
    "forceDnsMappingDesc": MessageLookupByLibrary.simpleMessage(
      "«Принудительно для DNS-сопоставлений» анализирует и соединения, домен которых получен из DNS-сопоставления.",
    ),
    "forceDomain": MessageLookupByLibrary.simpleMessage(
      "Принудительные домены",
    ),
    "forceDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Принудительные домены тоже анализируются; остальные соединения с доменом не затрагиваются.",
    ),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно перезапустить ядро?",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Французский"),
    "general": MessageLookupByLibrary.simpleMessage("Общие"),
    "generalOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Добавленные здесь параметры заменяют соответствующие настройки всех профилей; остальные остаются такими, как в профиле, а если профиль их не задаёт, действуют значения ядра по умолчанию.",
    ),
    "generateCertificate": MessageLookupByLibrary.simpleMessage(
      "Создать сертификат",
    ),
    "geoResources": MessageLookupByLibrary.simpleMessage("Geo"),
    "geoSkipped": m58,
    "geoUpdated": m59,
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo: экономия памяти",
    ),
    "global": MessageLookupByLibrary.simpleMessage("Глобальный"),
    "go": MessageLookupByLibrary.simpleMessage("Перейти"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Скачать"),
    "goToConfigureAddedRules": MessageLookupByLibrary.simpleMessage(
      "Перейти к настройке добавленных правил",
    ),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Перейти к настройке скрипта",
    ),
    "grid": MessageLookupByLibrary.simpleMessage("Сетка"),
    "groupBy": MessageLookupByLibrary.simpleMessage("Группировать"),
    "groupCount": m60,
    "groupCountUnit": MessageLookupByLibrary.simpleMessage("групп"),
    "groupTimeoutCount": m61,
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Кэшировать изменения?",
    ),
    "hashByInUser": MessageLookupByLibrary.simpleMessage(
      "Хешировать по пользователю входящего подключения",
    ),
    "headerRewrite": MessageLookupByLibrary.simpleMessage(
      "Перезапись заголовков",
    ),
    "healthCheck": MessageLookupByLibrary.simpleMessage("Проверка состояния"),
    "helperCorruptTip": MessageLookupByLibrary.simpleMessage(
      "Служба Helper недоступна, поэтому TUN-режим включить нельзя. Переустановите 天机云.",
    ),
    "hex": MessageLookupByLibrary.simpleMessage("Hex"),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Скрыть из списка"),
    "hideIp": MessageLookupByLibrary.simpleMessage("Скрыть IP"),
    "hidePassword": MessageLookupByLibrary.simpleMessage("Скрыть пароль"),
    "hideTimeoutProxies": MessageLookupByLibrary.simpleMessage(
      "Скрывать прокси с таймаутом",
    ),
    "hopInterval": MessageLookupByLibrary.simpleMessage("Интервал перескока"),
    "host": MessageLookupByLibrary.simpleMessage("Хост"),
    "hostname": MessageLookupByLibrary.simpleMessage("Имя хоста"),
    "hotkeyConflictWith": m62,
    "hotkeyDesc": MessageLookupByLibrary.simpleMessage(
      "Глобальные горячие клавиши работают, даже когда окно скрыто. Нажмите на действие, чтобы записать сочетание клавиш.",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage("Горячие клавиши"),
    "hotkeyNeedsModifier": m63,
    "hotkeyNotSet": MessageLookupByLibrary.simpleMessage("Не задано"),
    "hotkeyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Не зарегистрировано: сочетание может быть занято другим приложением",
    ),
    "hours": MessageLookupByLibrary.simpleMessage("часов"),
    "hoursAgo": m64,
    "hoursAgoShort": m65,
    "http2": MessageLookupByLibrary.simpleMessage("HTTP/2"),
    "httpBodyNotKept": MessageLookupByLibrary.simpleMessage(
      "Не записано: не хватало памяти.",
    ),
    "httpBodyProtobufGuess": MessageLookupByLibrary.simpleMessage(
      "Прочитано как Protobuf без схемы: только номера полей, типы предполагаемые.",
    ),
    "httpBodyTruncated": MessageLookupByLibrary.simpleMessage(
      "Записано только начало тела.",
    ),
    "httpBodyUndecoded": m66,
    "httpCapture": MessageLookupByLibrary.simpleMessage("Захват HTTP"),
    "httpCaptureDesc": MessageLookupByLibrary.simpleMessage(
      "Записывает запросы к хостам из списка имён хостов; их можно посмотреть в сведениях о соединении. Записи хранятся только в памяти.",
    ),
    "httpCaptureLimit": MessageLookupByLibrary.simpleMessage(
      "Максимум записей",
    ),
    "httpCaptureLimitDesc": m67,
    "httpCaptureNoHosts": MessageLookupByLibrary.simpleMessage(
      "Хосты не указаны, поэтому ничего не записывается. Добавьте их в поле «Имя хоста» на странице MITM или из сведений о соединении.",
    ),
    "httpCaptureOff": MessageLookupByLibrary.simpleMessage("Захват выключен"),
    "httpExportPrivate": MessageLookupByLibrary.simpleMessage(
      "Запрос может содержать cookie, токены, пароли и данные форм. Проверьте, что и кому вы передаёте.",
    ),
    "httpExportPrivateTitle": MessageLookupByLibrary.simpleMessage(
      "Содержит личные данные",
    ),
    "httpRequestCleared": MessageLookupByLibrary.simpleMessage(
      "Запись этого запроса удалена",
    ),
    "httpRequests": MessageLookupByLibrary.simpleMessage("HTTP-запросы"),
    "httpRequestsMissing": MessageLookupByLibrary.simpleMessage(
      "Запросы, отправленные до включения захвата или уже удалённые, не показаны.",
    ),
    "httpsDecryption": MessageLookupByLibrary.simpleMessage(
      "Расшифровка HTTPS",
    ),
    "hue": MessageLookupByLibrary.simpleMessage("Оттенок"),
    "icon": MessageLookupByLibrary.simpleMessage("Значок"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("История значков"),
    "iconSets": MessageLookupByLibrary.simpleMessage("Наборы значков"),
    "iconSetsEmptyTip": MessageLookupByLibrary.simpleMessage(
      "Наборов значков пока нет. Добавьте их в разделе «Ресурсы пользовательских профилей → Наборы значков»",
    ),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Стиль значков"),
    "iconStyleFilled": MessageLookupByLibrary.simpleMessage("С подложкой"),
    "iconStyleHidden": MessageLookupByLibrary.simpleMessage("Скрыто"),
    "iconStylePlain": MessageLookupByLibrary.simpleMessage("Без подложки"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("URL значка"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Игнорировать оптимизацию батареи",
    ),
    "immediateUpdate": MessageLookupByLibrary.simpleMessage("Обновить сейчас"),
    "import": MessageLookupByLibrary.simpleMessage("Импорт"),
    "importConfigInvalid": MessageLookupByLibrary.simpleMessage(
      "Этот файл не является конфигурацией, которую можно импортировать",
    ),
    "importConfigReplaceTip": MessageLookupByLibrary.simpleMessage(
      "Импорт заменит текущие группы прокси, правила и настройки этого профиля",
    ),
    "importFile": MessageLookupByLibrary.simpleMessage("Импорт из файла"),
    "importFromLink": MessageLookupByLibrary.simpleMessage("Импорт по ссылке"),
    "importSubscription": MessageLookupByLibrary.simpleMessage(
      "Импортировать подписку",
    ),
    "importUrl": MessageLookupByLibrary.simpleMessage("Импорт по URL"),
    "inProgress": MessageLookupByLibrary.simpleMessage("Выполняется"),
    "inUse": MessageLookupByLibrary.simpleMessage("Используется"),
    "inbound": MessageLookupByLibrary.simpleMessage("Входящие"),
    "includeInterface": MessageLookupByLibrary.simpleMessage(
      "Включённые интерфейсы",
    ),
    "includeInterfaceDesc": MessageLookupByLibrary.simpleMessage(
      "Через TUN идёт только трафик с включённых интерфейсов, а исключённые интерфейсы больше не действуют.",
    ),
    "includeUid": MessageLookupByLibrary.simpleMessage(
      "Включённые ID пользователей",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Бессрочно"),
    "init": MessageLookupByLibrary.simpleMessage("Инициализация"),
    "initFailed": MessageLookupByLibrary.simpleMessage("Не удалось запустить"),
    "initFailedTip": MessageLookupByLibrary.simpleMessage(
      "При запуске 天机云 произошла ошибка, и работа не может быть продолжена. Скопируйте подробности, чтобы сообщить о проблеме. Если ошибка повторяется, очистка данных обычно позволяет снова запустить приложение.",
    ),
    "initiator": MessageLookupByLibrary.simpleMessage("Инициатор"),
    "initiatorShort": MessageLookupByLibrary.simpleMessage("Источник"),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Введите название группы прокси",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Введите содержимое правила",
    ),
    "installCertificate": MessageLookupByLibrary.simpleMessage(
      "Установить в систему",
    ),
    "installCertificateSuccess": MessageLookupByLibrary.simpleMessage(
      "Сертификат установлен",
    ),
    "installedAppsPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Разрешение на список приложений отклонено, поэтому установленные приложения недоступны. Предоставьте его вручную в системных настройках.",
    ),
    "installedAppsPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "Эта система не выдаёт список установленных приложений без разрешения. Предоставьте его, чтобы настроить прокси для отдельных приложений.",
    ),
    "installedAppsPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется разрешение на список приложений",
    ),
    "installedFonts": MessageLookupByLibrary.simpleMessage(
      "Установленные шрифты",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage("Умный выбор"),
    "intercept": MessageLookupByLibrary.simpleMessage("Блокировка"),
    "interfaceName": MessageLookupByLibrary.simpleMessage("Имя интерфейса"),
    "interfaceNameMode": MessageLookupByLibrary.simpleMessage(
      "Исходящий интерфейс",
    ),
    "interfaceNameModeClear": MessageLookupByLibrary.simpleMessage("Очистить"),
    "interfaceNameModeCustom": MessageLookupByLibrary.simpleMessage("Вручную"),
    "interfaceNameModeFollow": MessageLookupByLibrary.simpleMessage(
      "Как в конфигурации",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Интернет"),
    "interval": MessageLookupByLibrary.simpleMessage("Интервал"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Внутренний IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Недопустимый файл резервной копии",
    ),
    "invalidCidrContent": MessageLookupByLibrary.simpleMessage(
      "Введите диапазон IP в формате CIDR, например 192.168.0.0/16",
    ),
    "invalidDscpContent": MessageLookupByLibrary.simpleMessage(
      "Метка DSCP не может превышать 63",
    ),
    "invalidHostContent": MessageLookupByLibrary.simpleMessage(
      "Введите домен или IP-адрес",
    ),
    "invalidIconSet": MessageLookupByLibrary.simpleMessage(
      "Это не набор значков",
    ),
    "invalidLinkTip": MessageLookupByLibrary.simpleMessage(
      "Это не ссылка на подписку и не ссылка на прокси",
    ),
    "invalidListenContent": MessageLookupByLibrary.simpleMessage(
      "Введите адрес и порт, например 0.0.0.0:1053",
    ),
    "invalidNetworkContent": MessageLookupByLibrary.simpleMessage(
      "Поддерживаются только tcp и udp",
    ),
    "invalidOfCount": m68,
    "invalidPolicy": m69,
    "invalidPortRangeContent": MessageLookupByLibrary.simpleMessage(
      "Введите порт или диапазон, например 443 или 8000-9000",
    ),
    "invalidProfileQrcode": MessageLookupByLibrary.simpleMessage(
      "Этот QR-код не содержит ссылку на профиль",
    ),
    "invalidProxy": m70,
    "invalidProxyProvider": m71,
    "invalidRangeContent": MessageLookupByLibrary.simpleMessage(
      "Введите числа или диапазоны, например 80 или 8000-9000, через /",
    ),
    "invalidRuleSet": m72,
    "invalidSubRule": m73,
    "ipAddress": MessageLookupByLibrary.simpleMessage("IP-адрес"),
    "ipAsn": MessageLookupByLibrary.simpleMessage("ASN"),
    "ipFlagAbuser": MessageLookupByLibrary.simpleMessage("Злоупотребления"),
    "ipFlagProxy": MessageLookupByLibrary.simpleMessage("Прокси"),
    "ipFlagTor": MessageLookupByLibrary.simpleMessage("Tor"),
    "ipFlagVpn": MessageLookupByLibrary.simpleMessage("VPN"),
    "ipFlags": MessageLookupByLibrary.simpleMessage("Метки"),
    "ipOrganization": MessageLookupByLibrary.simpleMessage("Организация"),
    "ipQualityFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось определить тип IP",
    ),
    "ipQualityGood": MessageLookupByLibrary.simpleMessage("Хороший"),
    "ipQualityLevel": MessageLookupByLibrary.simpleMessage("Уровень"),
    "ipQualityNormal": MessageLookupByLibrary.simpleMessage("Обычный"),
    "ipQualityRetry": MessageLookupByLibrary.simpleMessage("Проверить снова"),
    "ipQualityRisky": MessageLookupByLibrary.simpleMessage("Рискованный"),
    "ipQualityShort": MessageLookupByLibrary.simpleMessage("Качество"),
    "ipQualitySource": MessageLookupByLibrary.simpleMessage("Источник ответа"),
    "ipQualitySources": MessageLookupByLibrary.simpleMessage("Источники"),
    "ipSourceIpMismatch": MessageLookupByLibrary.simpleMessage(
      "Другой исходящий IP",
    ),
    "ipSourceNoType": MessageLookupByLibrary.simpleMessage("Тип не определён"),
    "ipSourceRateLimited": MessageLookupByLibrary.simpleMessage(
      "Лимит запросов",
    ),
    "ipType": MessageLookupByLibrary.simpleMessage("Тип"),
    "ipTypeBusiness": MessageLookupByLibrary.simpleMessage("Бизнес"),
    "ipTypeHosting": MessageLookupByLibrary.simpleMessage("Дата-центр"),
    "ipTypeMobile": MessageLookupByLibrary.simpleMessage("Мобильная сеть"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Домашний"),
    "ipTypeUnknown": MessageLookupByLibrary.simpleMessage("Тип неизвестен"),
    "ipVersion": MessageLookupByLibrary.simpleMessage("Версия IP"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "Трафик IPv6 принимается, только когда IPv6 включён.",
    ),
    "ipv6Timeout": MessageLookupByLibrary.simpleMessage("Тайм-аут IPv6 (мс)"),
    "itemsCount": m74,
    "ja": MessageLookupByLibrary.simpleMessage("Японский"),
    "justNow": MessageLookupByLibrary.simpleMessage("Только что"),
    "keepAliveIdle": MessageLookupByLibrary.simpleMessage(
      "Простой TCP keep-alive",
    ),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Интервал TCP keep-alive",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Ключ"),
    "ko": MessageLookupByLibrary.simpleMessage("Корейский"),
    "label": MessageLookupByLibrary.simpleMessage("Метка"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "large": MessageLookupByLibrary.simpleMessage("Крупный"),
    "lastUpdated": MessageLookupByLibrary.simpleMessage("Последнее обновление"),
    "launchInterrupted": MessageLookupByLibrary.simpleMessage(
      "Запуск не завершён",
    ),
    "launchInterruptedTip": MessageLookupByLibrary.simpleMessage(
      "В прошлый раз приложение неожиданно завершилось во время запуска. Автоматическая настройка для этого запуска пропущена; вы можете запустить её вручную.",
    ),
    "layout": MessageLookupByLibrary.simpleMessage("Макет"),
    "light": MessageLookupByLibrary.simpleMessage("Светлая"),
    "lineIssueTip": m75,
    "lineRate": MessageLookupByLibrary.simpleMessage("Тариф"),
    "lineWrap": MessageLookupByLibrary.simpleMessage("Перенос строк"),
    "link": MessageLookupByLibrary.simpleMessage("Ссылка"),
    "liquidGlass": MessageLookupByLibrary.simpleMessage("Жидкое стекло"),
    "list": MessageLookupByLibrary.simpleMessage("Список"),
    "listen": MessageLookupByLibrary.simpleMessage("Прослушивание"),
    "listenRoutingMark": MessageLookupByLibrary.simpleMessage(
      "Метка маршрутизации",
    ),
    "listenRoutingMarkDesc": MessageLookupByLibrary.simpleMessage(
      "Метка маршрутизации действует только в Linux.",
    ),
    "liveConnections": MessageLookupByLibrary.simpleMessage(
      "Активные подключения",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка…"),
    "local": MessageLookupByLibrary.simpleMessage("Локально"),
    "localFile": MessageLookupByLibrary.simpleMessage("Локальный файл"),
    "localImage": MessageLookupByLibrary.simpleMessage("Локальное изображение"),
    "localNetworkDeniedTip": MessageLookupByLibrary.simpleMessage(
      "Доступ к локальной сети запрещён: используется стек gvisor, локальная сеть недоступна.",
    ),
    "localProxies": MessageLookupByLibrary.simpleMessage("Локальные прокси"),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Разрешение на геолокацию",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Разрешение на геолокацию отклонено, поэтому невозможно получить имя текущей сети Wi-Fi. Включите разрешение на геолокацию вручную в системных настройках.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "По требованию системы для получения имени сети Wi-Fi необходимо разрешение на геолокацию. На Android выберите «Разрешить всегда», иначе имя сети Wi-Fi нельзя получить, пока приложение в фоне.",
    ),
    "locationPermissionGuide": m76,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Требуется разрешение на геолокацию",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Лог"),
    "logFilterError": MessageLookupByLibrary.simpleMessage("Ошибки"),
    "logFilterInfo": MessageLookupByLibrary.simpleMessage("Информация"),
    "logFilterWarning": MessageLookupByLibrary.simpleMessage("Предупреждения"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Уровень логов"),
    "logcat": MessageLookupByLibrary.simpleMessage("Захват логов"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "При отключении захвата логов раздел логов скрывается.",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Логи"),
    "logsAndDiagnostics": MessageLookupByLibrary.simpleMessage(
      "Логи и диагностика",
    ),
    "logsRunning": MessageLookupByLibrary.simpleMessage("Журнал работы"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Тест логов"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Снятие ограничения loopback для UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Свободный"),
    "mainlandDirect": MessageLookupByLibrary.simpleMessage(
      "Прямое соединение (материк)",
    ),
    "mapLocal": MessageLookupByLibrary.simpleMessage("Локальная подмена"),
    "matchCase": MessageLookupByLibrary.simpleMessage("Учитывать регистр"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage(
      "Сопоставлять IP источника",
    ),
    "matchTarget": MessageLookupByLibrary.simpleMessage("MATCH-TARGET"),
    "matchedRules": MessageLookupByLibrary.simpleMessage("Сработавшие правила"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage(
      "Макс. число неудач",
    ),
    "maxLengthTip": m77,
    "maximize": MessageLookupByLibrary.simpleMessage("Развернуть"),
    "memoryAppResident": MessageLookupByLibrary.simpleMessage(
      "Резидентная память",
    ),
    "memoryAppShared": MessageLookupByLibrary.simpleMessage(
      "Приложение и общая",
    ),
    "memoryCoreHeapIdle": MessageLookupByLibrary.simpleMessage(
      "Свободная куча",
    ),
    "memoryCoreHeapInuse": MessageLookupByLibrary.simpleMessage(
      "Используемая куча",
    ),
    "memoryCoreNotRunning": MessageLookupByLibrary.simpleMessage(
      "Ядро не запущено",
    ),
    "memoryCoreRuntime": MessageLookupByLibrary.simpleMessage(
      "Накладные расходы среды",
    ),
    "memoryCoreStack": MessageLookupByLibrary.simpleMessage("Стеки горутин"),
    "memoryEstimateDesc": MessageLookupByLibrary.simpleMessage(
      "Оценка по резидентной памяти процессов; может отличаться от данных системы.",
    ),
    "memoryEstimateSharedDesc": MessageLookupByLibrary.simpleMessage(
      "Ядро работает в процессе приложения. Его доля оценивается по статистике среды выполнения, остальное относится к приложению и общей памяти.",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Память"),
    "memoryInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Память приложения и ядра",
    ),
    "memoryReleased": MessageLookupByLibrary.simpleMessage(
      "Память освобождена",
    ),
    "memoryReleasedSize": m78,
    "messageTest": MessageLookupByLibrary.simpleMessage("Тест сообщения"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("Это сообщение."),
    "method": MessageLookupByLibrary.simpleMessage("Метод"),
    "minimize": MessageLookupByLibrary.simpleMessage("Свернуть"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Сворачивать при выходе",
    ),
    "minutes": MessageLookupByLibrary.simpleMessage("минут"),
    "minutesAgo": m79,
    "minutesAgoShort": m80,
    "mitm": MessageLookupByLibrary.simpleMessage("MITM"),
    "mitmAddLocalFile": MessageLookupByLibrary.simpleMessage(
      "Добавить локальный файл",
    ),
    "mitmAddMapLocalRule": MessageLookupByLibrary.simpleMessage(
      "Добавить правило локальной подмены",
    ),
    "mitmAddRejectRule": MessageLookupByLibrary.simpleMessage(
      "Добавить правило блокировки",
    ),
    "mitmAttachments": MessageLookupByLibrary.simpleMessage("Вложения"),
    "mitmAttachmentsDesc": MessageLookupByLibrary.simpleMessage(
      "Строки ссылаются на вложения по имени файла, например script-path=a.js.",
    ),
    "mitmCertificateAndroidReadyTip": MessageLookupByLibrary.simpleMessage(
      "Расшифровываются только приложения, доверяющие пользовательским сертификатам, в основном браузеры.",
    ),
    "mitmCertificateExportTip": MessageLookupByLibrary.simpleMessage(
      "Экспортируйте его и добавьте в доверенные на устройствах, трафик которых нужно расшифровывать.",
    ),
    "mitmCertificateLinuxTip": MessageLookupByLibrary.simpleMessage(
      "В браузеры из Flatpak экспортированный сертификат нужно импортировать вручную.",
    ),
    "mitmCertificateSavedTip": m81,
    "mitmCertutilMissing": m82,
    "mitmClientRefusedCertificate": MessageLookupByLibrary.simpleMessage(
      "Клиент отклонил сертификат. Установите сертификат или исключите этот хост, если приложение закрепляет свой сертификат.",
    ),
    "mitmDecryptHost": MessageLookupByLibrary.simpleMessage(
      "Расшифровывать этот хост",
    ),
    "mitmDecryptHostTip": m83,
    "mitmEnableTip": MessageLookupByLibrary.simpleMessage(
      "天机云 сможет читать всё, что отправляется на расшифровываемые узлы, включая cookie и пароли. Включайте только для узлов, которые нужно перезаписывать.",
    ),
    "mitmExcludeHost": MessageLookupByLibrary.simpleMessage(
      "Исключить из расшифровки",
    ),
    "mitmExcludeHostTip": m84,
    "mitmFileTooLarge": m85,
    "mitmHostnameDesc": MessageLookupByLibrary.simpleMessage(
      "Префикс - исключает хост; действует первое совпадение.",
    ),
    "mitmIgnoredLines": MessageLookupByLibrary.simpleMessage(
      "Пропущенные строки",
    ),
    "mitmInstallSystemCaTip": MessageLookupByLibrary.simpleMessage(
      "Обнаружен root: сертификат будет добавлен в доверенные сертификаты системы как модуль Magisk, KernelSU или APatch «TianjiCloud MITM CA». После этого ему будут доверять все приложения устройства, а любой, у кого есть его закрытый ключ, сможет расшифровать HTTPS-трафик устройства. Чтобы отменить это, создайте сертификат заново или удалите модуль в root-менеджере и перезагрузите устройство. Если в root отказано, сертификат будет установлен как пользовательский.",
    ),
    "mitmInstallUserCaTip": MessageLookupByLibrary.simpleMessage(
      "Root не обнаружен: сертификат можно установить только как пользовательский. Расшифровываются только приложения, доверяющие пользовательским сертификатам, в основном браузеры; остальные не смогут подключиться к указанным узлам, поэтому не указывайте их узлы. Начиная с Android 11 установку нужно завершить вручную в настройках системы.",
    ),
    "mitmMissingStores": m86,
    "mitmModule": MessageLookupByLibrary.simpleMessage("Модуль"),
    "mitmModuleInvalid": MessageLookupByLibrary.simpleMessage(
      "Это не модуль Surge, не плагин Loon, не фрагмент Quantumult X и не переопределение Stash",
    ),
    "mitmModuleRulesDesc": MessageLookupByLibrary.simpleMessage(
      "Правила маршрутизации идут перед правилами профиля.",
    ),
    "mitmModuleScriptsChanged": m87,
    "mitmModuleSystemTip": m88,
    "mitmModules": MessageLookupByLibrary.simpleMessage("Модули"),
    "mitmNewModule": MessageLookupByLibrary.simpleMessage("Новый модуль"),
    "mitmOldCertificateLeftTip": m89,
    "mitmOldSystemCertificateLeftTip": m90,
    "mitmRemoveOldCertificateTip": m91,
    "mitmRootPendingReboot": MessageLookupByLibrary.simpleMessage(
      "Сертификат начнёт действовать после перезагрузки устройства.",
    ),
    "mitmRootUntilReboot": MessageLookupByLibrary.simpleMessage(
      "Не найден Magisk, KernelSU или APatch, чтобы сохранить сертификат. После перезагрузки устройства установите его снова.",
    ),
    "mitmRoutingRules": MessageLookupByLibrary.simpleMessage(
      "Правила маршрутизации",
    ),
    "mitmRuleCopiedForStash": MessageLookupByLibrary.simpleMessage(
      "Этот модуль — переопределение Stash, поэтому правило скопировано, добавьте его вручную.",
    ),
    "mitmRunScript": MessageLookupByLibrary.simpleMessage("Запустить сейчас"),
    "mitmScriptNoOutput": MessageLookupByLibrary.simpleMessage(
      "Скрипт завершился без вывода",
    ),
    "mitmScriptRisk": MessageLookupByLibrary.simpleMessage(
      "Его скрипты читают и меняют трафик подходящих хостов, включая файлы cookie и токены, и могут сами отправлять запросы. Включайте, только если доверяете источнику.",
    ),
    "mitmScriptRiskTitle": MessageLookupByLibrary.simpleMessage(
      "Запускать скрипты этого модуля?",
    ),
    "mitmSkipConditional": MessageLookupByLibrary.simpleMessage(
      "Условные перезаписи не поддерживаются",
    ),
    "mitmSkipDisabled": MessageLookupByLibrary.simpleMessage(
      "Отключено аргументом",
    ),
    "mitmSkipEvent": MessageLookupByLibrary.simpleMessage(
      "Это событие не поддерживается",
    ),
    "mitmSkipJq": MessageLookupByLibrary.simpleMessage(
      "Перезаписи jq не поддерживаются",
    ),
    "mitmSkipJsonBody": MessageLookupByLibrary.simpleMessage(
      "Перезаписи тела JSON не поддерживаются",
    ),
    "mitmSkipNotDownloaded": MessageLookupByLibrary.simpleMessage(
      "Его файл ещё не загружен",
    ),
    "mitmSkipPolicy": MessageLookupByLibrary.simpleMessage(
      "Поддерживаются только политики DIRECT и REJECT",
    ),
    "mitmSkipRawHeader": MessageLookupByLibrary.simpleMessage(
      "Перезапись всех заголовков как одного текста не поддерживается",
    ),
    "mitmSkipRelativeData": MessageLookupByLibrary.simpleMessage(
      "Файл из этой строки не прикреплён; укажите URL или прикрепите его",
    ),
    "mitmSkipRule": MessageLookupByLibrary.simpleMessage(
      "Этот тип правила не поддерживается",
    ),
    "mitmSkipScriptType": MessageLookupByLibrary.simpleMessage(
      "Этот тип скриптов не поддерживается",
    ),
    "mitmSkipSection": m92,
    "mitmSkipSetting": MessageLookupByLibrary.simpleMessage(
      "Этот параметр не поддерживается",
    ),
    "mitmSkipUnreadable": MessageLookupByLibrary.simpleMessage(
      "Эту строку не удалось прочитать",
    ),
    "mitmSystemStoreFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось добавить сертификат в доверенные корневые сертификаты системы",
    ),
    "mitmTrustChecking": MessageLookupByLibrary.simpleMessage("Проверка…"),
    "mitmTrustNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Не установлен",
    ),
    "mitmTrustReady": MessageLookupByLibrary.simpleMessage("Доверенный"),
    "mitmTrustUntrusted": MessageLookupByLibrary.simpleMessage(
      "Доверие неполное",
    ),
    "mixedPort": MessageLookupByLibrary.simpleMessage("Смешанный порт"),
    "mobilePlanValidity": MessageLookupByLibrary.simpleMessage(
      "Срок действия тарифа",
    ),
    "mobileRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Осталось трафика",
    ),
    "mode": MessageLookupByLibrary.simpleMessage("Режим"),
    "monochromeIcon": MessageLookupByLibrary.simpleMessage(
      "Монохромный значок",
    ),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Монохром"),
    "monthsAgo": m93,
    "monthsAgoShort": m94,
    "more": MessageLookupByLibrary.simpleMessage("Ещё"),
    "name": MessageLookupByLibrary.simpleMessage("Название"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "DNS-серверы по умолчанию, например 223.5.5.5, tls://1.1.1.1 или https://dns.google/dns-query.",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Совпавшие домены используют указанный здесь DNS-сервер вместо Nameserver и Fallback.",
    ),
    "navigationBarStyle": MessageLookupByLibrary.simpleMessage("Нижняя панель"),
    "network": MessageLookupByLibrary.simpleMessage("Сеть"),
    "networkAccessDeniedError": m95,
    "networkBadResponseError": m96,
    "networkCancelledError": MessageLookupByLibrary.simpleMessage(
      "Запрос отменён",
    ),
    "networkConnectionError": MessageLookupByLibrary.simpleMessage(
      "Не удалось подключиться к серверу. Проверьте подключение к сети или настройки прокси",
    ),
    "networkHostLookupError": MessageLookupByLibrary.simpleMessage(
      "Не удалось определить адрес сервера. Проверьте правильность URL и работу DNS",
    ),
    "networkName": MessageLookupByLibrary.simpleMessage("Имя сети"),
    "networkNotFoundError": m97,
    "networkRateLimitedError": MessageLookupByLibrary.simpleMessage(
      "Слишком много запросов (HTTP 429). Подождите немного и повторите попытку",
    ),
    "networkRequestFailed": m98,
    "networkSecret": MessageLookupByLibrary.simpleMessage("Секрет сети"),
    "networkServerError": m99,
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Скорость сети"),
    "networkTakeover": MessageLookupByLibrary.simpleMessage("Перехват трафика"),
    "networkTimeoutError": MessageLookupByLibrary.simpleMessage(
      "Время ожидания запроса истекло. Проверьте сеть или прокси и повторите попытку",
    ),
    "networkTlsError": MessageLookupByLibrary.simpleMessage(
      "Не удалось установить защищённое соединение. Сертификат сервера может быть недействителен, или соединение перехватывается",
    ),
    "networkType": MessageLookupByLibrary.simpleMessage("Тип сети"),
    "nextMatch": MessageLookupByLibrary.simpleMessage("Следующее совпадение"),
    "no": MessageLookupByLibrary.simpleMessage("Нет"),
    "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Нет информации"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Больше не напоминать",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Нет сети"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Приложения без сети"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Не разрешать IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Не разрешать имя хоста",
    ),
    "noSearchResults": MessageLookupByLibrary.simpleMessage(
      "Ничего не найдено",
    ),
    "nodes": MessageLookupByLibrary.simpleMessage("Узлы"),
    "nonTextProviderFile": MessageLookupByLibrary.simpleMessage(
      "Этот внешний ресурс не является текстовым файлом",
    ),
    "none": MessageLookupByLibrary.simpleMessage("Нет"),
    "notRunning": MessageLookupByLibrary.simpleMessage("Не запущено"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Текущую группу прокси нельзя выбрать",
    ),
    "ntpInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал синхронизации (минуты)",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Добавьте профиль, чтобы начать",
    ),
    "nullTip": m100,
    "numberRangeTip": m101,
    "numberTip": m102,
    "obfs": MessageLookupByLibrary.simpleMessage("Обфускация"),
    "obfsHost": MessageLookupByLibrary.simpleMessage("Хост обфускации"),
    "obfsMode": MessageLookupByLibrary.simpleMessage("Режим обфускации"),
    "obfsParam": MessageLookupByLibrary.simpleMessage("Параметр обфускации"),
    "obfsPassword": MessageLookupByLibrary.simpleMessage("Пароль обфускации"),
    "onDemand": MessageLookupByLibrary.simpleMessage("По условию"),
    "onboardingCheckingInternet": MessageLookupByLibrary.simpleMessage(
      "Проверяем доступ в интернет…",
    ),
    "onboardingClipboardEmpty": MessageLookupByLibrary.simpleMessage(
      "В буфере обмена ничего нет",
    ),
    "onboardingConfirmNote": MessageLookupByLibrary.simpleMessage(
      "Перед импортом проверьте полную ссылку на подписку выше.",
    ),
    "onboardingConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Подписка Tianji Cloud",
    ),
    "onboardingConnect": MessageLookupByLibrary.simpleMessage("Подключиться"),
    "onboardingConnectFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось подключиться. Попробуйте позже.",
    ),
    "onboardingConnected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "onboardingConnectedNoInternet": MessageLookupByLibrary.simpleMessage(
      "Подключено, но интернет недоступен",
    ),
    "onboardingConnecting": MessageLookupByLibrary.simpleMessage(
      "Подключаемся…",
    ),
    "onboardingConnectingDescription": MessageLookupByLibrary.simpleMessage(
      "После подключения приложение сделает реальный запрос в интернет для проверки.",
    ),
    "onboardingContinue": MessageLookupByLibrary.simpleMessage("Продолжить"),
    "onboardingDescription": MessageLookupByLibrary.simpleMessage(
      "Вставьте или отсканируйте ссылку на подписку из панели и подключитесь за несколько шагов.",
    ),
    "onboardingExit": MessageLookupByLibrary.simpleMessage("Выход"),
    "onboardingExpireDate": MessageLookupByLibrary.simpleMessage("Истекает"),
    "onboardingFailureEmptyDescription": MessageLookupByLibrary.simpleMessage(
      "Возможно, срок тарифа истёк или месячный трафик израсходован. Продлите или сбросьте трафик, затем нажмите «Повторить».",
    ),
    "onboardingFailureEmptyTitle": MessageLookupByLibrary.simpleMessage(
      "В подписке нет доступных узлов",
    ),
    "onboardingFailureExpiredDescription": MessageLookupByLibrary.simpleMessage(
      "Возможно, подписка была сброшена в панели. Скопируйте адрес подписки заново в панели пользователя и вставьте его сюда.",
    ),
    "onboardingFailureExpiredTitle": MessageLookupByLibrary.simpleMessage(
      "Срок действия ссылки на подписку истёк",
    ),
    "onboardingFailureNotSubscriptionDescription":
        MessageLookupByLibrary.simpleMessage(
          "Нажмите «Копировать адрес подписки» в панели пользователя и вставьте его сюда.",
        ),
    "onboardingFailureNotSubscriptionTitle":
        MessageLookupByLibrary.simpleMessage("Это не ссылка на подписку"),
    "onboardingFailureUnknownDescription": MessageLookupByLibrary.simpleMessage(
      "Проверьте сеть и попробуйте снова.",
    ),
    "onboardingFailureUnknownTitle": MessageLookupByLibrary.simpleMessage(
      "Не удалось импортировать",
    ),
    "onboardingFailureUnreachableDescription": MessageLookupByLibrary.simpleMessage(
      "Возможно, текущая сеть блокирует этот домен. На странице состояния есть резервные адреса, или попробуйте позже.",
    ),
    "onboardingFailureUnreachableTitle": MessageLookupByLibrary.simpleMessage(
      "Не удаётся подключиться к адресу подписки",
    ),
    "onboardingImported": m103,
    "onboardingImporting": MessageLookupByLibrary.simpleMessage(
      "Получаем подписку…",
    ),
    "onboardingImportingDescription": MessageLookupByLibrary.simpleMessage(
      "Читаем список узлов и сведения о тарифе",
    ),
    "onboardingInternetVerified": MessageLookupByLibrary.simpleMessage(
      "Доступ в интернет · проверено",
    ),
    "onboardingNoSubscription": MessageLookupByLibrary.simpleMessage(
      "Ещё нет адреса подписки? Откройте панель пользователя, чтобы скопировать его ›",
    ),
    "onboardingNodeUnavailable": MessageLookupByLibrary.simpleMessage(
      "Текущий узел может быть временно недоступен. Обычно помогает смена узла.",
    ),
    "onboardingNotNow": MessageLookupByLibrary.simpleMessage("Не сейчас"),
    "onboardingOpenPanel": MessageLookupByLibrary.simpleMessage(
      "Открыть панель пользователя",
    ),
    "onboardingPasteAgain": MessageLookupByLibrary.simpleMessage(
      "Вставить снова",
    ),
    "onboardingPasteFromClipboard": MessageLookupByLibrary.simpleMessage(
      "Вставить ссылку на подписку из буфера обмена",
    ),
    "onboardingPrivacyNote": MessageLookupByLibrary.simpleMessage(
      "Буфер обмена читается только при нажатии кнопки. Ссылка на подписку хранится только на этом устройстве.",
    ),
    "onboardingRemainingTraffic": MessageLookupByLibrary.simpleMessage(
      "Остаток трафика",
    ),
    "onboardingScanQr": MessageLookupByLibrary.simpleMessage(
      "Сканировать QR-код на панели",
    ),
    "onboardingSwitchNode": MessageLookupByLibrary.simpleMessage(
      "Сменить узел",
    ),
    "onboardingTitle": MessageLookupByLibrary.simpleMessage(
      "Импортируйте подписку, чтобы начать",
    ),
    "onboardingViewStatus": MessageLookupByLibrary.simpleMessage(
      "Посмотреть резервный адрес",
    ),
    "onboardingVpnDescription": MessageLookupByLibrary.simpleMessage(
      "Далее система спросит, разрешить ли Tianji Cloud создавать VPN-подключение. Нажмите «ОК». Разрешение нужно дать только один раз.",
    ),
    "onboardingVpnTitle": MessageLookupByLibrary.simpleMessage(
      "Требуется системное разрешение",
    ),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Учитывать только трафик прокси",
    ),
    "openSettings": MessageLookupByLibrary.simpleMessage("Открыть настройки"),
    "optional": MessageLookupByLibrary.simpleMessage("Необязательно"),
    "options": MessageLookupByLibrary.simpleMessage("Опции"),
    "originalUrl": MessageLookupByLibrary.simpleMessage("Исходный URL"),
    "other": MessageLookupByLibrary.simpleMessage("Другое"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Другие участники",
    ),
    "otherProfilesTitle": MessageLookupByLibrary.simpleMessage(
      "Другие конфигурации",
    ),
    "outbound": MessageLookupByLibrary.simpleMessage("Исходящие"),
    "outboundExit": MessageLookupByLibrary.simpleMessage("Выход"),
    "outboundIp": MessageLookupByLibrary.simpleMessage("Исходящий IP"),
    "outboundMode": MessageLookupByLibrary.simpleMessage(
      "Режим исходящего трафика",
    ),
    "outboundModeDescription": MessageLookupByLibrary.simpleMessage(
      "Обычно оставляйте режим «Правила». Глобальный режим направляет через прокси и трафик материкового Китая, а прямой режим отключает все прокси-линии.",
    ),
    "outboundModeDirectWarning": MessageLookupByLibrary.simpleMessage(
      "Включён прямой режим",
    ),
    "outboundModeGlobalWarning": MessageLookupByLibrary.simpleMessage(
      "Включён глобальный режим",
    ),
    "outboundModeRestoreRule": MessageLookupByLibrary.simpleMessage(
      "Вернуть правила",
    ),
    "overrideDestination": MessageLookupByLibrary.simpleMessage(
      "Подменять адрес назначения",
    ),
    "overrideEntries": MessageLookupByLibrary.simpleMessage(
      "Переопределяемые параметры",
    ),
    "overridesLabel": MessageLookupByLibrary.simpleMessage("Переопределения"),
    "overview": MessageLookupByLibrary.simpleMessage("Обзор"),
    "parsePureIp": MessageLookupByLibrary.simpleMessage("Разбирать чистые IP"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "paste": MessageLookupByLibrary.simpleMessage("Вставить"),
    "pasteFromClipboardImport": MessageLookupByLibrary.simpleMessage(
      "Импорт из буфера",
    ),
    "peers": MessageLookupByLibrary.simpleMessage("Пиры"),
    "pickFromAlbum": MessageLookupByLibrary.simpleMessage("Выбрать из галереи"),
    "pinWindow": MessageLookupByLibrary.simpleMessage(
      "Закрепить поверх всех окон",
    ),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Привяжите WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Введите название скрипта",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Загрузите корректный QR-код",
    ),
    "plugin": MessageLookupByLibrary.simpleMessage("Плагин"),
    "pluginCipher": MessageLookupByLibrary.simpleMessage("Шифр плагина"),
    "pluginHost": MessageLookupByLibrary.simpleMessage("Хост плагина"),
    "pluginMode": MessageLookupByLibrary.simpleMessage("Режим плагина"),
    "pluginPassword": MessageLookupByLibrary.simpleMessage("Пароль плагина"),
    "pluginPath": MessageLookupByLibrary.simpleMessage("Путь плагина"),
    "pluginUsername": MessageLookupByLibrary.simpleMessage(
      "Имя пользователя плагина",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Порт"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Введите другой порт",
    ),
    "portHopping": MessageLookupByLibrary.simpleMessage("Перескок портов"),
    "portTip": m104,
    "portValue": m105,
    "ports": MessageLookupByLibrary.simpleMessage("Порты"),
    "preSharedKey": MessageLookupByLibrary.simpleMessage("Общий ключ"),
    "preferred": MessageLookupByLibrary.simpleMessage("Предпочтительный"),
    "prerequisites": MessageLookupByLibrary.simpleMessage(
      "Предварительные условия",
    ),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Нажмите сочетание клавиш",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Предпросмотр"),
    "previewReadOnly": MessageLookupByLibrary.simpleMessage("Только чтение"),
    "previousMatch": MessageLookupByLibrary.simpleMessage(
      "Предыдущее совпадение",
    ),
    "privateKey": MessageLookupByLibrary.simpleMessage("Закрытый ключ"),
    "privateKeyPassphrase": MessageLookupByLibrary.simpleMessage(
      "Пароль закрытого ключа",
    ),
    "process": MessageLookupByLibrary.simpleMessage("Процесс"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "profileAddCustomSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Создать локальные прокси, группы и правила",
    ),
    "profileAddFileSourceDesc": MessageLookupByLibrary.simpleMessage(
      ".yaml / .yml",
    ),
    "profileAddLinkSourceDesc": MessageLookupByLibrary.simpleMessage(
      "Скопируйте ссылку из личного кабинета",
    ),
    "profileAddValidationNote": MessageLookupByLibrary.simpleMessage(
      "Импорт сначала проверяется. Ошибка разбора не заменяет активный профиль.",
    ),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage("Введите корректный интервал"),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage("Введите интервал автообновления"),
    "profileDaysLeft": m106,
    "profileExpiresIn": m107,
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Профиль изменён. Отключить автообновление?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите название профиля",
    ),
    "profilePreviewTitle": MessageLookupByLibrary.simpleMessage(
      "Предпросмотр конфигурации",
    ),
    "profileSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Действует только для этого профиля; не добавленные параметры используют значения по умолчанию.",
    ),
    "profileSwitchNote": MessageLookupByLibrary.simpleMessage(
      "Изменения применяются сразу; при ошибке разбора сохраняется текущая конфигурация.",
    ),
    "profileTunSettingsDesc": MessageLookupByLibrary.simpleMessage(
      "Действует только для этого профиля и имеет приоритет над переопределяемыми параметрами TUN в настройках сети.",
    ),
    "profileUpdatedAt": m108,
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите корректный URL профиля",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Введите URL профиля",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Профили"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Сортировка профилей"),
    "project": MessageLookupByLibrary.simpleMessage("Проект"),
    "protocol": MessageLookupByLibrary.simpleMessage("Протокол"),
    "protocolParam": MessageLookupByLibrary.simpleMessage("Параметр протокола"),
    "protocolVersion": MessageLookupByLibrary.simpleMessage("Версия протокола"),
    "providerCount": m109,
    "providerInUse": m110,
    "providerUrlTip": MessageLookupByLibrary.simpleMessage(
      "Поддерживаются только удалённые ресурсы",
    ),
    "providers": MessageLookupByLibrary.simpleMessage("Внешние ресурсы"),
    "proxies": MessageLookupByLibrary.simpleMessage("Прокси"),
    "proxiesCount": m111,
    "proxiesProfileLabel": m112,
    "proxiesRemovedTip": m113,
    "proxiesReplacedTip": m114,
    "proxyChains": MessageLookupByLibrary.simpleMessage("Цепочка прокси"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Группа прокси"),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Группа прокси пуста",
    ),
    "proxyGroupInUse": m115,
    "proxyGroupsAfterStart": MessageLookupByLibrary.simpleMessage(
      "Группы появятся здесь после запуска ядра",
    ),
    "proxyGroupsCount": m116,
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Провайдеры прокси"),
    "proxyServerNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Используется только для разрешения имён прокси-серверов.",
    ),
    "proxyServerNameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Совпавшие имена прокси-серверов используют указанный здесь DNS-сервер вместо Proxy Server Nameserver.",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Тип прокси"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Очистить кэш"),
    "publicKey": MessageLookupByLibrary.simpleMessage("Открытый ключ"),
    "pureBlack": MessageLookupByLibrary.simpleMessage("Чисто чёрный"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Чисто чёрный режим"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR-код"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Сканируйте QR-код, чтобы получить профиль",
    ),
    "qrcodeTooLongTip": MessageLookupByLibrary.simpleMessage(
      "Ссылка слишком длинная для QR-кода. Используйте «Копировать ссылку».",
    ),
    "quickActions": MessageLookupByLibrary.simpleMessage("Быстрые действия"),
    "quickEdit": MessageLookupByLibrary.simpleMessage("Быстрое редактирование"),
    "quickLines": MessageLookupByLibrary.simpleMessage("Быстрые линии"),
    "recentDnsQueries": MessageLookupByLibrary.simpleMessage(
      "Последние DNS-запросы",
    ),
    "recentRequests": MessageLookupByLibrary.simpleMessage("Последние запросы"),
    "recommendedIcons": MessageLookupByLibrary.simpleMessage("Рекомендуемые"),
    "recordType": MessageLookupByLibrary.simpleMessage("Тип записи"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Порт Redir"),
    "redo": MessageLookupByLibrary.simpleMessage("Повторить"),
    "regenerateCertificate": MessageLookupByLibrary.simpleMessage(
      "Пересоздать сертификат",
    ),
    "regenerateCertificateTip": MessageLookupByLibrary.simpleMessage(
      "Новый сертификат заменит текущий; 天机云 по возможности удалит текущий из доверенных корневых сертификатов этого устройства. На каждое другое устройство, доверяющее текущему, нужно установить новый.",
    ),
    "regex": MessageLookupByLibrary.simpleMessage("Регулярное выражение"),
    "releaseMemory": MessageLookupByLibrary.simpleMessage("Освободить память"),
    "releaseMemoryFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось освободить память",
    ),
    "remote": MessageLookupByLibrary.simpleMessage("Удалённо"),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Удалённое назначение",
    ),
    "remoteDnsResolve": MessageLookupByLibrary.simpleMessage(
      "Удалённое разрешение DNS",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Убрать"),
    "rename": MessageLookupByLibrary.simpleMessage("Переименовать"),
    "renew": MessageLookupByLibrary.simpleMessage("Продлить"),
    "renewUpgrade": MessageLookupByLibrary.simpleMessage(
      "Продлить / сменить план",
    ),
    "replace": MessageLookupByLibrary.simpleMessage("Заменить"),
    "replaceAll": MessageLookupByLibrary.simpleMessage("Заменить все"),
    "request": MessageLookupByLibrary.simpleMessage("Запрос"),
    "requestBody": MessageLookupByLibrary.simpleMessage("Тело запроса"),
    "requestHeaders": MessageLookupByLibrary.simpleMessage("Заголовки запроса"),
    "requests": MessageLookupByLibrary.simpleMessage("Запросы"),
    "requestsAndUpdates": MessageLookupByLibrary.simpleMessage(
      "Запросы и обновления",
    ),
    "required": MessageLookupByLibrary.simpleMessage("Обязательно"),
    "reset": MessageLookupByLibrary.simpleMessage("Сброс"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "На этой странице есть изменения. Вы уверены, что хотите выполнить сброс?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выполнить сброс?",
    ),
    "residentialActiveDesc": MessageLookupByLibrary.simpleMessage(
      "После подключения трафик, которому нужен прокси, использует эту линию.",
    ),
    "residentialApplyFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось применить линию. Повторите попытку или выберите другую.",
    ),
    "residentialApplying": MessageLookupByLibrary.simpleMessage("Применение…"),
    "residentialBulkBypass": MessageLookupByLibrary.simpleMessage(
      "Видео и большие загрузки идут по обычным линиям, экономя домашний трафик.",
    ),
    "residentialBulkUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Обход больших загрузок не подтверждён; видео и загрузки могут расходовать домашний трафик.",
    ),
    "residentialCaptureOff": MessageLookupByLibrary.simpleMessage(
      "Трафик компьютера не перехватывается. Включите системный прокси или TUN ниже.",
    ),
    "residentialChange": MessageLookupByLibrary.simpleMessage("Изменить выход"),
    "residentialChoose": MessageLookupByLibrary.simpleMessage("Выбрать выход"),
    "residentialExitLocked": MessageLookupByLibrary.simpleMessage(
      "Выберите домашний выход на панели. Пока домашняя маршрутизация активна, другие группы не могут её изменить.",
    ),
    "residentialExitSheetSubtitle": MessageLookupByLibrary.simpleMessage(
      "AI и группы, которым нужен прокси, будут использовать выбранный маршрут.",
    ),
    "residentialExitSheetTitle": MessageLookupByLibrary.simpleMessage(
      "Выберите домашний выход",
    ),
    "residentialExplanation": MessageLookupByLibrary.simpleMessage(
      "Прокси-трафик по умолчанию использует выбранный домашний выход; прямой трафик следует подписке. Активный обход для больших загрузок указан ниже. Для отдельных адресов сервер может использовать другой выход.",
    ),
    "residentialLoadingCatalog": MessageLookupByLibrary.simpleMessage(
      "Загрузка домашних линий…",
    ),
    "residentialLoadingCatalogDesc": MessageLookupByLibrary.simpleMessage(
      "Загрузка доступных линий из подписки.",
    ),
    "residentialManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Управлять подпиской",
    ),
    "residentialMissing": MessageLookupByLibrary.simpleMessage(
      "Выбранного домашнего выхода больше нет в этой подписке.",
    ),
    "residentialMissingDesc": MessageLookupByLibrary.simpleMessage(
      "Проксируемый трафик блокируется, пока вы не выберете другой выход. Прямой трафик материкового Китая не меняется.",
    ),
    "residentialNoPlan": MessageLookupByLibrary.simpleMessage(
      "Нет доступных домашних линий",
    ),
    "residentialNoPlanDesc": MessageLookupByLibrary.simpleMessage(
      "В этой подписке сейчас нет доступного домашнего выхода. Продолжайте использовать политику подписки или проверьте панель подписки.",
    ),
    "residentialNoticeBody": m117,
    "residentialNoticeChange": MessageLookupByLibrary.simpleMessage(
      "Выбрать другую",
    ),
    "residentialNoticeRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "residentialNoticeTitle": MessageLookupByLibrary.simpleMessage(
      "Домашняя линия временно недоступна",
    ),
    "residentialOutbound": MessageLookupByLibrary.simpleMessage(
      "Домашний выход",
    ),
    "residentialPending": MessageLookupByLibrary.simpleMessage(
      "Переключение линии. Подождите.",
    ),
    "residentialResetFailed": MessageLookupByLibrary.simpleMessage(
      "Новый выход активен, но существующие подключения не удалось закрыть. До переподключения они могут использовать прежний выход.",
    ),
    "residentialRouteNote": MessageLookupByLibrary.simpleMessage(
      "Карточка IP показывает выход только для текущей цели проверки, а не единый выход для всех сайтов.",
    ),
    "residentialSelected": MessageLookupByLibrary.simpleMessage("Выбран"),
    "residentialSubscriptionPolicy": MessageLookupByLibrary.simpleMessage(
      "Политика подписки",
    ),
    "residentialTitle": MessageLookupByLibrary.simpleMessage("Домашний выход"),
    "residentialUnavailable": MessageLookupByLibrary.simpleMessage(
      "Недоступен",
    ),
    "residentialUseExit": m118,
    "residentialUseSubscription": MessageLookupByLibrary.simpleMessage(
      "Использовать политику подписки",
    ),
    "residentialUsingSubscription": MessageLookupByLibrary.simpleMessage(
      "Домашний выход не выбран. Проксируемый трафик идёт по политике подписки.",
    ),
    "resourceUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления",
    ),
    "resourceUpdateIntervalTip": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления должен быть больше 0",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Ресурсы"),
    "respectRules": MessageLookupByLibrary.simpleMessage("Соблюдать правила"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "«Соблюдать правила» направляет DNS-соединения по правилам; нужен Proxy Server Nameserver.",
    ),
    "response": MessageLookupByLibrary.simpleMessage("Ответ"),
    "responseBody": MessageLookupByLibrary.simpleMessage("Тело ответа"),
    "responseCode": MessageLookupByLibrary.simpleMessage("Код ответа"),
    "responseHeaders": MessageLookupByLibrary.simpleMessage("Заголовки ответа"),
    "restart": MessageLookupByLibrary.simpleMessage("Перезапустить"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите перезапустить ядро?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Восстановить"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Восстановить все данные",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Восстановить только профили",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия восстановления",
    ),
    "restoreStrategyCompatible": MessageLookupByLibrary.simpleMessage(
      "Совместимость",
    ),
    "restoreStrategyOverride": MessageLookupByLibrary.simpleMessage(
      "Перезапись",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Восстановление выполнено",
    ),
    "result": MessageLookupByLibrary.simpleMessage("Результат"),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "root": MessageLookupByLibrary.simpleMessage("Root"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Адреса маршрутов"),
    "routeExcludeAddress": MessageLookupByLibrary.simpleMessage(
      "Исключённые адреса маршрутов",
    ),
    "routingMark": MessageLookupByLibrary.simpleMessage("Метка маршрутизации"),
    "routingResourcesDesktop": MessageLookupByLibrary.simpleMessage(
      "Ресурсы маршрутизации",
    ),
    "routingResourcesSubtitle": MessageLookupByLibrary.simpleMessage(
      "Определяет, какой трафик идет через прокси, а какой напрямую",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "rule": MessageLookupByLibrary.simpleMessage("Правило"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить полный домен",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ключевое слово в домене",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению домена",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить суффикс домена",
    ),
    "ruleActionDomainWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставление по маске; поддерживаются только * и ?",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить метку DSCP (только для входящих tproxy UDP)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов назначения",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны IP-адреса",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить домены из Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя входящего подключения",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящий порт",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить тип входящего подключения",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя пользователя входящего подключения; несколько имён разделяются /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN, которой принадлежит IP",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов; IP-CIDR6 — просто псевдоним",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон суффиксов IP",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставляет все запросы, условия не нужны",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить TCP или UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило OR",
    ),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по имени процесса; на Android соответствует имени пакета",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению имени процесса; на Android соответствует имени пакета",
    ),
    "ruleActionProcessNameWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по маске имени процесса; поддерживаются только * и ?",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по полному пути процесса",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению пути процесса",
    ),
    "ruleActionProcessPathWildcardDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по маске пути процесса; поддерживаются только * и ?",
    ),
    "ruleActionRematchNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить имя повторного сопоставления; несколько имён разделяются /",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Ссылка на набор правил; требуется настроить rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны IP источника",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN IP источника",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов источника",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон суффиксов IP источника",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов источника",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Переход к подправилу; обратите внимание на скобки",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Правило пусто"),
    "ruleListInvalid": MessageLookupByLibrary.simpleMessage(
      "Правила должны быть YAML-списком, по одному правилу в элементе, например - DOMAIN,example.com,DIRECT",
    ),
    "rulePresetBittorrentDirect": MessageLookupByLibrary.simpleMessage(
      "BitTorrent напрямую",
    ),
    "rulePresetBlockDot": MessageLookupByLibrary.simpleMessage(
      "Блокировать DNS over TLS",
    ),
    "rulePresetBlockLoopback": MessageLookupByLibrary.simpleMessage(
      "Защита от петли прокси",
    ),
    "rulePresetBlockQuic": MessageLookupByLibrary.simpleMessage(
      "Блокировать QUIC",
    ),
    "rulePresetBlockStun": MessageLookupByLibrary.simpleMessage(
      "Блокировать STUN",
    ),
    "rulePresetLanDirect": MessageLookupByLibrary.simpleMessage(
      "Локальная сеть напрямую",
    ),
    "rulePresetSystemServicesDirect": MessageLookupByLibrary.simpleMessage(
      "Apple и Microsoft напрямую",
    ),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Провайдеры правил"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Набор правил"),
    "ruleSetEmptyTip": MessageLookupByLibrary.simpleMessage(
      "В наборе правил нет пригодных записей",
    ),
    "ruleSetInvalidTip": MessageLookupByLibrary.simpleMessage(
      "Не удаётся прочитать этот файл mrs",
    ),
    "ruleSetMixedTip": MessageLookupByLibrary.simpleMessage(
      "Набор правил смешивает домены и диапазоны IP, поэтому его тип не определить",
    ),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Цель правила"),
    "ruleTextInvalid": MessageLookupByLibrary.simpleMessage(
      "Правило должно начинаться с поддерживаемого типа, например DOMAIN,example.com,DIRECT",
    ),
    "rules": MessageLookupByLibrary.simpleMessage("Правила"),
    "rulesCount": m119,
    "runTime": MessageLookupByLibrary.simpleMessage("Время работы"),
    "running": MessageLookupByLibrary.simpleMessage("Работает"),
    "runtimeConfig": MessageLookupByLibrary.simpleMessage(
      "Конфигурация выполнения",
    ),
    "safeMode": MessageLookupByLibrary.simpleMessage("Безопасный режим"),
    "safeModeAppTitle": m120,
    "saturation": MessageLookupByLibrary.simpleMessage("Насыщенность"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Сохранить изменения?"),
    "scene": MessageLookupByLibrary.simpleMessage("Сценарий"),
    "sceneAi": MessageLookupByLibrary.simpleMessage("AI"),
    "sceneAiNote": MessageLookupByLibrary.simpleMessage(
      "Сервисы ИИ используют маршруты режима ИИ; трафик в материковый Китай идёт напрямую",
    ),
    "sceneDaily": MessageLookupByLibrary.simpleMessage("Обычный"),
    "sceneDailyBypass": MessageLookupByLibrary.simpleMessage(
      "Большой трафик автоматически обходит домашний канал; трафик в материковый Китай идёт напрямую",
    ),
    "sceneDailyNote": MessageLookupByLibrary.simpleMessage(
      "Трафик в материковый Китай идёт напрямую",
    ),
    "sceneSuspended": MessageLookupByLibrary.simpleMessage(
      "Сценарии приостановлены в домашнем режиме",
    ),
    "sceneUnavailable": MessageLookupByLibrary.simpleMessage(
      "Сценарии недоступны",
    ),
    "sceneUnavailableDesc": MessageLookupByLibrary.simpleMessage(
      "В этой подписке пока нет групп сценариев. Обратитесь в поддержку или настройте маршрутизацию на странице прокси.",
    ),
    "sceneUnconfirmed": MessageLookupByLibrary.simpleMessage(
      "Не все правила удалось переключить",
    ),
    "sceneWatch": MessageLookupByLibrary.simpleMessage("Видео"),
    "sceneWatchNote": MessageLookupByLibrary.simpleMessage(
      "Стриминг использует маршруты режима просмотра; трафик в материковый Китай идёт напрямую",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Скрипт"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Режим скрипта: переписывает весь профиль скриптом расширения",
    ),
    "scrollToSelected": MessageLookupByLibrary.simpleMessage(
      "Прокрутить к выбранному",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "seconds": MessageLookupByLibrary.simpleMessage("секунд"),
    "secondsCount": m121,
    "secretKey": MessageLookupByLibrary.simpleMessage("Ключ"),
    "sectionsInEffect": m122,
    "select": MessageLookupByLibrary.simpleMessage("Выбрать"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Выбрать всё"),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Выберите набор правил",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Выберите стратегию распределения",
    ),
    "selectionConfirming": MessageLookupByLibrary.simpleMessage(
      "Проверка выхода…",
    ),
    "selectionGroupOverridden": MessageLookupByLibrary.simpleMessage(
      "Автоматическая группа выбрала другой узел. Выберите узел вручную, чтобы закрепить его.",
    ),
    "selectionNotCaptured": MessageLookupByLibrary.simpleMessage(
      "Трафик устройства пока не перехватывается. Включите системный прокси или TUN ниже.",
    ),
    "selectionRecheck": MessageLookupByLibrary.simpleMessage("Проверить снова"),
    "selectionResidentialLocked": MessageLookupByLibrary.simpleMessage(
      "Домашняя линия управляет прокси-трафиком. Смените её в карточке или вернитесь к маршрутизации подписки.",
    ),
    "selectionUnknown": MessageLookupByLibrary.simpleMessage(
      "Выход отличается от выбранного. Причину подтвердить не удалось. Повторите проверку.",
    ),
    "selectionUnknownPending": MessageLookupByLibrary.simpleMessage(
      "Выход отличается от выбранного. Проверяем причину…",
    ),
    "send": MessageLookupByLibrary.simpleMessage("Отправить"),
    "sendFromPhone": MessageLookupByLibrary.simpleMessage(
      "Отправить с телефона",
    ),
    "sendFromPhoneConfirmTitle": MessageLookupByLibrary.simpleMessage(
      "Импортировать ссылку с телефона?",
    ),
    "sendFromPhoneNoNetwork": MessageLookupByLibrary.simpleMessage(
      "Это устройство не подключено к локальной сети",
    ),
    "sendFromPhonePageHint": MessageLookupByLibrary.simpleMessage(
      "Ссылка на подписку или ссылка на прокси",
    ),
    "sendFromPhonePageSent": MessageLookupByLibrary.simpleMessage(
      "Отправлено. Подтвердите импорт на другом устройстве.",
    ),
    "sendFromPhonePageTitle": MessageLookupByLibrary.simpleMessage(
      "Отправить ссылку в 天机云",
    ),
    "sendFromPhonePermissionDenied": MessageLookupByLibrary.simpleMessage(
      "Чтобы получить ссылку с телефона, 天机云 нужно разрешение «Устройства поблизости» для доступа к локальной сети. Включите его в настройках приложения.",
    ),
    "sendFromPhoneTip": MessageLookupByLibrary.simpleMessage(
      "Отсканируйте код камерой телефона и вставьте ссылку на открывшейся странице. Оба устройства должны быть в одной сети.",
    ),
    "server": MessageLookupByLibrary.simpleMessage("Сервер"),
    "serviceAbnormalCount": m123,
    "serviceAllAvailable": MessageLookupByLibrary.simpleMessage("Все доступны"),
    "serviceAvailable": MessageLookupByLibrary.simpleMessage("Доступен"),
    "serviceBlocked": MessageLookupByLibrary.simpleMessage("Заблокировано"),
    "serviceCheckAll": MessageLookupByLibrary.simpleMessage("Проверить все"),
    "serviceComingSoon": MessageLookupByLibrary.simpleMessage("Скоро появится"),
    "serviceDisallowedIsp": MessageLookupByLibrary.simpleMessage(
      "Недопустимый провайдер",
    ),
    "serviceFailed": MessageLookupByLibrary.simpleMessage("Ошибка проверки"),
    "serviceManage": MessageLookupByLibrary.simpleMessage(
      "Управление сервисами",
    ),
    "serviceOriginalsOnly": MessageLookupByLibrary.simpleMessage(
      "Только оригиналы",
    ),
    "servicePending": MessageLookupByLibrary.simpleMessage("Не проверено"),
    "serviceRestricted": MessageLookupByLibrary.simpleMessage(
      "Доступ ограничен",
    ),
    "serviceShownOnDashboard": MessageLookupByLibrary.simpleMessage(
      "Показан на панели",
    ),
    "serviceStatus": MessageLookupByLibrary.simpleMessage("Состояние сервисов"),
    "serviceUnavailable": MessageLookupByLibrary.simpleMessage("Недоступен"),
    "serviceUnsupportedRegion": MessageLookupByLibrary.simpleMessage(
      "Регион не поддерживается",
    ),
    "settingEntries": MessageLookupByLibrary.simpleMessage("параметры"),
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "settingsCount": m124,
    "shareLinkUnreadable": m125,
    "shareLinksInvalid": MessageLookupByLibrary.simpleMessage(
      "Не удалось прочитать прокси из ссылок",
    ),
    "shareQrcodeTip": MessageLookupByLibrary.simpleMessage(
      "Отсканируйте в 天机云 на другом устройстве, чтобы импортировать этот профиль.",
    ),
    "show": MessageLookupByLibrary.simpleMessage("Показать"),
    "showLess": MessageLookupByLibrary.simpleMessage("Свернуть"),
    "showMore": MessageLookupByLibrary.simpleMessage("Развернуть"),
    "showNotificationStopAction": MessageLookupByLibrary.simpleMessage(
      "Кнопка остановки в уведомлении",
    ),
    "showPassword": MessageLookupByLibrary.simpleMessage("Показать пароль"),
    "sidebar": MessageLookupByLibrary.simpleMessage("Боковая панель"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Тихий запуск"),
    "singleImport": MessageLookupByLibrary.simpleMessage("По одному"),
    "singleShareLinkOnly": MessageLookupByLibrary.simpleMessage(
      "Здесь укажите одну ссылку, несколько можно задать в быстром редактировании списка",
    ),
    "singleValueTip": m126,
    "size": MessageLookupByLibrary.simpleMessage("Размер"),
    "skipCertVerify": MessageLookupByLibrary.simpleMessage(
      "Пропускать проверку сертификата",
    ),
    "skipDomain": MessageLookupByLibrary.simpleMessage("Пропускаемые домены"),
    "skipDstAddress": MessageLookupByLibrary.simpleMessage(
      "Пропускаемые адреса назначения",
    ),
    "skipServerCertVerify": MessageLookupByLibrary.simpleMessage(
      "Пропускать проверку сертификата сервера",
    ),
    "skipSrcAddress": MessageLookupByLibrary.simpleMessage(
      "Пропускаемые адреса источника",
    ),
    "slide": MessageLookupByLibrary.simpleMessage("Сдвиг"),
    "sliders": MessageLookupByLibrary.simpleMessage("Ползунки"),
    "sniffProtocols": MessageLookupByLibrary.simpleMessage("Протоколы"),
    "sniffer": MessageLookupByLibrary.simpleMessage("Сниффер"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Порт SOCKS"),
    "softStyle": MessageLookupByLibrary.simpleMessage("Мягкий"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "source": MessageLookupByLibrary.simpleMessage("Источник"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("IP источника"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Специальный прокси"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Специальные правила"),
    "spectrum": MessageLookupByLibrary.simpleMessage("Спектр"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Статистика скорости",
    ),
    "splitStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия распределения",
    ),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Стратегия распределения не может быть пустой",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("Список SSID пуст"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Режим стека"),
    "stackTrace": MessageLookupByLibrary.simpleMessage("Трассировка стека"),
    "standard": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Стандартный режим: добавляет правила поверх профиля",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Старт"),
    "startFromScratch": MessageLookupByLibrary.simpleMessage("С нуля"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Запуск VPN…"),
    "startupAndBackground": MessageLookupByLibrary.simpleMessage(
      "Запуск и фоновая работа",
    ),
    "status": MessageLookupByLibrary.simpleMessage("Статус"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "При отключённом DNS используется системный DNS.",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
    "stopUpdateDownloadTip": MessageLookupByLibrary.simpleMessage(
      "Остановить загрузку обновления?",
    ),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Остановка VPN…"),
    "strategy": MessageLookupByLibrary.simpleMessage("Стратегия"),
    "strictRoute": MessageLookupByLibrary.simpleMessage(
      "Строгая маршрутизация",
    ),
    "strictRouteDesc": MessageLookupByLibrary.simpleMessage(
      "Строгая маршрутизация не даёт трафику вроде DNS обходить TUN, а при выключенном IPv6 блокирует IPv6-соединения этого устройства.",
    ),
    "style": MessageLookupByLibrary.simpleMessage("Стиль"),
    "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "subscriptionDetails": MessageLookupByLibrary.simpleMessage("Подробнее"),
    "subscriptionExpiryNoticeBody": m127,
    "subscriptionExpiryNoticeTitle": m128,
    "subscriptionInfo": MessageLookupByLibrary.simpleMessage(
      "Информация о подписке",
    ),
    "subscriptionLink": MessageLookupByLibrary.simpleMessage("Ссылка подписки"),
    "sudoPasswordTitle": MessageLookupByLibrary.simpleMessage(
      "Введите пароль для sudo",
    ),
    "suspended": MessageLookupByLibrary.simpleMessage("Приостановлено…"),
    "switchProfile": MessageLookupByLibrary.simpleMessage("Сменить профиль"),
    "switchProfileShort": MessageLookupByLibrary.simpleMessage("Переключить"),
    "sync": MessageLookupByLibrary.simpleMessage("Синхронизация"),
    "system": MessageLookupByLibrary.simpleMessage("Система"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Системные приложения"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "systemService": MessageLookupByLibrary.simpleMessage("Системная служба"),
    "systemServiceAbnormal": MessageLookupByLibrary.simpleMessage("Ошибка"),
    "systemServiceDescription": MessageLookupByLibrary.simpleMessage(
      "Работает с правами администратора и настраивает или восстанавливает виртуальный адаптер, маршруты и системный прокси.",
    ),
    "systemServiceInstall": MessageLookupByLibrary.simpleMessage("Установить"),
    "systemServiceNotInstalled": MessageLookupByLibrary.simpleMessage(
      "Не установлена",
    ),
    "systemServiceRefresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "systemServiceRepair": MessageLookupByLibrary.simpleMessage("Восстановить"),
    "systemServiceRunning": MessageLookupByLibrary.simpleMessage(
      "Установлена и запущена",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Вкладки"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Анимация вкладок"),
    "tapIconToRetry": MessageLookupByLibrary.simpleMessage(
      "Нажмите на значок, чтобы повторить",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы разрешить",
    ),
    "target": MessageLookupByLibrary.simpleMessage("Цель"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("Параллельный TCP"),
    "testInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал тестирования",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("URL для теста"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage(
      "Тестировать при использовании",
    ),
    "textScale": MessageLookupByLibrary.simpleMessage("Масштаб текста"),
    "textScalePreview": MessageLookupByLibrary.simpleMessage(
      "Так будет выглядеть текст в приложении",
    ),
    "theme": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Цвет темы"),
    "themeMode": MessageLookupByLibrary.simpleMessage("Режим темы"),
    "tight": MessageLookupByLibrary.simpleMessage("Плотный"),
    "time": MessageLookupByLibrary.simpleMessage("Время"),
    "timeToFirstByte": MessageLookupByLibrary.simpleMessage(
      "Время до первого байта",
    ),
    "timeout": MessageLookupByLibrary.simpleMessage("Тайм-аут"),
    "tintedStyle": MessageLookupByLibrary.simpleMessage("Тонированный"),
    "tip": MessageLookupByLibrary.simpleMessage("Подсказка"),
    "toggle": MessageLookupByLibrary.simpleMessage("Переключить"),
    "tolerance": MessageLookupByLibrary.simpleMessage("Допуск"),
    "tools": MessageLookupByLibrary.simpleMessage("Инструменты"),
    "torch": MessageLookupByLibrary.simpleMessage("Фонарик"),
    "total": MessageLookupByLibrary.simpleMessage("Всего"),
    "totalDownload": MessageLookupByLibrary.simpleMessage("Загружено"),
    "totalTraffic": MessageLookupByLibrary.simpleMessage("Общий трафик"),
    "totalUpload": MessageLookupByLibrary.simpleMessage("Отдано"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Порт TProxy"),
    "traffic": MessageLookupByLibrary.simpleMessage("Трафик"),
    "trafficMainlandThisMonth": MessageLookupByLibrary.simpleMessage(
      "Напрямую в Китай за месяц",
    ),
    "trafficOtherDirect": MessageLookupByLibrary.simpleMessage(
      "Напрямую (регион не подтверждён)",
    ),
    "trafficPeak": m129,
    "trafficSavedThisMonth": MessageLookupByLibrary.simpleMessage(
      "Сэкономлено за месяц",
    ),
    "trafficStats": MessageLookupByLibrary.simpleMessage("Статистика трафика"),
    "trafficStatsDesc": MessageLookupByLibrary.simpleMessage(
      "Прямой трафик материкового Китая, трафик VPN и сэкономленный прокси-трафик за этот месяц на этом устройстве.",
    ),
    "trafficStatsScope": MessageLookupByLibrary.simpleMessage(
      "Только этот устройство, за этот месяц. Учитывается трафик, перехваченный приложением.",
    ),
    "trafficTotal": m130,
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Статистика трафика"),
    "transport": MessageLookupByLibrary.simpleMessage("Транспорт"),
    "transportHeaders": m131,
    "trayCopyProxyCommand": MessageLookupByLibrary.simpleMessage(
      "Скопировать команду прокси для терминала",
    ),
    "trayDisconnect": MessageLookupByLibrary.simpleMessage("Отключиться"),
    "trayNotConnected": MessageLookupByLibrary.simpleMessage("Не подключено"),
    "trayOpenApp": MessageLookupByLibrary.simpleMessage(
      "Открыть Tianji Cloud…",
    ),
    "trayPreferences": MessageLookupByLibrary.simpleMessage("Настройки"),
    "trayShowMainWindow": MessageLookupByLibrary.simpleMessage(
      "Показать главное окно",
    ),
    "trayTun": MessageLookupByLibrary.simpleMessage(
      "Виртуальный сетевой адаптер (TUN)",
    ),
    "trustCertificate": MessageLookupByLibrary.simpleMessage(
      "Доверять сертификату",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunAuthorizationFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось получить права для TUN, поэтому он выключен.",
    ),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "TUN работает только в режиме администратора.",
    ),
    "tunOverrideDesc": MessageLookupByLibrary.simpleMessage(
      "Добавленные здесь параметры заменяют настройки TUN всех профилей; остальные остаются такими, как в профиле. Параметры, добавленные в самом пользовательском профиле, имеют приоритет.",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Выключить"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Включить"),
    "udpRelayMode": MessageLookupByLibrary.simpleMessage(
      "Режим ретрансляции UDP",
    ),
    "udpTimeout": MessageLookupByLibrary.simpleMessage("Тайм-аут UDP"),
    "udpTimeoutDesc": MessageLookupByLibrary.simpleMessage(
      "Тайм-аут UDP задаётся в секундах и действует только со стеками gvisor, system и mixed.",
    ),
    "ultra": MessageLookupByLibrary.simpleMessage("Максимум"),
    "undo": MessageLookupByLibrary.simpleMessage("Отменить"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Единая задержка"),
    "unknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Неизвестная сетевая ошибка",
    ),
    "unmaximize": MessageLookupByLibrary.simpleMessage("Свернуть в окно"),
    "unnamed": MessageLookupByLibrary.simpleMessage("Без названия"),
    "unpinWindow": MessageLookupByLibrary.simpleMessage("Открепить окно"),
    "update": MessageLookupByLibrary.simpleMessage("Обновить"),
    "updateAll": MessageLookupByLibrary.simpleMessage("Обновить все"),
    "updateDownloadFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить обновление.",
    ),
    "updateDownloadStarted": MessageLookupByLibrary.simpleMessage(
      "Загрузка обновления началась. Следите за ходом на главной странице.",
    ),
    "updateDownloadTest": MessageLookupByLibrary.simpleMessage(
      "Тест загрузки обновления",
    ),
    "updateFailed": MessageLookupByLibrary.simpleMessage("Не удалось обновить"),
    "updateInstallFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось установить обновление. Его можно скачать на странице релиза.",
    ),
    "updateNotVerified": MessageLookupByLibrary.simpleMessage(
      "Не удалось проверить загруженное обновление.",
    ),
    "updateReady": MessageLookupByLibrary.simpleMessage("Обновление готово"),
    "updateReadyTip": MessageLookupByLibrary.simpleMessage(
      "Обновление загружено. Нажмите, чтобы установить.",
    ),
    "updateRestartTip": MessageLookupByLibrary.simpleMessage(
      "天机云 закроется для установки обновления и снова откроется после завершения.",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Отдача"),
    "uploadBandwidth": MessageLookupByLibrary.simpleMessage("Скорость отдачи"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlRewrite": MessageLookupByLibrary.simpleMessage("Перезапись URL"),
    "urlTip": m132,
    "useHosts": MessageLookupByLibrary.simpleMessage("Использовать hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Использовать системный hosts",
    ),
    "usedShort": MessageLookupByLibrary.simpleMessage("использовано"),
    "usedTraffic": MessageLookupByLibrary.simpleMessage(
      "Использованный трафик",
    ),
    "userAgent": MessageLookupByLibrary.simpleMessage("User-Agent"),
    "username": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
    "validUntil": m133,
    "value": MessageLookupByLibrary.simpleMessage("Значение"),
    "view": MessageLookupByLibrary.simpleMessage("Просмотр"),
    "viewAll": MessageLookupByLibrary.simpleMessage("Показать всё"),
    "virtualIpv4": MessageLookupByLibrary.simpleMessage("Виртуальный IPv4"),
    "vividStyle": MessageLookupByLibrary.simpleMessage("Яркий"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Настройки VPN изменены. Нажмите, чтобы перезапустить",
    ),
    "vpnTraffic": MessageLookupByLibrary.simpleMessage("VPN"),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Настройка WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage(
      "Режим белого списка",
    ),
    "writeToSystem": MessageLookupByLibrary.simpleMessage(
      "Записывать в систему",
    ),
    "writeToSystemDesc": MessageLookupByLibrary.simpleMessage(
      "«Записывать в систему» также устанавливает системные часы; Android это игнорирует.",
    ),
    "yearsAgo": m134,
    "yearsAgoShort": m135,
    "yes": MessageLookupByLibrary.simpleMessage("Да"),
    "zhCN": MessageLookupByLibrary.simpleMessage("Упрощённый китайский"),
    "zzAutoUpdateHours": m136,
    "zzAutoUpdateIntervalLabel": m137,
    "zzExpiryDate": m138,
    "zzProfileBasedOnOverrides": m139,
    "zzProfileExpiredDays": m140,
    "zzProfileImportHint": m141,
    "zzProfileImportedOn": m142,
    "zzQuickClipboard": MessageLookupByLibrary.simpleMessage("Буфер обмена"),
    "zzQuickLocalFile": MessageLookupByLibrary.simpleMessage("Локальный файл"),
    "zzQuickScan": MessageLookupByLibrary.simpleMessage("Сканировать"),
    "zzRemaining": MessageLookupByLibrary.simpleMessage("Осталось"),
    "zzRemainingDayUnit": MessageLookupByLibrary.simpleMessage("дн."),
    "zzRenewUpgradeShort": MessageLookupByLibrary.simpleMessage(
      "Продлить / улучшить",
    ),
    "zzTotalQuota": m143,
  };
}
