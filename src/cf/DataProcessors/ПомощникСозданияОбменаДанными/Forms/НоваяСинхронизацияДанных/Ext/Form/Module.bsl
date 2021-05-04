﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ОбменДаннымиСервер.ПроверитьВозможностьАдминистрированияОбменов();
	
	ПроверитьВозможностьНастройкиСинхронизацииДанных(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОбработчика = Неопределено;
	ПриНачалеПолученияВариантовНастроекОбменаДаннымиНаСервере(УникальныйИдентификатор, ПараметрыОбработчика, ДлительнаяОперация);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПриНачалеПолученияВариантовНастроекОбменаДанными(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	СтрокиКоманды = КомандыСозданияОбмена.НайтиСтроки(
		Новый Структура("НавигационнаяСсылка", НавигационнаяСсылкаФорматированнойСтроки));
		
	Если СтрокиКоманды.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаКоманды = СтрокиКоманды[0];
	СтандартнаяОбработка = Ложь;
	
	ПараметрыПомощника = Новый Структура;
	ПараметрыПомощника.Вставить("ИмяПланаОбмена",                     СтрокаКоманды.ИмяПланаОбмена);
	ПараметрыПомощника.Вставить("ИдентификаторНастройки",             СтрокаКоманды.ИдентификаторНастройки);
	ПараметрыПомощника.Вставить("ОписаниеВариантаНастройки",          СтрокаКоманды.ОписаниеВариантаНастройки);
	ПараметрыПомощника.Вставить("ОбменДаннымиСВнешнейСистемой",       СтрокаКоманды.ВнешняяСистема);
	ПараметрыПомощника.Вставить("ПараметрыПодключенияВнешнейСистемы", СтрокаКоманды.ПараметрыПодключенияВнешнейСистемы);
	ПараметрыПомощника.Вставить("НастройкаНовойСинхронизации");
	
	КлючУникальностиПомощника = ПараметрыПомощника.ИмяПланаОбмена + "_" + ПараметрыПомощника.ИдентификаторНастройки;
	
	ОткрытьФорму("Обработка.ПомощникСозданияОбменаДанными.Форма.НастройкаСинхронизации", ПараметрыПомощника, , КлючУникальностиПомощника);
	
	Закрыть();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияНадписьВнешниеСистемыОшибкаОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьЖурналРегистрации" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей.ОбменДаннымиСВнешнимиСистемами") Тогда
		
			СобытиеЖурналаРегистрации = Новый Массив;
			
			МодульОбменДаннымиСВнешнимиСистемамиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ОбменДаннымиСВнешнимиСистемамиКлиент");
			СобытиеЖурналаРегистрации.Добавить(МодульОбменДаннымиСВнешнимиСистемамиКлиент.ИмяСобытияЖурналаРегистрации());
			
			Отбор = Новый Структура;
			Отбор.Вставить("СобытиеЖурналаРегистрации", СобытиеЖурналаРегистрации);
			Отбор.Вставить("Уровень",                   "Ошибка");
			Отбор.Вставить("ДатаНачала",                ДатаНачалаОтбораЖурналаРегистрации());
			
			ЖурналРегистрацииКлиент.ОткрытьЖурналРегистрации(Отбор, ЭтотОбъект);
		
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьСписокНастроек(Команда)
	
	ПриНачалеПолученияВариантовНастроекОбменаДанными();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержку(Команда)
	
	Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("ИнтернетПоддержкаПользователей") Тогда
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПодключитьИнтернетПоддержкуЗавершение", ЭтотОбъект);
		
		МодульИнтернетПоддержкаПользователейКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнтернетПоддержкаПользователейКлиент");
		МодульИнтернетПоддержкаПользователейКлиент.ПодключитьИнтернетПоддержкуПользователей(ОповещениеОЗакрытии, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ДатаНачалаОтбораЖурналаРегистрации()
	
	Возврат НачалоДня(ТекущаяДатаСеанса());
	
КонецФункции

&НаКлиенте
Процедура ПриНачалеПолученияВариантовНастроекОбменаДанными(ПриОткрытии = Ложь)
	
	Если Не ПриОткрытии Тогда
		ПараметрыОбработчика = Неопределено;
		ПриНачалеПолученияВариантовНастроекОбменаДаннымиНаСервере(УникальныйИдентификатор, ПараметрыОбработчика, ДлительнаяОперация);
	КонецЕсли;
	
	Если ДлительнаяОперация Тогда
		Элементы.ПанельВариантыНастроек.ТекущаяСтраница  = Элементы.СтраницаОжидание;
		Элементы.ФормаОбновитьСписокНастроек.Доступность = Ложь;
		
		ОбменДаннымиКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);

		ПодключитьОбработчикОжидания("ПриОжиданииПолученияВариантовНастроекОбменаДанными",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииПолученияВариантовНастроекОбменаДанными();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииПолученияВариантовНастроекОбменаДанными()
	
	ПриОжиданииПолученияВариантовНастроекОбменаДаннымиНаСервере(ПараметрыОбработчика, ДлительнаяОперация);
	
	Если ДлительнаяОперация Тогда
		ОбменДаннымиКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);

		ПодключитьОбработчикОжидания("ПриОжиданииПолученияВариантовНастроекОбменаДанными",
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииПолученияВариантовНастроекОбменаДанными();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПолученияВариантовНастроекОбменаДанными()
	
	ПриЗавершенииПолученияВариантовНастроекОбменаДаннымиНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьИнтернетПоддержкуЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПриНачалеПолученияВариантовНастроекОбменаДанными();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриНачалеПолученияВариантовНастроекОбменаДаннымиНаСервере(УникальныйИдентификатор, ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощника = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	МодульПомощника.ПриНачалеПолученияВариантовНастроекОбменаДанными(УникальныйИдентификатор, ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииПолученияВариантовНастроекОбменаДаннымиНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	МодульПомощника = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	МодульПомощника.ПриОжиданииПолученияВариантовНастроекОбменаДанными(ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииПолученияВариантовНастроекОбменаДаннымиНаСервере()
	
	Настройки = Неопределено;
	
	МодульПомощника = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	МодульПомощника.ПриЗавершенииПолученияВариантовНастроекОбменаДанными(ПараметрыОбработчика, Настройки);
	
	ОчиститьКомандыСозданияНовогоОбмена();
	ДобавитьКомандыСозданияНовогоОбмена(Настройки);
	
	Элементы.ПанельВариантыНастроек.ТекущаяСтраница  = Элементы.СтраницаВариантыНастроек;
	Элементы.ФормаОбновитьСписокНастроек.Доступность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьКомандыСозданияНовогоОбмена()
	
	КомандыСозданияОбмена.Очистить();
	
	УдалитьПодчиненныеЭлементыГруппы(Элементы.ГруппаОбменДругиеПрограммы);
	УдалитьПодчиненныеЭлементыГруппы(Элементы.ГруппаОбменРИБ);
	УдалитьПодчиненныеЭлементыГруппы(Элементы.СтраницаВнешниеСистемыВариантыНастроек);
	
КонецПроцедуры

&НаСервере
Процедура УдалитьПодчиненныеЭлементыГруппы(ЭлементГруппа)
	
	Пока ЭлементГруппа.ПодчиненныеЭлементы.Количество() > 0 Цикл
		Элементы.Удалить(ЭлементГруппа.ПодчиненныеЭлементы[0]);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыСозданияНовогоОбмена(Настройки)
	
	СтандартныеНастройки = Неопределено;
	Если Настройки.Свойство("СтандартныеНастройки", СтандартныеНастройки) Тогда
		
		ТаблицаНастройкиДругиеПрограммы = СтандартныеНастройки.Скопировать(Новый Структура("ЭтоПланОбменаРИБ", Ложь));
		ТаблицаНастройкиДругиеПрограммы.Сортировать("ЭтоПланОбменаXDTO");
		ДобавитьКомандыСозданияНовогоОбменаСтандартныеНастройки(ТаблицаНастройкиДругиеПрограммы, Элементы.ГруппаОбменДругиеПрограммы);
		
		ТаблицаНастройкиРИБ = СтандартныеНастройки.Скопировать(Новый Структура("ЭтоПланОбменаРИБ", Истина));
		ДобавитьКомандыСозданияНовогоОбменаСтандартныеНастройки(ТаблицаНастройкиРИБ, Элементы.ГруппаОбменРИБ);
		
	КонецЕсли;
	
	НастройкиВнешниеСистемы = Неопределено;
	Если Настройки.Свойство("НастройкиВнешниеСистемы", НастройкиВнешниеСистемы) Тогда
		
		Элементы.ГруппаОбменВнешниеСистемы.Видимость = Истина;
		
		Если НастройкиВнешниеСистемы.КодОшибки = "" Тогда
			
			Если НастройкиВнешниеСистемы.ВариантыНастроек.Количество() > 0 Тогда
				ДобавитьКомандыСозданияНовогоОбменаНастройкиВнешниеСистемы(
					НастройкиВнешниеСистемы.ВариантыНастроек, Элементы.СтраницаВнешниеСистемыВариантыНастроек);
				Элементы.ПанельОбменВнешниеСистемы.ТекущаяСтраница = Элементы.СтраницаВнешниеСистемыВариантыНастроек;
			Иначе
				Элементы.ПанельОбменВнешниеСистемы.ТекущаяСтраница = Элементы.СтраницаВнешниеСистемыНетВариантовНастроек;
			КонецЕсли;
			
		ИначеЕсли НастройкиВнешниеСистемы.КодОшибки = "НеверныйЛогинИлиПароль" Тогда
			
			Если ОбщегоНазначения.РазделениеВключено()
				И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
				Элементы.ПанельОбменВнешниеСистемы.ТекущаяСтраница = Элементы.СтраницаВнешниеСистемыНеПодключенаИнтернетПоддержкаВМоделиСервиса;
			Иначе
				Элементы.ПанельОбменВнешниеСистемы.ТекущаяСтраница = Элементы.СтраницаВнешниеСистемыНеПодключенаИнтернетПоддержка;
			КонецЕсли;
			
		ИначеЕсли ЗначениеЗаполнено(НастройкиВнешниеСистемы.КодОшибки) Тогда
			
			Элементы.ПанельОбменВнешниеСистемы.ТекущаяСтраница = Элементы.СтраницаВнешниеСистемыОшибка;
			
		КонецЕсли;
		
	Иначе
		
		Элементы.ГруппаОбменВнешниеСистемы.Видимость = Ложь;
		
	КонецЕсли;
	
КонецПроцедуры

// Параметры:
//   ТаблицаНастройки - ТаблицаЗначений - таблица доступных настроек синхронизации.
//   РодительскаяГруппа - ГруппаФормы - родительский элемент формы.
//
&НаСервере
Процедура ДобавитьКомандыСозданияНовогоОбменаСтандартныеНастройки(ТаблицаНастройки, РодительскаяГруппа)
	
	ТаблицаКонфигурации = ТаблицаНастройки.Скопировать(, "ИмяКонфигурацииКорреспондента");
	ТаблицаКонфигурации.Свернуть("ИмяКонфигурацииКорреспондента");
	
	Для Каждого СтрокаКонфигурация Из ТаблицаКонфигурации Цикл
		
		СтрокиНастройки = ТаблицаНастройки.НайтиСтроки(
			Новый Структура("ИмяКонфигурацииКорреспондента", СтрокаКонфигурация.ИмяКонфигурацииКорреспондента));
		
		Для Каждого СтрокаНастройки Из СтрокиНастройки Цикл
			
			ОписаниеВариантаНастройки = СтруктураОписанияВариантаНастройки();
			ЗаполнитьЗначенияСвойств(ОписаниеВариантаНастройки, СтрокаНастройки);
			ОписаниеВариантаНастройки.НаименованиеКорреспондента = СтрокаНастройки.НаименованиеКонфигурацииКорреспондента;
			
			ДобавитьКомандуСозданияНовогоОбменаДляВариантаНастройки(
				РодительскаяГруппа,
				СтрокаНастройки.ИмяПланаОбмена,
				СтрокаНастройки.ИдентификаторНастройки,
				ОписаниеВариантаНастройки);
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандыСозданияНовогоОбменаНастройкиВнешниеСистемы(ВариантыНастроек, РодительскаяГруппа)
	
	Для Каждого ВариантНастроек Из ВариантыНастроек Цикл
		
		ОписаниеВариантаНастройки = СтруктураОписанияВариантаНастройки();
		ЗаполнитьЗначенияСвойств(ОписаниеВариантаНастройки, ВариантНастроек);
		
		ДобавитьКомандуСозданияНовогоОбменаДляВариантаНастройки(
			РодительскаяГруппа,
			ВариантНастроек.ИмяПланаОбмена,
			ВариантНастроек.ИдентификаторНастройки,
			ОписаниеВариантаНастройки,
			Истина,
			ВариантНастроек.ПараметрыПодключения);
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьКомандуСозданияНовогоОбменаДляВариантаНастройки(
		РодительскаяГруппа,
		ИмяПланаОбмена,
		ИдентификаторНастройки,
		ОписаниеВариантаНастройки,
		ВнешняяСистема = Ложь,
		ПараметрыПодключенияВнешнейСистемы = Неопределено)
	
	НавигационнаяСсылка = "Настройка" + ИмяПланаОбмена + "Вариант" + ИдентификаторНастройки;
			
	ЭлементСсылка = Элементы.Добавить(
		"ДекорацияНадпись" + НавигационнаяСсылка,
		Тип("ДекорацияФормы"),
		РодительскаяГруппа);
	ЭлементСсылка.Вид = ВидДекорацииФормы.Надпись;
	ЭлементСсылка.Заголовок = Новый ФорматированнаяСтрока(
		ОписаниеВариантаНастройки.ЗаголовокКомандыДляСозданияНовогоОбменаДанными, , , , НавигационнаяСсылка);
	ЭлементСсылка.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
	ЭлементСсылка.АвтоМаксимальнаяШирина = Ложь;
	
	ЭлементСсылка.РасширеннаяПодсказка.Заголовок = ОписаниеВариантаНастройки.КраткаяИнформацияПоОбмену;
	ЭлементСсылка.РасширеннаяПодсказка.АвтоМаксимальнаяШирина = Ложь;
	
	СтрокаКоманда = КомандыСозданияОбмена.Добавить();
	СтрокаКоманда.НавигационнаяСсылка = НавигационнаяСсылка;
	СтрокаКоманда.ИмяПланаОбмена = ИмяПланаОбмена;
	СтрокаКоманда.ИдентификаторНастройки = ИдентификаторНастройки;
	СтрокаКоманда.ОписаниеВариантаНастройки = ОписаниеВариантаНастройки;
	СтрокаКоманда.ВнешняяСистема = ВнешняяСистема;
	СтрокаКоманда.ПараметрыПодключенияВнешнейСистемы = ПараметрыПодключенияВнешнейСистемы;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтруктураОписанияВариантаНастройки()
	
	МодульПомощник = ОбменДаннымиСервер.МодульПомощникСозданияОбменаДанными();
	Возврат МодульПомощник.СтруктураОписанияВариантаНастройки();
	
КонецФункции

&НаСервере
Процедура ПроверитьВозможностьНастройкиСинхронизацииДанных(Отказ = Ложь)
	
	ТекстСообщения = "";
	Если ОбщегоНазначения.РазделениеВключено() Тогда
		Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
			МодульОбменДаннымиВМоделиСервисаПовтИсп = ОбщегоНазначения.ОбщийМодуль("ОбменДаннымиВМоделиСервисаПовтИсп");
			Если Не МодульОбменДаннымиВМоделиСервисаПовтИсп.СинхронизацияДанныхПоддерживается() Тогда
		 		ТекстСообщения = НСтр("ru = 'Возможность настройки синхронизации данных в данной программе не предусмотрена.'");
				Отказ = Истина;
			КонецЕсли;
		Иначе
			ТекстСообщения = НСтр("ru = 'В неразделенном режиме настройка синхронизации данных с другими программами недоступна.'");
			Отказ = Истина;
		КонецЕсли;
	Иначе
		СписокПлановОбмена = ОбменДаннымиПовтИсп.ПланыОбменаБСП();
		Если СписокПлановОбмена.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Возможность настройки синхронизации данных в данной программе не предусмотрена.'");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ
		И Не ПустаяСтрока(ТекстСообщения) Тогда
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти