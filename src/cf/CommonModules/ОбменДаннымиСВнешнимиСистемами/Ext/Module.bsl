﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2018, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
// Подсистема "ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемами".
// ОбщийМодуль.ОбменДаннымиСВнешнимиСистемами.
//
// Серверные процедуры и функции обмена данными с внешними системами:
//  - служебные процедуры и функции создание и настройки узлов обмена данными;
//  - обработки событий подсистемы "Обмен данными" Библиотеки стандартных подсистем.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ОбменДанными

// Вызывается при получении доступных для настройки вариантов настроек синхронизации данных.
//
// Параметры:
//  ПараметрыНастройки - Структура - описывает доступные варианты настроек:
//    * УзелОбмена - ПланОбменаСсылка, Неопределено - узел плана обмена, если он уже создан;
//    * ВариантыНастроек - ТаблицаЗначений - результирующая таблица доступных вариантов настроек:
//      ** ИмяПланаОбмена - Строка - наименование плана обмена;
//      ** ИдентификаторНастройки - Строка - идентификатор варианта настройки;
//      ** ЗаголовокКомандыДляСозданияНовогоОбменаДанными - Строка - заголовок ссылки на форме настройки нового
//                                                          обмена данными;
//      ** КраткаяИнформацияПоОбмену - ФорматированнаяСтрока - краткое описание возможностей обмена;
//      ** ПодробнаяИнформацияПоОбмену - Строка - подробное описание возможностей обмена;
//      ** ЗаголовокПомощникаСозданияОбмена - Строка - заголовок формы помощника настройки обмена данными;
//      ** НаименованиеКорреспондента - Строка - наименование внешней системы;
//      ** ПараметрыПодключения - Произвольный - настройки подключения к внешней системе;
//  АдресРезультата - Строка - адрес во временном хранилище, который содержит
//                             результат выполнения обработчика.
//
Процедура ПриПолученииВариантовНастроекОбменаДанными(ПараметрыНастройки, АдресРезультата) Экспорт
	
	СтруктураРезультата = Новый Структура;
	СтруктураРезультата.Вставить("КодОшибки",         ""); 
	СтруктураРезультата.Вставить("СообщениеОбОшибке", "");
	СтруктураРезультата.Вставить("ВариантыНастроек",  ПараметрыНастройки.ВариантыНастроек);
	
	Если ПараметрыНастройки.УзелОбмена <> Неопределено Тогда
		ЗаполнитьВариантыНастроекПоДаннымИнформационнойБазы(
			ПараметрыНастройки,
			СтруктураРезультата);
	Иначе
		ЗаполнитьВариантыНастроекПоДаннымСервиса(
				ПараметрыНастройки,
				СтруктураРезультата);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(СтруктураРезультата, АдресРезультата);
	
КонецПроцедуры

// Вызывается из фонового задания при удалении настройки синхронизации данных.
// Параметры:
//  Контекст - Структура - содержит контекст удаления узла плана обмена:
//    * Корреспондент - ПланОбменаСсылка - узел обмена, соответствующий корреспонденту.
//
Процедура ПриУдаленииНастройкиСинхронизации(Контекст) Экспорт
	
	ПараметрыПодключения = Неопределено;
	ОбменДаннымиСервер.ПриПолученииНастроекПодключенияВнешнейСистемы(
		Контекст,
		ПараметрыПодключения);
	
	РезультатОперации = СервисОбменаСообщениями.УдалитьИдентификаторОбменаДанными(
		ПараметрыПодключения.НастройкиТранспорта.ИдентификаторОбмена);
	
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		ВызватьИсключение РезультатОперации.СообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ОбменДанными

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Определяет настройки подключения к внешней системе, которые сохранены
// в узле плана обмена.
//
// Параметры:
//  УзелОбмена - ПланОбменаСсылка - узел плана обмена, для которого требуется определить настройки;
//
// Возвращаемое значение:
//  Произвольный - настройки обмена данными.
//
Функция ПриПолученииНастроекПодключенияВнешнейСистемы(УзелОбмена) Экспорт
	
	Контекст = Новый Структура;
	Контекст.Вставить("Корреспондент", УзелОбмена);
	
	ПараметрыПодключения = Неопределено;
	ОбменДаннымиСервер.ПриПолученииНастроекПодключенияВнешнейСистемы(
		Контекст,
		ПараметрыПодключения);
	
	Возврат ПараметрыПодключения;
	
КонецФункции

// Вызывается при получении доступных для настроек синхронизации данных,
// для нового обмена данными.
//
// Параметры:
//  Параметры - Структура
//    * УзелОбмена - ПланОбменаСсылка, Неопределено - узел плана обмена, если он уже создан;
//    * ВариантыНастроек - ТаблицаЗначений - результирующая таблица доступных вариантов настроек:
//      ** ИмяПланаОбмена - Строка - наименование плана обмена;
//      ** ИдентификаторНастройки - Строка - идентификатор варианта настройки;
//      ** ЗаголовокКомандыДляСозданияНовогоОбменаДанными - Строка - заголовок ссылки на форме настройки нового
//                                                          обмена данными;
//      ** КраткаяИнформацияПоОбмену - ФорматированнаяСтрока - краткое описание возможностей обмена;
//      ** ПодробнаяИнформацияПоОбмену - Строка - подробное описание возможностей обмена;
//      ** ЗаголовокПомощникаСозданияОбмена - Строка - заголовок формы помощника настройки обмена данными;
//      ** НаименованиеКорреспондента - Строка - наименование внешней системы;
//      ** ПараметрыПодключения - Произвольный - настройки подключения к внешней системе;
//  СтруктураРезультата - Структура - результат определения настроек:
//   *КодОшибки - Строка - код ошибки получения настроек;
//   *СообщениеОбОшибке - Строка - сообщение об ошибке для пользователей системы;
//   *ВариантыНастроек - ТаблицаЗначений - см. Параметры.ВариантыНастроек.
//
Процедура ЗаполнитьВариантыНастроекПоДаннымСервиса(Параметры, СтруктураРезультата)
	
	РезультатОперации = СервисОбменаСообщениями.ДоступныеВнешниеСистемы();
	Если ЗначениеЗаполнено(РезультатОперации.КодОшибки) Тогда
		ЗаполнитьЗначенияСвойств(
			СтруктураРезультата,
			РезультатОперации,
			"КодОшибки, СообщениеОбОшибке");
		Возврат;
	КонецЕсли;
	
	ИмяПланаОбмена = ИмяПланаОбмена();
	Для Каждого ОписаниеВнешнейСистемы Из РезультатОперации.ДанныеВнешнихСистем Цикл
		
		СтрокаВариантыНастроек = СтруктураРезультата.ВариантыНастроек.Добавить();
		
		СтрокаВариантыНастроек.ИмяПланаОбмена              = ИмяПланаОбмена;
		СтрокаВариантыНастроек.ИдентификаторНастройки      = ОписаниеВнешнейСистемы.ИдентификаторСистемы;
		СтрокаВариантыНастроек.ПодробнаяИнформацияПоОбмену = "";
		СтрокаВариантыНастроек.НаименованиеКорреспондента  = ОписаниеВнешнейСистемы.НаименованиеСистемы;
		
		СтрокаВариантыНастроек.ЗаголовокКомандыДляСозданияНовогоОбменаДанными =
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Получение данных из системы %1 через EnterpriseData'"),
				ОписаниеВнешнейСистемы.НаименованиеСистемы);
		
		ОписаниеСистемы = Новый ФорматированныйДокумент;
		ОписаниеСистемы.УстановитьHTML(ОписаниеВнешнейСистемы.ОписаниеСистемы, Новый Структура);
		СтрокаВариантыНастроек.КраткаяИнформацияПоОбмену = ОписаниеСистемы.ПолучитьФорматированнуюСтроку();
		
		СтрокаВариантыНастроек.ПараметрыПодключения = Новый Структура;
		Для Каждого Колонка Из РезультатОперации.ДанныеВнешнихСистем.Колонки Цикл
			СтрокаВариантыНастроек.ПараметрыПодключения.Вставить(Колонка.Имя, ОписаниеВнешнейСистемы[Колонка.Имя])
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры

// Вызывается при получении доступных для настроек синхронизации данных,
// для существующего обмена данными.
//
// Параметры:
//  Параметры - Структура
//    * УзелОбмена - ПланОбменаСсылка, Неопределено - узел плана обмена, если он уже создан;
//    * ВариантыНастроек - ТаблицаЗначений - результирующая таблица доступных вариантов настроек:
//      ** ИмяПланаОбмена - Строка - наименование плана обмена;
//      ** ИдентификаторНастройки - Строка - идентификатор варианта настройки;
//      ** ЗаголовокКомандыДляСозданияНовогоОбменаДанными - Строка - заголовок ссылки на форме настройки нового
//                                                          обмена данными;
//      ** КраткаяИнформацияПоОбмену - ФорматированнаяСтрока - краткое описание возможностей обмена;
//      ** ПодробнаяИнформацияПоОбмену - Строка - подробное описание возможностей обмена;
//      ** ЗаголовокПомощникаСозданияОбмена - Строка - заголовок формы помощника настройки обмена данными;
//      ** НаименованиеКорреспондента - Строка - наименование внешней системы;
//      ** ПараметрыПодключения - Произвольный - настройки подключения к внешней системе;
//  СтруктураРезультата - Структура - результат определения настроек:
//   *КодОшибки - Строка - код ошибки получения настроек;
//   *СообщениеОбОшибке - Строка - сообщение об ошибке для пользователей системы;
//   *ВариантыНастроек - ТаблицаЗначений - см. Параметры.ВариантыНастроек.
//
Процедура ЗаполнитьВариантыНастроекПоДаннымИнформационнойБазы(Параметры, СтруктураРезультата)
	
	ПараметрыПодключения = ПриПолученииНастроекПодключенияВнешнейСистемы(
		Параметры.УзелОбмена);
	НастройкиТранспорта = ПараметрыПодключения.НастройкиТранспорта;
	
	СтрокаВариантыНастроек = СтруктураРезультата.ВариантыНастроек.Добавить();
	
	СтрокаВариантыНастроек.ИмяПланаОбмена              = ИмяПланаОбмена();
	СтрокаВариантыНастроек.ИдентификаторНастройки      = НастройкиТранспорта.ИдентификаторСистемы;
	СтрокаВариантыНастроек.ПодробнаяИнформацияПоОбмену = "";
	СтрокаВариантыНастроек.НаименованиеКорреспондента  = НастройкиТранспорта.НаименованиеСистемы;
	
	СтрокаВариантыНастроек.ЗаголовокКомандыДляСозданияНовогоОбменаДанными =
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Получение данных из системы %1 через EnterpriseData'"),
			НастройкиТранспорта.НаименованиеСистемы);
	
	ОписаниеСистемы = Новый ФорматированныйДокумент;
	ОписаниеСистемы.УстановитьHTML(НастройкиТранспорта.ОписаниеСистемы, Новый Структура);
	СтрокаВариантыНастроек.КраткаяИнформацияПоОбмену = ОписаниеСистемы.ПолучитьФорматированнуюСтроку();
	
	СтрокаВариантыНастроек.ПараметрыПодключения = Новый Структура;
	Для Каждого КлючЗначение Из ПараметрыПодключения Цикл
		СтрокаВариантыНастроек.ПараметрыПодключения.Вставить(КлючЗначение.Ключ, КлючЗначение.Значение)
	КонецЦикла;
	
КонецПроцедуры

// Определяет имя плана обмена в котором будут сохранены настройки
// обмена данными с внешними системами.
//
// Возвращаемое значение:
//   Строка - имя плана обмена.
//
Функция ИмяПланаОбмена() Экспорт
	
	ИмяПланаОбмена = "";
	ОбменДаннымиСВнешнимиСистемамиПереопределяемый.ПриОпределенииИмениПланаОбмена(ИмяПланаОбмена);
	
	Если Не ЗначениеЗаполнено(ИмяПланаОбмена) Тогда
		ВызватьИсключение НСтр("ru = 'Не заполнена реализация переопределяемого метода
			|ОбменДаннымиСВнешнимиСистемамиПереопределяемый.ПриОпределенииИмениПланаОбмена.'");
	КонецЕсли;
	
	Возврат ИмяПланаОбмена;
	
КонецФункции

// Добавляет запись в журнал регистрации.
//
// Параметры:
//  СообщениеОбОшибке - Строка - комментарий к записи журнала регистрации;
//  Ошибка - Булево - если истина будет установлен уровень журнала регистрации "Ошибка".
//
Процедура ЗаписатьИнформациюВЖурналРегистрации(
		СообщениеОбОшибке,
		Ошибка = Истина) Экспорт
	
	УровеньЖР = ?(Ошибка, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация);
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(),
		УровеньЖР,
		,
		,
		Лев(СообщениеОбОшибке, 5120));
	
КонецПроцедуры

// Возвращает имя события для журнала регистрации, которое используется
// для записи событий загрузки данных из внешних систем.
//
// Возвращаемое значение:
//  Строка - имя события.
//
Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Обмен данными с внешними системами'",
		ОбщегоНазначения.КодОсновногоЯзыка());
	
КонецФункции

#КонецОбласти
