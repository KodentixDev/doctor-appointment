import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  az('AZ', 'Azərbaycanca'),
  ru('RU', 'Русский'),
  en('EN', 'English');

  final String code;
  final String label;

  const AppLanguage(this.code, this.label);
}

class AppLanguageController extends ChangeNotifier {
  static const _prefsKey = 'app_language';

  AppLanguage _language = AppLanguage.az;

  AppLanguage get language => _language;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    final savedLanguage = AppLanguage.values.where(
      (language) => language.code.toLowerCase() == code,
    );
    if (savedLanguage.isNotEmpty) {
      _language = savedLanguage.first;
    }
  }

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    unawaited(_save(language));
    notifyListeners();
  }

  Future<void> _save(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, language.code.toLowerCase());
  }
}

class AppLanguageScope extends InheritedNotifier<AppLanguageController> {
  const AppLanguageScope({
    super.key,
    required AppLanguageController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLanguageController controllerOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<AppLanguageScope>();
    assert(scope != null, 'AppLanguageScope is missing above this context.');
    return scope!.notifier!;
  }

  static AppLanguage languageOf(BuildContext context) {
    return controllerOf(context).language;
  }
}

extension AppLanguageX on BuildContext {
  AppLanguageController get languageController =>
      AppLanguageScope.controllerOf(this);

  AppLanguage get language => AppLanguageScope.languageOf(this);

  String tr(String azText) => AppTranslations.translate(azText, language);
}

class AppTranslations {
  AppTranslations._();

  static String translate(String azText, AppLanguage language) {
    if (language == AppLanguage.az) return azText;
    return _map[azText]?[language] ?? azText;
  }

