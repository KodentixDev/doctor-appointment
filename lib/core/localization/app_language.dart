import 'package:flutter/material.dart';

enum AppLanguage {
  az('AZ', 'Azərbaycanca'),
  ru('RU', 'Русский'),
  en('EN', 'English');

  final String code;
  final String label;

  const AppLanguage(this.code, this.label);
}

class AppLanguageController extends ChangeNotifier {
  AppLanguage _language = AppLanguage.az;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
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
    'Dil': {AppLanguage.ru: 'Язык', AppLanguage.en: 'Language'},
    'Azərbaycanca': {
      AppLanguage.ru: 'Азербайджанский',
      AppLanguage.en: 'Azerbaijani',
    },
    'Rusca': {AppLanguage.ru: 'Русский', AppLanguage.en: 'Russian'},
    'İngiliscə': {AppLanguage.ru: 'Английский', AppLanguage.en: 'English'},
    'Ana Səhifə': {AppLanguage.ru: 'Главная', AppLanguage.en: 'Home'},
    'Təqvim': {AppLanguage.ru: 'Календарь', AppLanguage.en: 'Calendar'},
    'Tələblər': {AppLanguage.ru: 'Заявки', AppLanguage.en: 'Requests'},
    'Menü': {AppLanguage.ru: 'Меню', AppLanguage.en: 'Menu'},
    'Profil': {AppLanguage.ru: 'Профиль', AppLanguage.en: 'Profile'},
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
    'PLANLAŞDIRILMIŞ NÖVBƏLƏR': {
      AppLanguage.ru: 'ЗАПЛАНИРОВАННЫЕ ЗАПИСИ',
      AppLanguage.en: 'SCHEDULED APPOINTMENTS',
    },
    'Planlaşdırılmış növbə yoxdur': {
      AppLanguage.ru: 'Нет запланированных записей',
      AppLanguage.en: 'No scheduled appointments',
    },
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
  };
}