  static const Map<String, Map<AppLanguage, String>> _map = {
    // ── App identity ──────────────────────────────────────────────────────────
    'Həkim Növbə': {
      AppLanguage.ru: 'Очередь к врачу',
      AppLanguage.en: 'Doctor Queue',
    },
    'Həkim': {AppLanguage.ru: 'Врач', AppLanguage.en: 'Doctor'},
    'Həkim ': {AppLanguage.ru: 'Врач ', AppLanguage.en: 'Doctor '},
    'Növbə': {AppLanguage.ru: 'Очередь', AppLanguage.en: 'Queue'},
    'Mərkəzi həkim növbə sistemi': {
      AppLanguage.ru: 'Центральная система записи к врачу',
      AppLanguage.en: 'Central doctor appointment system',
    },
    'Dövlət portalı vasitəsilə\ntəhlükəsiz daxil olun': {
      AppLanguage.ru: 'Войдите безопасно\nчерез государственный портал',
      AppLanguage.en: 'Sign in securely\nthrough the state portal',
    },
    'MyGov ilə Daxil Ol': {
      AppLanguage.ru: 'Войти через MyGov',
      AppLanguage.en: 'Sign in with MyGov',
    },
    'v2.4.0 · Səhiyyə Nazirliyi © 2026': {
      AppLanguage.ru: 'v2.4.0 · Минздрав © 2026',
      AppLanguage.en: 'v2.4.0 · Ministry of Health © 2026',
    },

    // ── Language / Settings ───────────────────────────────────────────────────
    'Dil': {AppLanguage.ru: 'Язык', AppLanguage.en: 'Language'},
    'Azərbaycanca': {
      AppLanguage.ru: 'Азербайджанский',
      AppLanguage.en: 'Azerbaijani',
    },
    'Rusca': {AppLanguage.ru: 'Русский', AppLanguage.en: 'Russian'},
    'İngiliscə': {AppLanguage.ru: 'Английский', AppLanguage.en: 'English'},

    // ── Bottom nav ────────────────────────────────────────────────────────────
    'Ana Səhifə': {AppLanguage.ru: 'Главная', AppLanguage.en: 'Home'},
    'Təqvim': {AppLanguage.ru: 'Календарь', AppLanguage.en: 'Calendar'},
    'Tələblər': {AppLanguage.ru: 'Заявки', AppLanguage.en: 'Requests'},
    'Menü': {AppLanguage.ru: 'Меню', AppLanguage.en: 'Menu'},
    'Profil': {AppLanguage.ru: 'Профиль', AppLanguage.en: 'Profile'},

    // ── Home ──────────────────────────────────────────────────────────────────
    'Xoş gəldiniz': {
      AppLanguage.ru: 'Добро пожаловать',
      AppLanguage.en: 'Welcome',
    },
    'Poliklinik, həkim, xəstəxana axtar...': {
      AppLanguage.ru: 'Искать поликлинику, врача, больницу...',
      AppLanguage.en: 'Search clinic, doctor, hospital...',
    },
    'NÖVBƏ AL': {AppLanguage.ru: 'ЗАПИСАТЬСЯ', AppLanguage.en: 'BOOK'},
    'Ailə Həkimindən': {
      AppLanguage.ru: 'У семейного врача',
      AppLanguage.en: 'From family doctor',
    },
    'Qeydiyyatda olduğunuz həkim': {
      AppLanguage.ru: 'Врач, у которого вы зарегистрированы',
      AppLanguage.en: 'Your registered doctor',
    },
    'Xəstəxanadan': {
      AppLanguage.ru: 'В больнице',
      AppLanguage.en: 'From hospital',
    },
    'Dövlət və özəl müəssisələr': {
      AppLanguage.ru: 'Государственные и частные учреждения',
      AppLanguage.en: 'Public and private institutions',
    },
    'Sağlam Həyat Mərkəzi': {
      AppLanguage.ru: 'Центр здоровой жизни',
      AppLanguage.en: 'Healthy Life Center',
    },
    'Profilaktika xidmətləri': {
      AppLanguage.ru: 'Профилактические услуги',
      AppLanguage.en: 'Preventive services',
    },
    'Yaxınlaşan növbələrim': {
      AppLanguage.ru: 'Ближайшие записи',
      AppLanguage.en: 'Upcoming appointments',
    },
    'Hamısı': {AppLanguage.ru: 'Все', AppLanguage.en: 'All'},
    'Aktiv növbəniz yoxdur': {
      AppLanguage.ru: 'У вас нет активной записи',
      AppLanguage.en: 'You have no active appointments',
    },

    // ── Menu ─────────────────────────────────────────────────────────────────
    'Məlumatlarım': {
      AppLanguage.ru: 'Мои данные',
      AppLanguage.en: 'My information',
    },
    'Ad, soyad, əlaqə': {
      AppLanguage.ru: 'Имя, фамилия, контакты',
      AppLanguage.en: 'Name, surname, contact',
    },
    'Növbələrim': {
      AppLanguage.ru: 'Мои записи',
      AppLanguage.en: 'My appointments',
    },
    'Keçmiş və aktiv növbələr': {
      AppLanguage.ru: 'Прошлые и активные записи',
      AppLanguage.en: 'Past and active appointments',
    },
    'Parametrlər': {AppLanguage.ru: 'Настройки', AppLanguage.en: 'Settings'},
    'Dil, tema, bildirişlər': {
      AppLanguage.ru: 'Язык, тема, уведомления',
      AppLanguage.en: 'Language, theme, notifications',
    },
    'Haqqında': {AppLanguage.ru: 'О приложении', AppLanguage.en: 'About'},
    'Versiya, lisenziya': {
      AppLanguage.ru: 'Версия, лицензия',
      AppLanguage.en: 'Version, license',
    },
    'Çıxış Et': {AppLanguage.ru: 'Выйти', AppLanguage.en: 'Log out'},
    'Çıxış etmək istəyirsiniz?': {
      AppLanguage.ru: 'Хотите выйти?',
      AppLanguage.en: 'Do you want to log out?',
    },
    'Hesabdan çıxdıqdan sonra yenidən\nMyGov ilə daxil olmaq lazım olacaq.': {
      AppLanguage.ru: 'После выхода нужно будет снова\nвойти через MyGov.',
      AppLanguage.en:
          'After logging out you will need to\nsign in with MyGov again.',
    },
    'Bəli, Çıxış Et': {
      AppLanguage.ru: 'Да, выйти',
      AppLanguage.en: 'Yes, log out',
    },
    'Ləğv Et': {AppLanguage.ru: 'Отмена', AppLanguage.en: 'Cancel'},

    // ── Settings ─────────────────────────────────────────────────────────────
    'GÖRÜNÜŞ': {AppLanguage.ru: 'ВИД', AppLanguage.en: 'APPEARANCE'},
    'Tətbiq dili': {
      AppLanguage.ru: 'Язык приложения',
      AppLanguage.en: 'App language',
    },
    'İnterfeys dili': {
      AppLanguage.ru: 'Язык интерфейса',
      AppLanguage.en: 'Interface language',
    },
    'Tünd tema': {AppLanguage.ru: 'Темная тема', AppLanguage.en: 'Dark mode'},
    'Dark mode aktivdir': {
      AppLanguage.ru: 'Темная тема включена',
      AppLanguage.en: 'Dark mode is enabled',
    },
    'BİLDİRİŞLƏR': {
      AppLanguage.ru: 'УВЕДОМЛЕНИЯ',
      AppLanguage.en: 'NOTIFICATIONS',
    },
    'Növbə xatırlatması': {
      AppLanguage.ru: 'Напоминание о записи',
      AppLanguage.en: 'Appointment reminder',
    },
    '1 gün əvvəl bildiriş': {
      AppLanguage.ru: 'Уведомление за 1 день',
      AppLanguage.en: 'Notify 1 day before',
    },
    'SMS bildirişi': {
      AppLanguage.ru: 'SMS уведомление',
      AppLanguage.en: 'SMS notification',
    },
    'Nömrənizə SMS': {
      AppLanguage.ru: 'SMS на ваш номер',
      AppLanguage.en: 'SMS to your number',
    },
    'HESAB': {AppLanguage.ru: 'АККАУНТ', AppLanguage.en: 'ACCOUNT'},
    'Hesabdan çıxış': {
      AppLanguage.ru: 'Выйти из аккаунта',
      AppLanguage.en: 'Sign out of account',
    },
    'Dil Seçin': {
      AppLanguage.ru: 'Выберите язык',
      AppLanguage.en: 'Choose language',
    },
    'Yadda Saxla': {AppLanguage.ru: 'Сохранить', AppLanguage.en: 'Save'},

    // ── Appointments screen ───────────────────────────────────────────────────
    'Aktiv': {AppLanguage.ru: 'Активные', AppLanguage.en: 'Active'},
    'Keçmiş': {AppLanguage.ru: 'Прошлые', AppLanguage.en: 'Past'},
    'Ləğv edilmiş': {AppLanguage.ru: 'Отмененные', AppLanguage.en: 'Cancelled'},
    'Təsdiqləndi': {
      AppLanguage.ru: 'Подтверждено',
      AppLanguage.en: 'Confirmed',
    },
    'Gözlənilir': {AppLanguage.ru: 'Ожидается', AppLanguage.en: 'Pending'},
    'Növbə tapılmadı': {
      AppLanguage.ru: 'Запись не найдена',
      AppLanguage.en: 'No appointment found',
    },
    'Xəstəxana': {AppLanguage.ru: 'Больница', AppLanguage.en: 'Hospital'},
    'Detallar': {AppLanguage.ru: 'Детали', AppLanguage.en: 'Details'},
    'Növbəni ləğv etmək istəyirsiniz?': {
      AppLanguage.ru: 'Хотите отменить запись?',
      AppLanguage.en: 'Do you want to cancel the appointment?',
    },
    'Bu əməliyyat geri alına bilməz.': {
      AppLanguage.ru: 'Это действие нельзя отменить.',
      AppLanguage.en: 'This action cannot be undone.',
    },
    'Bəli, Ləğv Et': {
      AppLanguage.ru: 'Да, отменить',
      AppLanguage.en: 'Yes, cancel',
    },
    'Geri Qayıt': {AppLanguage.ru: 'Назад', AppLanguage.en: 'Go back'},

    // ── Calendar screen ───────────────────────────────────────────────────────
    'PLANLAŞDIRILMIŞ NÖVBƏLƏR': {
      AppLanguage.ru: 'ЗАПЛАНИРОВАННЫЕ ЗАПИСИ',
      AppLanguage.en: 'SCHEDULED APPOINTMENTS',
    },
    'Planlaşdırılmış növbə yoxdur': {
      AppLanguage.ru: 'Нет запланированных записей',
      AppLanguage.en: 'No scheduled appointments',
    },

    // ── Requests screen ───────────────────────────────────────────────────────
    'Bağla': {AppLanguage.ru: 'Закрыть', AppLanguage.en: 'Close'},
    'Müraciət və sorğularınızı izləyin': {
      AppLanguage.ru: 'Отслеживайте обращения и запросы',
      AppLanguage.en: 'Track your applications and requests',
    },
    'Aktiv tələb': {
      AppLanguage.ru: 'Активная заявка',
      AppLanguage.en: 'Active request',
    },
    'Gözləmədə': {AppLanguage.ru: 'В ожидании', AppLanguage.en: 'Waiting'},
    'Baxılır': {AppLanguage.ru: 'Рассматривается', AppLanguage.en: 'In review'},
    'SON TƏLƏBLƏR': {
      AppLanguage.ru: 'ПОСЛЕДНИЕ ЗАЯВКИ',
      AppLanguage.en: 'RECENT REQUESTS',
    },

    // ── Booking – city / hospital / specialty ─────────────────────────────────
    'Növbə Al': {AppLanguage.ru: 'Записаться', AppLanguage.en: 'Book'},
    'Şəhər': {AppLanguage.ru: 'Город', AppLanguage.en: 'City'},
    'Bölüm': {AppLanguage.ru: 'Отделение', AppLanguage.en: 'Department'},
    'Tarix': {AppLanguage.ru: 'Дата', AppLanguage.en: 'Date'},
    'Şəhər axtar...': {
      AppLanguage.ru: 'Искать город...',
      AppLanguage.en: 'Search city...',
    },
    'Seçildi': {AppLanguage.ru: 'Выбрано', AppLanguage.en: 'Selected'},
    'Xəstəxana Seçin': {
      AppLanguage.ru: 'Выберите больницу',
      AppLanguage.en: 'Choose hospital',
    },
    'Xəstəxana axtar...': {
      AppLanguage.ru: 'Искать больницу...',
      AppLanguage.en: 'Search hospital...',
    },
    'Boş var': {AppLanguage.ru: 'Есть места', AppLanguage.en: 'Available'},
    'Bölüm Seçin': {
      AppLanguage.ru: 'Выберите отделение',
      AppLanguage.en: 'Choose department',
    },
    'Bölüm axtar...': {
      AppLanguage.ru: 'Искать отделение...',
      AppLanguage.en: 'Search department...',
    },
    'Tarix Seçin': {
      AppLanguage.ru: 'Выберите дату',
      AppLanguage.en: 'Choose date',
    },
    'SƏHƏR': {AppLanguage.ru: 'УТРО', AppLanguage.en: 'MORNING'},
    'GÜNORTA': {AppLanguage.ru: 'ДЕНЬ', AppLanguage.en: 'AFTERNOON'},
    'Növbəni Təsdiqlə': {
      AppLanguage.ru: 'Подтвердить запись',
      AppLanguage.en: 'Confirm appointment',
    },
    'Bölmə': {AppLanguage.ru: 'Отделение', AppLanguage.en: 'Department'},
    'Addım': {AppLanguage.ru: 'Шаг', AppLanguage.en: 'Step'},
    'Şəhər seçin': {
      AppLanguage.ru: 'Выберите город',
      AppLanguage.en: 'Choose city',
    },
    'Xəstəxana seçin': {
      AppLanguage.ru: 'Выберите больницу',
      AppLanguage.en: 'Choose hospital',
    },
    'Bölmə seçin': {
      AppLanguage.ru: 'Выберите отделение',
      AppLanguage.en: 'Choose department',
    },
    'Həkim seçin': {
      AppLanguage.ru: 'Выберите врача',
      AppLanguage.en: 'Choose doctor',
    },
    'Tarix və vaxt seçin': {
      AppLanguage.ru: 'Выберите дату и время',
      AppLanguage.en: 'Choose date and time',
    },
    'Randevu almaq istədiyiniz şəhəri seçin': {
      AppLanguage.ru: 'Выберите город для записи',
      AppLanguage.en: 'Choose the city for your appointment',
    },
    'şəhərindəki xəstəxanaları seçin': {
      AppLanguage.ru: 'выберите больницу в этом городе',
      AppLanguage.en: 'choose a hospital in this city',
    },
    'xəstəxanasının bölmələri': {
      AppLanguage.ru: 'отделения больницы',
      AppLanguage.en: 'hospital departments',
    },
    'bölməsindəki həkimlər': {
      AppLanguage.ru: 'врачи отделения',
      AppLanguage.en: 'department doctors',
    },
    'Şəhər axtarın': {
      AppLanguage.ru: 'Поиск города',
      AppLanguage.en: 'Search city',
    },
    'Xəstəxana axtarın': {
      AppLanguage.ru: 'Поиск больницы',
      AppLanguage.en: 'Search hospital',
    },
    'Bölmə axtarın': {
      AppLanguage.ru: 'Поиск отделения',
      AppLanguage.en: 'Search department',
    },
    'Həkim axtarın': {
      AppLanguage.ru: 'Поиск врача',
      AppLanguage.en: 'Search doctor',
    },
    'Şəhər adı yazın...': {
      AppLanguage.ru: 'Введите название города...',
      AppLanguage.en: 'Type a city name...',
    },
    'Xəstəxana adı yazın...': {
      AppLanguage.ru: 'Введите название больницы...',
      AppLanguage.en: 'Type a hospital name...',
    },
    'Bölmə adı yazın...': {
      AppLanguage.ru: 'Введите название отделения...',
      AppLanguage.en: 'Type a department name...',
    },
    'Həkim adı və ya ixtisas yazın...': {
      AppLanguage.ru: 'Введите имя врача или специальность...',
      AppLanguage.en: 'Type a doctor name or specialty...',
    },
    'Nəticə tapılmadı': {
      AppLanguage.ru: 'Ничего не найдено',
      AppLanguage.en: 'No results found',
    },
    'Növbəti': {AppLanguage.ru: 'Далее', AppLanguage.en: 'Next'},
    'Geri': {AppLanguage.ru: 'Назад', AppLanguage.en: 'Back'},
    'Randevunu Təsdiqlə': {
      AppLanguage.ru: 'Подтвердить запись',
      AppLanguage.en: 'Confirm appointment',
    },
    'Tarix seçin': {
      AppLanguage.ru: 'Выберите дату',
      AppLanguage.en: 'Choose a date',
    },
    'Saat seçin': {
      AppLanguage.ru: 'Выберите время',
      AppLanguage.en: 'Choose a time',
    },
    'Bu həkim üçün boş gün tapılmadı': {
      AppLanguage.ru: 'Для этого врача свободные дни не найдены',
      AppLanguage.en: 'No available days found for this doctor',
    },
    'Bu tarixdə boş vaxt yoxdur': {
      AppLanguage.ru: 'На эту дату нет свободного времени',
      AppLanguage.en: 'No available time on this date',
    },
    'Randevu yaratmaq mümkün olmadı.': {
      AppLanguage.ru: 'Не удалось создать запись.',
      AppLanguage.en: 'Could not create the appointment.',
    },
    'Məlumatlar yüklənmədi': {
      AppLanguage.ru: 'Не удалось загрузить данные',
      AppLanguage.en: 'Could not load data',
    },
    'Yüklənir': {AppLanguage.ru: 'Загрузка', AppLanguage.en: 'Loading'},
    'Bio': {AppLanguage.ru: 'Био', AppLanguage.en: 'Bio'},
    'Deaktiv': {AppLanguage.ru: 'Неактивный', AppLanguage.en: 'Inactive'},
    'İş qrafiki': {
      AppLanguage.ru: 'Рабочий график',
      AppLanguage.en: 'Work schedule',
    },
    'Həftəlik vaxt aralıqları': {
      AppLanguage.ru: 'Еженедельные временные интервалы',
      AppLanguage.en: 'Weekly time slots',
    },
    'Yeni vaxt': {AppLanguage.ru: 'Новое время', AppLanguage.en: 'New time'},
    'Vaxtı yenilə': {
      AppLanguage.ru: 'Обновить время',
      AppLanguage.en: 'Update time',
    },
    'Həftə günü': {AppLanguage.ru: 'День недели', AppLanguage.en: 'Weekday'},
    'Başlama': {AppLanguage.ru: 'Начало', AppLanguage.en: 'Start'},
    'Bitmə': {AppLanguage.ru: 'Окончание', AppLanguage.en: 'End'},
    'Yarat': {AppLanguage.ru: 'Создать', AppLanguage.en: 'Create'},
    'Yenilə': {AppLanguage.ru: 'Обновить', AppLanguage.en: 'Update'},
    'Sil': {AppLanguage.ru: 'Удалить', AppLanguage.en: 'Delete'},
    'Cədvəl yoxdur': {
      AppLanguage.ru: 'График отсутствует',
      AppLanguage.en: 'No schedule',
    },
    'Vaxt aralığı əlavə edildi': {
      AppLanguage.ru: 'Временной интервал добавлен',
      AppLanguage.en: 'Time slot added',
    },
    'Vaxt aralığı yeniləndi': {
      AppLanguage.ru: 'Временной интервал обновлен',
      AppLanguage.en: 'Time slot updated',
    },
    'Vaxt aralığı silindi': {
      AppLanguage.ru: 'Временной интервал удален',
      AppLanguage.en: 'Time slot deleted',
    },
    'Vaxt aralığı silinsin?': {
      AppLanguage.ru: 'Удалить временной интервал?',
      AppLanguage.en: 'Delete time slot?',
    },
    'Bazar ertəsi': {AppLanguage.ru: 'Понедельник', AppLanguage.en: 'Monday'},
    'Çərşənbə axşamı': {AppLanguage.ru: 'Вторник', AppLanguage.en: 'Tuesday'},
    'Çərşənbə': {AppLanguage.ru: 'Среда', AppLanguage.en: 'Wednesday'},
    'Cümə axşamı': {AppLanguage.ru: 'Четверг', AppLanguage.en: 'Thursday'},
    'Cümə': {AppLanguage.ru: 'Пятница', AppLanguage.en: 'Friday'},
    'Şənbə': {AppLanguage.ru: 'Суббота', AppLanguage.en: 'Saturday'},
    'Bazar': {AppLanguage.ru: 'Воскресенье', AppLanguage.en: 'Sunday'},
    'Paytaxta yaxın rayon': {
      AppLanguage.ru: 'Район рядом со столицей',
      AppLanguage.en: 'District near the capital',
    },
    'Mərkəzi rayon xəstəxanaları': {
      AppLanguage.ru: 'Центральные районные больницы',
      AppLanguage.en: 'Central district hospitals',
    },
    'Dövlət tibb müəssisələri': {
      AppLanguage.ru: 'Государственные медицинские учреждения',
      AppLanguage.en: 'Public medical institutions',
    },
    'Rayon tibb mərkəzi': {
      AppLanguage.ru: 'Районный медицинский центр',
      AppLanguage.en: 'District medical center',
    },
    'Ambulator və stasionar xidmətlər': {
      AppLanguage.ru: 'Амбулаторные и стационарные услуги',
      AppLanguage.en: 'Outpatient and inpatient services',
    },
    'Mərkəzi klinik xidmətlər': {
      AppLanguage.ru: 'Центральные клинические услуги',
      AppLanguage.en: 'Central clinical services',
    },
    'Cənub bölgəsi': {
      AppLanguage.ru: 'Южный регион',
      AppLanguage.en: 'Southern region',
    },
    'Paytaxt · 47 xəstəxana': {
      AppLanguage.ru: 'Столица · 47 больниц',
      AppLanguage.en: 'Capital · 47 hospitals',
    },
    'Rayon və şəhər xəstəxanaları': {
      AppLanguage.ru: 'Районные и городские больницы',
      AppLanguage.en: 'District and city hospitals',
    },
    'II ən böyük şəhər': {
      AppLanguage.ru: 'Второй крупнейший город',
      AppLanguage.en: 'Second largest city',
    },
    'Regional tibb mərkəzləri': {
      AppLanguage.ru: 'Региональные медицинские центры',
      AppLanguage.en: 'Regional medical centers',
    },
    'Şəhər klinik xidmətləri': {
      AppLanguage.ru: 'Городские клинические услуги',
      AppLanguage.en: 'City clinical services',
    },
    'Muxtar respublika': {
      AppLanguage.ru: 'Автономная республика',
      AppLanguage.en: 'Autonomous republic',
    },
    'Sənaye şəhəri': {
      AppLanguage.ru: 'Промышленный город',
      AppLanguage.en: 'Industrial city',
    },
    'Şimal-qərb bölgəsi': {
      AppLanguage.ru: 'Северо-западный регион',
      AppLanguage.en: 'Northwestern region',
    },
    'Cərrahiyyə': {AppLanguage.ru: 'Хирургия', AppLanguage.en: 'Surgery'},
    'Kardioloji': {AppLanguage.ru: 'Кардиология', AppLanguage.en: 'Cardiology'},
    'Nevroloji': {AppLanguage.ru: 'Неврология', AppLanguage.en: 'Neurology'},
    'Pediatriya': {AppLanguage.ru: 'Педиатрия', AppLanguage.en: 'Pediatrics'},
    'Terapiya': {AppLanguage.ru: 'Терапия', AppLanguage.en: 'Therapy'},
    'Oftalmologiya': {
      AppLanguage.ru: 'Офтальмология',
      AppLanguage.en: 'Ophthalmology',
    },
    'Endokrinologiya': {
      AppLanguage.ru: 'Эндокринология',
      AppLanguage.en: 'Endocrinology',
    },
    'Cərrahi müdaxilə və əməliyyatlar': {
      AppLanguage.ru: 'Хирургические вмешательства и операции',
      AppLanguage.en: 'Surgical procedures and operations',
    },
    'Ürək-damar xəstəlikləri': {
      AppLanguage.ru: 'Сердечно-сосудистые заболевания',
      AppLanguage.en: 'Cardiovascular diseases',
    },
    'Sinir sistemi xəstəlikləri': {
      AppLanguage.ru: 'Заболевания нервной системы',
      AppLanguage.en: 'Nervous system diseases',
    },
    'Uşaq xəstəlikləri müayinəsi': {
      AppLanguage.ru: 'Обследование детских заболеваний',
      AppLanguage.en: 'Child disease examination',
    },
    'Ümumi terapevtik qəbul': {
      AppLanguage.ru: 'Общий терапевтический прием',
      AppLanguage.en: 'General therapeutic visit',
    },
    'Göz xəstəlikləri': {
      AppLanguage.ru: 'Заболевания глаз',
      AppLanguage.en: 'Eye diseases',
    },
    'Hormon və maddələr mübadiləsi': {
      AppLanguage.ru: 'Гормоны и обмен веществ',
      AppLanguage.en: 'Hormones and metabolism',
    },
    'Cərrah': {AppLanguage.ru: 'Хирург', AppLanguage.en: 'Surgeon'},
    'Pediatr': {AppLanguage.ru: 'Педиатр', AppLanguage.en: 'Pediatrician'},
    'Terapevt': {AppLanguage.ru: 'Терапевт', AppLanguage.en: 'Therapist'},

    // ── Confirmation screen ───────────────────────────────────────────────────
    'Növbəniz Təsdiqləndi': {
      AppLanguage.ru: 'Ваша запись подтверждена',
      AppLanguage.en: 'Your appointment is confirmed',
    },
    'Təqvimə Əlavə Et': {
      AppLanguage.ru: 'Добавить в календарь',
      AppLanguage.en: 'Add to calendar',
    },
    'Ana Səhifəyə Qayıt': {
      AppLanguage.ru: 'Вернуться на главную',
      AppLanguage.en: 'Return home',
    },
    'Növbəni Ləğv Et': {
      AppLanguage.ru: 'Отменить запись',
      AppLanguage.en: 'Cancel appointment',
    },

    // ── Month names (full) ────────────────────────────────────────────────────
    'Yanvar': {AppLanguage.ru: 'Январь', AppLanguage.en: 'January'},
    'Fevral': {AppLanguage.ru: 'Февраль', AppLanguage.en: 'February'},
    'Mart': {AppLanguage.ru: 'Март', AppLanguage.en: 'March'},
    'Aprel': {AppLanguage.ru: 'Апрель', AppLanguage.en: 'April'},
    'May': {AppLanguage.ru: 'Май', AppLanguage.en: 'May'},
    'İyun': {AppLanguage.ru: 'Июнь', AppLanguage.en: 'June'},
    'İyul': {AppLanguage.ru: 'Июль', AppLanguage.en: 'July'},
    'Avqust': {AppLanguage.ru: 'Август', AppLanguage.en: 'August'},
    'Sentyabr': {AppLanguage.ru: 'Сентябрь', AppLanguage.en: 'September'},
    'Oktyabr': {AppLanguage.ru: 'Октябрь', AppLanguage.en: 'October'},
    'Noyabr': {AppLanguage.ru: 'Ноябрь', AppLanguage.en: 'November'},
    'Dekabr': {AppLanguage.ru: 'Декабрь', AppLanguage.en: 'December'},

    // ── Month names (short) ───────────────────────────────────────────────────
    'Yan': {AppLanguage.ru: 'Янв', AppLanguage.en: 'Jan'},
    'Fev': {AppLanguage.ru: 'Фев', AppLanguage.en: 'Feb'},
    'Mar': {AppLanguage.ru: 'Мар', AppLanguage.en: 'Mar'},
    'Apr': {AppLanguage.ru: 'Апр', AppLanguage.en: 'Apr'},
    // 'May' short == full — reuse key above
    'İyn': {AppLanguage.ru: 'Июн', AppLanguage.en: 'Jun'},
    'İyl': {AppLanguage.ru: 'Июл', AppLanguage.en: 'Jul'},
    'Avq': {AppLanguage.ru: 'Авг', AppLanguage.en: 'Aug'},
    'Sen': {AppLanguage.ru: 'Сен', AppLanguage.en: 'Sep'},
    'Okt': {AppLanguage.ru: 'Окт', AppLanguage.en: 'Oct'},
    'Noy': {AppLanguage.ru: 'Ноя', AppLanguage.en: 'Nov'},
    'Dek': {AppLanguage.ru: 'Дек', AppLanguage.en: 'Dec'},

    // ── Weekdays (short) ──────────────────────────────────────────────────────
    'B.e': {AppLanguage.ru: 'Пн', AppLanguage.en: 'Mon'},
    'Ç.a': {AppLanguage.ru: 'Вт', AppLanguage.en: 'Tue'},
    'Ç': {AppLanguage.ru: 'Ср', AppLanguage.en: 'Wed'},
    'C.a': {AppLanguage.ru: 'Чт', AppLanguage.en: 'Thu'},
    'C': {AppLanguage.ru: 'Пт', AppLanguage.en: 'Fri'},
    'Ş': {AppLanguage.ru: 'Сб', AppLanguage.en: 'Sat'},
    'B': {AppLanguage.ru: 'Вс', AppLanguage.en: 'Sun'},
    'BE': {AppLanguage.ru: 'ПН', AppLanguage.en: 'MON'},
    'ÇA': {AppLanguage.ru: 'ВТ', AppLanguage.en: 'TUE'},
    'Çə': {AppLanguage.ru: 'СР', AppLanguage.en: 'WED'},
    'CA': {AppLanguage.ru: 'ЧТ', AppLanguage.en: 'THU'},
    'Cü': {AppLanguage.ru: 'ПТ', AppLanguage.en: 'FRI'},
    'Şə': {AppLanguage.ru: 'СБ', AppLanguage.en: 'SAT'},
    'Ba': {AppLanguage.ru: 'ВС', AppLanguage.en: 'SUN'},

    // ── City / booking labels ─────────────────────────────────────────────────
    'ŞƏHƏRLƏR': {AppLanguage.ru: 'ГОРОДА', AppLanguage.en: 'CITIES'},
    'Addım 1 — Şəhər seçin': {
      AppLanguage.ru: 'Шаг 1 — Выберите город',
      AppLanguage.en: 'Step 1 — Choose city',
    },
    'XƏSTƏXANALAR': {AppLanguage.ru: 'БОЛЬНИЦЫ', AppLanguage.en: 'HOSPITALS'},
    'Bakı · Addım 2': {
      AppLanguage.ru: 'Баку · Шаг 2',
      AppLanguage.en: 'Baku · Step 2',
    },
    'Bakı · Şəhər Klinik Xəstəxanası': {
      AppLanguage.ru: 'Баку · Гор. клин. больница',
      AppLanguage.en: 'Baku · City Clinical Hospital',
    },

    // ── Confirmation extras ───────────────────────────────────────────────────
    'Növbəniz təqvimə əlavə edildi': {
      AppLanguage.ru: 'Запись добавлена в календарь',
      AppLanguage.en: 'Appointment added to calendar',
    },
    'Növbə nömrəsi:': {
      AppLanguage.ru: 'Номер записи:',
      AppLanguage.en: 'Appointment #:',
    },
    'Saat': {AppLanguage.ru: 'Время', AppLanguage.en: 'Time'},

    // ── About screen ──────────────────────────────────────────────────────────
    'Nazirlik': {AppLanguage.ru: 'Министерство', AppLanguage.en: 'Ministry'},
    'Səhiyyə Nazirliyi': {
      AppLanguage.ru: 'Министерство здравоохранения',
      AppLanguage.en: 'Ministry of Health',
    },
    'Buraxılış tarixi': {
      AppLanguage.ru: 'Дата выпуска',
      AppLanguage.en: 'Release date',
    },
    'Rəsmi sayt': {
      AppLanguage.ru: 'Официальный сайт',
      AppLanguage.en: 'Official website',
    },
    'Dəstək': {AppLanguage.ru: 'Поддержка', AppLanguage.en: 'Support'},
    'Kömək xətti': {
      AppLanguage.ru: 'Горячая линия',
      AppLanguage.en: 'Helpline',
    },
    'İstifadə şərtləri': {
      AppLanguage.ru: 'Условия использования',
      AppLanguage.en: 'Terms of use',
    },
    'Gizlilik siyasəti': {
      AppLanguage.ru: 'Политика конфиденциальности',
      AppLanguage.en: 'Privacy policy',
    },
    'Azərbaycan Respublikası Səhiyyə\nNazirliyinin rəsmi tətbiqi': {
      AppLanguage.ru: 'Официальное приложение\nМинздрава Азербайджана',
      AppLanguage.en: 'Official app of the Ministry\nof Health of Azerbaijan',
    },
    'Versiya 2.4.0 (Build 241)': {
      AppLanguage.ru: 'Версия 2.4.0 (Сборка 241)',
      AppLanguage.en: 'Version 2.4.0 (Build 241)',
    },
    '© 2025-2026 Azərbaycan Respublikası Səhiyyə Nazirliyi. Bütün hüquqlar qorunur': {
      AppLanguage.ru:
          '© 2025-2026 Министерство здравоохранения Азербайджана. Все права защищены',
      AppLanguage.en:
          '© 2025-2026 Ministry of Health of Azerbaijan. All rights reserved',
    },
    'tezliklə əlavə olunacaq': {
      AppLanguage.ru: 'скоро будет добавлено',
      AppLanguage.en: 'will be added soon',
    },

    // ── Personal info screen ──────────────────────────────────────────────────
    'ŞƏXSİ MƏLUMATLAR': {
      AppLanguage.ru: 'ЛИЧНЫЕ ДАННЫЕ',
      AppLanguage.en: 'PERSONAL INFO',
    },
    'ƏLAQƏ MƏLUMATLARI': {
      AppLanguage.ru: 'КОНТАКТНАЯ ИНФОРМАЦИЯ',
      AppLanguage.en: 'CONTACT INFO',
    },
    'Ad': {AppLanguage.ru: 'Имя', AppLanguage.en: 'First name'},
    'Soyad': {AppLanguage.ru: 'Фамилия', AppLanguage.en: 'Last name'},
    'Ata adı': {AppLanguage.ru: 'Отчество', AppLanguage.en: 'Patronymic'},
    'Doğum tarixi': {
      AppLanguage.ru: 'Дата рождения',
      AppLanguage.en: 'Date of birth',
    },
    'Cins': {AppLanguage.ru: 'Пол', AppLanguage.en: 'Gender'},
    'Kişi': {AppLanguage.ru: 'Мужчина', AppLanguage.en: 'Male'},
    'Mobil nömrə': {
      AppLanguage.ru: 'Мобильный номер',
      AppLanguage.en: 'Mobile number',
    },
    'E-poçt': {AppLanguage.ru: 'Эл. почта', AppLanguage.en: 'Email'},
    'Ünvan': {AppLanguage.ru: 'Адрес', AppLanguage.en: 'Address'},
    'Məlumatlarınız yadda saxlandı': {
      AppLanguage.ru: 'Ваши данные сохранены',
      AppLanguage.en: 'Your information has been saved',
    },
    'Təsdiqlənib': {AppLanguage.ru: 'Подтверждено', AppLanguage.en: 'Verified'},

    // ── Search screen ─────────────────────────────────────────────────────────
    'Həkimlər': {AppLanguage.ru: 'Врачи', AppLanguage.en: 'Doctors'},
    'Klinikalar': {AppLanguage.ru: 'Клиники', AppLanguage.en: 'Clinics'},
    'Xəstəxanalar': {AppLanguage.ru: 'Больницы', AppLanguage.en: 'Hospitals'},
    'İlk boş vaxt:': {
      AppLanguage.ru: 'Ближайшее время:',
      AppLanguage.en: 'Next available:',
    },

    // ── Auth / accounts ──────────────────────────────────────────────────────
    'Daxil ol': {AppLanguage.ru: 'Войти', AppLanguage.en: 'Sign in'},
    'Həkim və vətəndaş hesabları üçün təhlükəsiz giriş.': {
      AppLanguage.ru: 'Безопасный вход для врачей и граждан.',
      AppLanguage.en: 'Secure sign-in for doctor and citizen accounts.',
    },
    'Vətəndaş': {AppLanguage.ru: 'Гражданин', AppLanguage.en: 'Citizen'},
    'Həkim kimi daxil ol': {
      AppLanguage.ru: 'Войти как врач',
      AppLanguage.en: 'Sign in as doctor',
    },
    'Vətəndaş kimi daxil ol': {
      AppLanguage.ru: 'Войти как гражданин',
      AppLanguage.en: 'Sign in as citizen',
    },
    'Bu hesab həkim hesabı deyil.': {
      AppLanguage.ru: 'Эта учетная запись не является учетной записью врача.',
      AppLanguage.en: 'This account is not a doctor account.',
    },
    'Bu hesab vətəndaş hesabı deyil.': {
      AppLanguage.ru:
          'Эта учетная запись не является учетной записью гражданина.',
      AppLanguage.en: 'This account is not a citizen account.',
    },
    'Daxil olmaq mümkün olmadı.': {
      AppLanguage.ru: 'Не удалось войти.',
      AppLanguage.en: 'Could not sign in.',
    },
    'E-poçt ünvanınızı daxil edin': {
      AppLanguage.ru: 'Введите адрес эл. почты',
      AppLanguage.en: 'Enter your email address',
    },
    'E-poçt daxil edin': {
      AppLanguage.ru: 'Введите эл. почту',
      AppLanguage.en: 'Enter email',
    },
    'Düzgün e-poçt daxil edin': {
      AppLanguage.ru: 'Введите корректную эл. почту',
      AppLanguage.en: 'Enter a valid email',
    },
    'Şifrə': {AppLanguage.ru: 'Пароль', AppLanguage.en: 'Password'},
    'Şifrənizi daxil edin': {
      AppLanguage.ru: 'Введите пароль',
      AppLanguage.en: 'Enter your password',
    },
    'Şifrə daxil edin': {
      AppLanguage.ru: 'Введите пароль',
      AppLanguage.en: 'Enter password',
    },
    'Vətəndaş kimi qeydiyyatdan keç': {
      AppLanguage.ru: 'Зарегистрироваться как гражданин',
      AppLanguage.en: 'Register as citizen',
    },
    'Vətəndaş qeydiyyatı': {
      AppLanguage.ru: 'Регистрация гражданина',
      AppLanguage.en: 'Citizen registration',
    },
    'Vətəndaş hesabı yaradın': {
      AppLanguage.ru: 'Создайте учетную запись гражданина',
      AppLanguage.en: 'Create a citizen account',
    },
    'Qeydiyyat yalnız vətəndaşlar üçündür. Həkim hesabları administrator tərəfindən yaradılır.': {
      AppLanguage.ru:
          'Регистрация доступна только для граждан. Учетные записи врачей создаются администратором.',
      AppLanguage.en:
          'Registration is only for citizens. Doctor accounts are created by an administrator.',
    },
    'Qeydiyyat tamamlandı. İndi daxil olun.': {
      AppLanguage.ru: 'Регистрация завершена. Теперь войдите.',
      AppLanguage.en: 'Registration is complete. Please sign in.',
    },
    'Qeydiyyat mümkün olmadı.': {
      AppLanguage.ru: 'Не удалось зарегистрироваться.',
      AppLanguage.en: 'Could not register.',
    },
    'Telefon': {AppLanguage.ru: 'Телефон', AppLanguage.en: 'Phone'},
    'FIN kodu': {AppLanguage.ru: 'FIN-код', AppLanguage.en: 'FIN code'},
    'Adınız': {AppLanguage.ru: 'Ваше имя', AppLanguage.en: 'Your first name'},
    'Soyadınız': {
      AppLanguage.ru: 'Ваша фамилия',
      AppLanguage.en: 'Your last name',
    },
    'Minimum 8 simvol': {
      AppLanguage.ru: 'Минимум 8 символов',
      AppLanguage.en: 'Minimum 8 characters',
    },
    'Şifrə minimum 8 simvol olmalıdır': {
      AppLanguage.ru: 'Пароль должен содержать минимум 8 символов',
      AppLanguage.en: 'Password must be at least 8 characters',
    },
    'Şifrə təkrarı': {
      AppLanguage.ru: 'Повторите пароль',
      AppLanguage.en: 'Repeat password',
    },
    'Şifrəni təkrar daxil edin': {
      AppLanguage.ru: 'Введите пароль еще раз',
      AppLanguage.en: 'Enter the password again',
    },
    'Bu xananı doldurun': {
      AppLanguage.ru: 'Заполните это поле',
      AppLanguage.en: 'Fill in this field',
    },
    'Şifrələr uyğun gəlmir.': {
      AppLanguage.ru: 'Пароли не совпадают.',
      AppLanguage.en: 'Passwords do not match.',
    },
    'Qeydiyyatdan keç': {
      AppLanguage.ru: 'Зарегистрироваться',
      AppLanguage.en: 'Register',
    },

    // ── Doctor / shared work areas ───────────────────────────────────────────
    'Panel': {AppLanguage.ru: 'Панель', AppLanguage.en: 'Panel'},
    'Randevular': {AppLanguage.ru: 'Записи', AppLanguage.en: 'Appointments'},
    'Mesajlar': {AppLanguage.ru: 'Сообщения', AppLanguage.en: 'Messages'},
    'Bildirişlər': {
      AppLanguage.ru: 'Уведомления',
      AppLanguage.en: 'Notifications',
    },
    'Həkim paneli': {
      AppLanguage.ru: 'Панель врача',
      AppLanguage.en: 'Doctor panel',
    },
    'Bugünkü randevular': {
      AppLanguage.ru: 'Записи на сегодня',
      AppLanguage.en: 'Today\'s appointments',
    },
    'Bugün': {AppLanguage.ru: 'Сегодня', AppLanguage.en: 'Today'},
    'Yaxınlaşan': {AppLanguage.ru: 'Предстоящие', AppLanguage.en: 'Upcoming'},
    'Tamamlanmış': {AppLanguage.ru: 'Завершенные', AppLanguage.en: 'Completed'},
    'Bu gün qəbul': {
      AppLanguage.ru: 'Приемы сегодня',
      AppLanguage.en: 'Visits today',
    },
    'Yeni mesaj': {
      AppLanguage.ru: 'Новое сообщение',
      AppLanguage.en: 'New message',
    },
    'Qəbul siyahısı': {
      AppLanguage.ru: 'Список приема',
      AppLanguage.en: 'Visit list',
    },
    'Pasiyent sualları': {
      AppLanguage.ru: 'Вопросы пациентов',
      AppLanguage.en: 'Patient questions',
    },
    'Sizin qəbulunuza yazılan pasiyentlər': {
      AppLanguage.ru: 'Пациенты, записанные к вам',
      AppLanguage.en: 'Patients booked with you',
    },
    'Yeni randevu': {
      AppLanguage.ru: 'Новая запись',
      AppLanguage.en: 'New appointment',
    },
    'Bu bölmədə randevu yoxdur': {
      AppLanguage.ru: 'В этом разделе нет записей',
      AppLanguage.en: 'No appointments in this section',
    },
    'Vaxt': {AppLanguage.ru: 'Время', AppLanguage.en: 'Time'},
    'Qeyd': {AppLanguage.ru: 'Заметка', AppLanguage.en: 'Note'},
    'Mesaj yaz': {AppLanguage.ru: 'Написать', AppLanguage.en: 'Message'},
    'Qəbula al': {AppLanguage.ru: 'Принять', AppLanguage.en: 'Start visit'},
    'Kardioloq': {AppLanguage.ru: 'Кардиолог', AppLanguage.en: 'Cardiologist'},
    'Nevroloq': {AppLanguage.ru: 'Невролог', AppLanguage.en: 'Neurologist'},
    'Lisenziya': {AppLanguage.ru: 'Лицензия', AppLanguage.en: 'License'},
    'Həkim hesabı təsdiqlənib': {
      AppLanguage.ru: 'Учетная запись врача подтверждена',
      AppLanguage.en: 'Doctor account verified',
    },
    'HƏKİM MƏLUMATLARI': {
      AppLanguage.ru: 'ДАННЫЕ ВРАЧА',
      AppLanguage.en: 'DOCTOR INFO',
    },
    'Həkim hesabı': {
      AppLanguage.ru: 'Учетная запись врача',
      AppLanguage.en: 'Doctor account',
    },
    'İxtisas': {AppLanguage.ru: 'Специальность', AppLanguage.en: 'Specialty'},
    'İş yeri': {AppLanguage.ru: 'Место работы', AppLanguage.en: 'Workplace'},
    'Əli oğlu': {AppLanguage.ru: 'сын Али', AppLanguage.en: 'son of Ali'},
    '14 Mart 1992': {
      AppLanguage.ru: '14 марта 1992',
      AppLanguage.en: 'March 14, 1992',
    },
    'Həkim profili və əlaqə': {
      AppLanguage.ru: 'Профиль врача и контакты',
      AppLanguage.en: 'Doctor profile and contact',
    },
    'Sizin qəbulunuza yazılanlar': {
      AppLanguage.ru: 'Записанные к вам пациенты',
      AppLanguage.en: 'Patients booked with you',
    },
    'Müraciət və sorğular': {
      AppLanguage.ru: 'Обращения и запросы',
      AppLanguage.en: 'Applications and requests',
    },
    'Pasiyentlərlə yazışmalar': {
      AppLanguage.ru: 'Переписка с пациентами',
      AppLanguage.en: 'Messages with patients',
    },
    'Həkimlərlə yazışmalar': {
      AppLanguage.ru: 'Переписка с врачами',
      AppLanguage.en: 'Messages with doctors',
    },
    'Xəbərdarlıqlar və xatırlatmalar': {
      AppLanguage.ru: 'Оповещения и напоминания',
      AppLanguage.en: 'Alerts and reminders',
    },
    'Hesabdan çıxdıqdan sonra yenidən daxil olmaq lazım olacaq.': {
      AppLanguage.ru: 'После выхода нужно будет войти снова.',
      AppLanguage.en: 'After logging out, you will need to sign in again.',
    },
    'Çıxış et': {AppLanguage.ru: 'Выйти', AppLanguage.en: 'Log out'},
    'Bəli, çıxış et': {
      AppLanguage.ru: 'Да, выйти',
      AppLanguage.en: 'Yes, log out',
    },
    'Ləğv et': {AppLanguage.ru: 'Отмена', AppLanguage.en: 'Cancel'},
    'Xəta baş verdi': {
      AppLanguage.ru: 'Произошла ошибка',
      AppLanguage.en: 'An error occurred',
    },
    'Yenidən cəhd et': {
      AppLanguage.ru: 'Повторить',
      AppLanguage.en: 'Try again',
    },
    'Səbəb (istəyə bağlı)': {
      AppLanguage.ru: 'Причина (необязательно)',
      AppLanguage.en: 'Reason (optional)',
    },
    'Boş günlər yüklənmədi': {
      AppLanguage.ru: 'Не удалось загрузить свободные дни',
      AppLanguage.en: 'Available days could not be loaded',
    },
    'Bu tarixdə boş slot yoxdur': {
      AppLanguage.ru: 'На эту дату нет свободных слотов',
      AppLanguage.en: 'No available slots on this date',
    },
    'MÖVCUD VAXTLAR': {
      AppLanguage.ru: 'ДОСТУПНОЕ ВРЕМЯ',
      AppLanguage.en: 'AVAILABLE TIMES',
    },
    'Status': {AppLanguage.ru: 'Статус', AppLanguage.en: 'Status'},
    'B.E': {AppLanguage.ru: 'ПН', AppLanguage.en: 'MON'},
    'Ç.A': {AppLanguage.ru: 'ВТ', AppLanguage.en: 'TUE'},
    'C.A': {AppLanguage.ru: 'ЧТ', AppLanguage.en: 'THU'},

    // ── Messages, notifications, requests ────────────────────────────────────
    'Oxunmamış': {AppLanguage.ru: 'Непрочитанные', AppLanguage.en: 'Unread'},
    'Oxunmamış mesaj yoxdur': {
      AppLanguage.ru: 'Нет непрочитанных сообщений',
      AppLanguage.en: 'No unread messages',
    },
    'Mesaj yazın...': {
      AppLanguage.ru: 'Напишите сообщение...',
      AppLanguage.en: 'Write a message...',
    },
    'Mesaj göndərildi': {
      AppLanguage.ru: 'Сообщение отправлено',
      AppLanguage.en: 'Message sent',
    },
    'Pasiyent': {AppLanguage.ru: 'Пациент', AppLanguage.en: 'Patient'},
    'Cavabınızı burada yazıb pasiyentə göndərə bilərsiniz.': {
      AppLanguage.ru: 'Здесь можно написать ответ и отправить пациенту.',
      AppLanguage.en:
          'You can write your reply here and send it to the patient.',
    },
    'Mesajınızı burada yazıb həkimə göndərə bilərsiniz.': {
      AppLanguage.ru: 'Здесь можно написать сообщение и отправить врачу.',
      AppLanguage.en:
          'You can write your message here and send it to the doctor.',
    },
    'Analiz cavablarınızı görürəm, növbə günü mütləq gəlin.': {
      AppLanguage.ru:
          'Я вижу результаты анализов, обязательно приходите в день записи.',
      AppLanguage.en:
          'I can see your test results, please come on the appointment day.',
    },
    'Qeyd etdiyiniz şikayətləri konsultasiyada müzakirə edəcəyik.': {
      AppLanguage.ru: 'Мы обсудим указанные жалобы на консультации.',
      AppLanguage.en:
          'We will discuss your reported symptoms during the consultation.',
    },
    'Salam doktor, randevudan əvvəl analiz cavablarını göndərim?': {
      AppLanguage.ru:
          'Здравствуйте, доктор. Отправить результаты анализов до приема?',
      AppLanguage.en:
          'Hello doctor, should I send the test results before the appointment?',
    },
    'Növbə vaxtını 30 dəqiqə gecikdirmək mümkündür?': {
      AppLanguage.ru: 'Можно перенести время записи на 30 минут позже?',
      AppLanguage.en: 'Is it possible to delay the appointment by 30 minutes?',
    },
    'Təşəkkür edirəm.': {
      AppLanguage.ru: 'Спасибо.',
      AppLanguage.en: 'Thank you.',
    },
    'Dünən': {AppLanguage.ru: 'Вчера', AppLanguage.en: 'Yesterday'},
    'Həkim hesabı üçün xəbərdarlıqlar': {
      AppLanguage.ru: 'Оповещения для учетной записи врача',
      AppLanguage.en: 'Alerts for the doctor account',
    },
    'Randevu və mesaj xəbərdarlıqları': {
      AppLanguage.ru: 'Оповещения о записях и сообщениях',
      AppLanguage.en: 'Appointment and message alerts',
    },
    'Hamısı oxundu': {
      AppLanguage.ru: 'Все прочитано',
      AppLanguage.en: 'Mark all read',
    },
    'Bütün bildirişlər': {
      AppLanguage.ru: 'Все уведомления',
      AppLanguage.en: 'All notifications',
    },
    'Növbəniz təsdiqləndi': {
      AppLanguage.ru: 'Ваша запись подтверждена',
      AppLanguage.en: 'Your appointment is confirmed',
    },
    'Randevu xatırlatması': {
      AppLanguage.ru: 'Напоминание о записи',
      AppLanguage.en: 'Appointment reminder',
    },
    'Yeni həkim mesajı': {
      AppLanguage.ru: 'Новое сообщение от врача',
      AppLanguage.en: 'New doctor message',
    },
    'Yeni randevu alındı': {
      AppLanguage.ru: 'Получена новая запись',
      AppLanguage.en: 'New appointment received',
    },
    'Pasiyent gecikmə sorğusu göndərdi': {
      AppLanguage.ru: 'Пациент отправил запрос на перенос',
      AppLanguage.en: 'Patient sent a delay request',
    },
    'Günlük plan yeniləndi': {
      AppLanguage.ru: 'Дневной план обновлен',
      AppLanguage.en: 'Daily plan updated',
    },
    '5 dəq əvvəl': {AppLanguage.ru: '5 мин назад', AppLanguage.en: '5 min ago'},
    '1 saat əvvəl': {
      AppLanguage.ru: '1 час назад',
      AppLanguage.en: '1 hour ago',
    },
    '2 dəq əvvəl': {AppLanguage.ru: '2 мин назад', AppLanguage.en: '2 min ago'},
    '20 dəq əvvəl': {
      AppLanguage.ru: '20 мин назад',
      AppLanguage.en: '20 min ago',
    },
    'Dr. Nigar Abbasova ilə 8 May 2026 saat 09:30 randevunuz aktivdir.': {
      AppLanguage.ru:
          'Ваша запись к Dr. Nigar Abbasova на 8 мая 2026 в 09:30 активна.',
      AppLanguage.en:
          'Your appointment with Dr. Nigar Abbasova on May 8, 2026 at 09:30 is active.',
    },
    'Sabah saat 14:00-da nevroloq qəbulu planlaşdırılıb.': {
      AppLanguage.ru: 'Завтра в 14:00 запланирован прием невролога.',
      AppLanguage.en: 'A neurologist visit is scheduled tomorrow at 14:00.',
    },
    'Dr. Leyla Həsənova sizə mesaj göndərdi.': {
      AppLanguage.ru: 'Dr. Leyla Həsənova отправила вам сообщение.',
      AppLanguage.en: 'Dr. Leyla Həsənova sent you a message.',
    },
    'Məhəmməd Qardaşov bugün saat 09:30 üçün qeydiyyatdan keçdi.': {
      AppLanguage.ru: 'Məhəmməd Qardaşov записался на сегодня в 09:30.',
      AppLanguage.en: 'Məhəmməd Qardaşov booked today at 09:30.',
    },
    'Səbinə Alıyeva növbə vaxtını dəyişmək istəyir.': {
      AppLanguage.ru: 'Səbinə Alıyeva хочет изменить время записи.',
      AppLanguage.en: 'Səbinə Alıyeva wants to change the appointment time.',
    },
    'Bu gün üçün 6 aktiv qəbul görünür.': {
      AppLanguage.ru: 'На сегодня видно 6 активных приемов.',
      AppLanguage.en: 'There are 6 active visits for today.',
    },
    'Laborator analiz nəticəsi': {
      AppLanguage.ru: 'Результат лабораторного анализа',
      AppLanguage.en: 'Laboratory test result',
    },
    'Elektron göndəriş': {
      AppLanguage.ru: 'Электронное направление',
      AppLanguage.en: 'Electronic referral',
    },
    'Sığorta müraciəti': {
      AppLanguage.ru: 'Страховое обращение',
      AppLanguage.en: 'Insurance request',
    },
    'Bakı Şəhər Klinik Xəstəxanası': {
      AppLanguage.ru: 'Бакинская городская клиническая больница',
      AppLanguage.en: 'Baku City Clinical Hospital',
    },
    'Bakı, Nərimanov r., Əhmədli': {
      AppLanguage.ru: 'Баку, Наримановский р-н, Ахмедли',
      AppLanguage.en: 'Baku, Narimanov district, Ahmadli',
    },
    'Həkim Seçin': {
      AppLanguage.ru: 'Выберите врача',
      AppLanguage.en: 'Choose doctor',
    },
    'Addım 4 — Həkim seçin': {
      AppLanguage.ru: 'Шаг 4 — Выберите врача',
      AppLanguage.en: 'Step 4 — Choose doctor',
    },
    'Həkim axtar...': {
      AppLanguage.ru: 'Искать врача...',
      AppLanguage.en: 'Search doctor...',
    },
    'Bu gün üçün randevu yoxdur': {
      AppLanguage.ru: 'На сегодня записей нет',
      AppLanguage.en: 'No appointments for today',
    },
    'Randevu detalları': {
      AppLanguage.ru: 'Детали записи',
      AppLanguage.en: 'Appointment details',
    },
    'Ləğv səbəbi': {
      AppLanguage.ru: 'Причина отмены',
      AppLanguage.en: 'Cancellation reason',
    },
    'Gəlmədi': {AppLanguage.ru: 'Не явился', AppLanguage.en: 'No-show'},
    'Ortoped': {AppLanguage.ru: 'Ортопед', AppLanguage.en: 'Orthopedist'},
    'Oftalmoloq': {
      AppLanguage.ru: 'Офтальмолог',
      AppLanguage.en: 'Ophthalmologist',
    },
    'Pulmonoloq': {
      AppLanguage.ru: 'Пульмонолог',
      AppLanguage.en: 'Pulmonologist',
    },
    'Endokrinoloq': {
      AppLanguage.ru: 'Эндокринолог',
      AppLanguage.en: 'Endocrinologist',
    },
    '14 həkim': {AppLanguage.ru: '14 врачей', AppLanguage.en: '14 doctors'},
    '8 həkim': {AppLanguage.ru: '8 врачей', AppLanguage.en: '8 doctors'},
    '5 həkim': {AppLanguage.ru: '5 врачей', AppLanguage.en: '5 doctors'},
    '6 həkim': {AppLanguage.ru: '6 врачей', AppLanguage.en: '6 doctors'},
    '4 həkim': {AppLanguage.ru: '4 врача', AppLanguage.en: '4 doctors'},
    '3 həkim': {AppLanguage.ru: '3 врача', AppLanguage.en: '3 doctors'},
    '22 May 2026, 09:00': {
      AppLanguage.ru: '22 мая 2026, 09:00',
      AppLanguage.en: 'May 22, 2026, 09:00',
    },
    '19 May 2026, 10:30': {
      AppLanguage.ru: '19 мая 2026, 10:30',
      AppLanguage.en: 'May 19, 2026, 10:30',
    },
    '21 May 2026, 11:00': {
      AppLanguage.ru: '21 мая 2026, 11:00',
      AppLanguage.en: 'May 21, 2026, 11:00',
    },
    '26 May 2026, 12:00': {
      AppLanguage.ru: '26 мая 2026, 12:00',
      AppLanguage.en: 'May 26, 2026, 12:00',
    },
    '28 May 2026, 09:30': {
      AppLanguage.ru: '28 мая 2026, 09:30',
      AppLanguage.en: 'May 28, 2026, 09:30',
    },
    '28 May 2026, 15:00': {
      AppLanguage.ru: '28 мая 2026, 15:00',
      AppLanguage.en: 'May 28, 2026, 15:00',
    },
    'Respublika Klinik Xəstəxanası': {
      AppLanguage.ru: 'Республиканская клиническая больница',
      AppLanguage.en: 'Republic Clinical Hospital',
    },
    'Mərkəzi Neftçilər Xəstəxanası': {
      AppLanguage.ru: 'Центральная больница нефтяников',
      AppLanguage.en: 'Central Oil Workers Hospital',
    },
    'Klinik Tibbi Mərkəz': {
      AppLanguage.ru: 'Клинический медицинский центр',
      AppLanguage.en: 'Clinical Medical Center',
    },
    'MedEra Hospital': {
      AppLanguage.ru: 'MedEra Hospital',
      AppLanguage.en: 'MedEra Hospital',
    },
    'Kardiologiya şöbəsi': {
      AppLanguage.ru: 'Кардиологическое отделение',
      AppLanguage.en: 'Cardiology department',
    },
    'İcbari Tibbi Sığorta': {
      AppLanguage.ru: 'Обязательное медицинское страхование',
      AppLanguage.en: 'Compulsory medical insurance',
    },
    '7 May 2026': {AppLanguage.ru: '7 мая 2026', AppLanguage.en: 'May 7, 2026'},
    '6 May 2026': {AppLanguage.ru: '6 мая 2026', AppLanguage.en: 'May 6, 2026'},
    '5 May 2026': {AppLanguage.ru: '5 мая 2026', AppLanguage.en: 'May 5, 2026'},
    '8 May 2026, 09:30': {
      AppLanguage.ru: '8 мая 2026, 09:30',
      AppLanguage.en: 'May 8, 2026, 09:30',
    },
    '15 May 2026, 14:00': {
      AppLanguage.ru: '15 мая 2026, 14:00',
      AppLanguage.en: 'May 15, 2026, 14:00',
    },
    'Bugün, 09:30': {
      AppLanguage.ru: 'Сегодня, 09:30',
      AppLanguage.en: 'Today, 09:30',
    },
    'Bugün, 11:00': {
      AppLanguage.ru: 'Сегодня, 11:00',
      AppLanguage.en: 'Today, 11:00',
    },
    '10 May 2026, 16:15': {
      AppLanguage.ru: '10 мая 2026, 16:15',
      AppLanguage.en: 'May 10, 2026, 16:15',
    },
  };
}
