﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ОбработчикиОбновления

// Регистрирует данные к обновлению в плане обмена ОбновлениеИнформационнойБазы.
//
// Параметры:
//  Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ЗарегистрироватьДанныеКОбработкеДляПереходаНаНовуюВерсию(Параметры) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	_ДемоРеализацияТоваровТовары.Ссылка КАК Ссылка
		|ИЗ
		|	Документ._ДемоРеализацияТоваров.Товары КАК _ДемоРеализацияТоваровТовары
		|ГДЕ
		|	_ДемоРеализацияТоваровТовары.КлючАналитики = ЗНАЧЕНИЕ(Справочник._ДемоКлючиАналитикиНоменклатуры.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбъектыКОбработке = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");

	Если ОбъектыКОбработке.Количество() > 0 Тогда
		ОбновлениеИнформационнойБазы.ОтметитьКОбработке(Параметры, ОбъектыКОбработке);
	КонецЕсли;
	
КонецПроцедуры

// Обрабатывает данные, зарегистрированные в плане обмена ОбновлениеИнформационнойБазы.
//
// Параметры:
//  Параметры - см. ОбновлениеИнформационнойБазы.ОсновныеПараметрыОтметкиКОбработке
//
Процедура ОбработатьДанныеДляПереходаНаНовуюВерсию(Параметры) Экспорт
	
	ПроблемныхОбъектов = 0;
	ОбъектовОбработано = 0;
	Параметры.ОбработкаЗавершена  = Ложь;
	РеализацияТоваров = ОбновлениеИнформационнойБазы.ВыбратьСсылкиДляОбработки(Параметры.Очередь, Метаданные.Документы._ДемоРеализацияТоваров.ПолноеИмя());
	
	Пока РеализацияТоваров.Следующий() Цикл
		
		Попытка                              
			
			ЗаполнитьКлючиАналитики(РеализацияТоваров);
			ОбъектовОбработано = ОбъектовОбработано + 1;
			
		Исключение
			// Если не удалось обработать какой-либо заказ, повторяем попытку снова.
			ПроблемныхОбъектов = ПроблемныхОбъектов + 1;
			
			ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось обработать Реализацию товаров: %1 по причине:
					|%2'"), 
					РеализацияТоваров.Ссылка, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Предупреждение,
				Метаданные.Документы._ДемоЗаказПокупателя, РеализацияТоваров.Ссылка, ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Параметры.ОбработкаЗавершена = ОбновлениеИнформационнойБазы.ОбработкаДанныхЗавершена(Параметры.Очередь, "Документ._ДемоРеализацияТоваров");
	Если ОбъектовОбработано = 0 И ПроблемныхОбъектов <> 0 Тогда
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Процедуре ЗаполнитьКлючиАналитики не удалось обработать некоторые заказы покупателей (пропущены): %1'"), 
				ПроблемныхОбъектов);
		ВызватьИсключение ТекстСообщения;
	Иначе
		ЗаписьЖурналаРегистрации(ОбновлениеИнформационнойБазы.СобытиеЖурналаРегистрации(), УровеньЖурналаРегистрации.Информация,
			Метаданные.Документы._ДемоЗаказПокупателя,,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Процедура ЗаполнитьСтатусыЗаказовПокупателей обработала очередную порцию заказов покупателей: %1'"),
					ОбъектовОбработано));
	КонецЕсли;
	

КонецПроцедуры

#КонецОбласти


#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//  КомандыОтчетов - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.КомандыОтчетов
//  Параметры - см. ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов.Параметры
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

// СтандартныеПодсистемы.УправлениеДоступом

// Параметры:
//   Ограничение - см. УправлениеДоступомПереопределяемый.ПриЗаполненииОграниченияДоступа.Ограничение.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(ГоловнаяОрганизация)
	|	И ЗначениеРазрешено(Подразделение)
	|	И ЗначениеРазрешено(Партнер)
	|	И ЗначениеРазрешено(МестоХранения)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ПодключаемыеКоманды

// Определяет список команд создания на основании.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//  Параметры - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.Параметры
//
Процедура ДобавитьКомандыСозданияНаОсновании(КомандыСозданияНаОсновании, Параметры) Экспорт
	
КонецПроцедуры

// Для использования в процедуре ДобавитьКомандыСозданияНаОсновании других модулей менеджеров объектов.
// Добавляет в список команд создания на основании этот объект.
//
// Параметры:
//  КомандыСозданияНаОсновании - см. СозданиеНаОснованииПереопределяемый.ПередДобавлениемКомандСозданияНаОсновании.КомандыСозданияНаОсновании
//
// Возвращаемое значение:
//  СтрокаТаблицыЗначений, Неопределено - описание добавленной команды.
//
Функция ДобавитьКомандуСоздатьНаОсновании(КомандыСозданияНаОсновании) Экспорт
	
	Возврат СозданиеНаОсновании.ДобавитьКомандуСозданияНаОсновании(КомандыСозданияНаОсновании, Метаданные.Документы._ДемоРеализацияТоваров);
	
КонецФункции

// Заполняет список команд печати.
//
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати.
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	// Расходная накладная
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "РасходнаяНакладная";
	КомандаПечати.Представление = НСтр("ru = 'Расходная накладная'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 10;

	// Реализация товаров
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор = "Накладная";
	КомандаПечати.Представление = НСтр("ru = 'Реализация товаров (на принтер)'");
	КомандаПечати.Картинка = БиблиотекаКартинок.ПечатьСразу;
	КомандаПечати.ПроверкаПроведенияПередПечатью = Истина;
	КомандаПечати.Порядок = 1;
	КомандаПечати.СразуНаПринтер = Истина;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов - см. УправлениеПечатьюПереопределяемый.ПриПечати.МассивОбъектов
//  ПараметрыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыПечати
//  КоллекцияПечатныхФорм - см. УправлениеПечатьюПереопределяемый.ПриПечати.КоллекцияПечатныхФорм
//  ОбъектыПечати - см. УправлениеПечатьюПереопределяемый.ПриПечати.ОбъектыПечати
//  ПараметрыВывода - см. УправлениеПечатьюПереопределяемый.ПриПечати.ПараметрыВывода
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Накладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"Накладная",
			НСтр("ru = 'Реализация товаров'"),
			СформироватьПечатнуюФормуРеализацияТоваров(МассивОбъектов, ОбъектыПечати),
			,
			"Документ._ДемоРеализацияТоваров.ПФ_MXL_РеализацияТоваров");
	КонецЕсли;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "РасходнаяНакладная") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(
			КоллекцияПечатныхФорм,
			"РасходнаяНакладная",
			НСтр("ru = 'Расходная накладная'"),
			СформироватьПечатнуюФормуРасходнаяНакладная(МассивОбъектов, ОбъектыПечати),
			,
			"Документ._ДемоРеализацияТоваров.ПФ_MXL_РасходнаяНакладная");
	КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьПечатнуюФормуРеализацияТоваров(МассивОбъектов, ОбъектыПечати)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	_ДемоРеализацияТоваров.Ссылка КАК Ссылка,
	|	_ДемоРеализацияТоваров.Номер КАК Номер,
	|	_ДемоРеализацияТоваров.Дата КАК Дата,
	|	_ДемоРеализацияТоваров.ГоловнаяОрганизация КАК Организация,
	|	_ДемоРеализацияТоваров.Контрагент КАК Контрагент,
	|	_ДемоРеализацияТоваров.СтавкаНДС КАК СтавкаНДС,
	|	_ДемоРеализацияТоваров.Валюта КАК Валюта,
	|	_ДемоРеализацияТоваров.Товары.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Товар,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		ВЫБОР
	|			КОГДА _ДемоРеестрДокументов.Сумма - _ДемоРеализацияТоваров.Товары.Цена * _ДемоРеализацияТоваров.Товары.Количество = 0
	|				ТОГДА _ДемоРеализацияТоваров.Товары.Цена * _ДемоРеализацияТоваров.Товары.Количество
	|			ИНАЧЕ _ДемоРеестрДокументов.Сумма - _ДемоРеализацияТоваров.Товары.Цена * _ДемоРеализацияТоваров.Товары.Количество
	|		КОНЕЦ КАК Сумма,
	|		ВЫБОР
	|			КОГДА _ДемоРеализацияТоваров.Товары.Количество > 0
	|				ТОГДА ""шт""
	|		КОНЕЦ КАК ПредставлениеБазовойЕдиницыИзмерения
	|	) КАК Товары,
	|	_ДемоРеестрДокументов.Сумма КАК СуммаВсего
	|ИЗ
	|	РегистрСведений._ДемоРеестрДокументов КАК _ДемоРеестрДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ._ДемоРеализацияТоваров КАК _ДемоРеализацияТоваров
	|		ПО _ДемоРеестрДокументов.Ссылка = _ДемоРеализацияТоваров.Ссылка
	|ГДЕ
	|	_ДемоРеализацияТоваров.Ссылка В(&СписокДокументов)";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);

	Шапка = Запрос.Выполнить().Выбрать();

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "РеализацияТоваров";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ДемоРеализацияТоваров.ПФ_MXL_РеализацияТоваров");

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ДанныеПечати = Новый Структура;
		
		Значения = Новый Структура("Номер, Дата",ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина),Формат(Шапка.Дата,"ДЛФ=DD"));
		ТекстЗаголовка = НСтр("ru = 'Демо: Реализация товаров № [Номер] от [Дата]'");
		
		ДанныеПечати.Вставить("ТекстЗаголовка", СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(ТекстЗаголовка,Значения));
		ДанныеПечати.Вставить("ПредставлениеПоставщика", Шапка.Организация);
		ДанныеПечати.Вставить("ПредставлениеПолучателя", Шапка.Контрагент);
		ДанныеПечати.Вставить("ПредставлениеПолучателя", Шапка.Контрагент);
		ДанныеПечати.Вставить("Всего", Шапка.СуммаВсего);
		ДанныеПечати.Вставить("СуммаПрописью", РаботаСКурсамиВалют.СформироватьСуммуПрописью(Шапка.СуммаВсего, Шапка.Валюта));
		ДанныеПечати.Вставить("НДС", ?(ЗначениеЗаполнено(Шапка.СтавкаНДС),Шапка.СтавкаНДС,НСтр("ru = 'Без налога (НДС)'")));

		ТаблицаТовары = Шапка.Товары.Выгрузить();

		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("Поставщик");
		МассивОбластейМакета.Добавить("Покупатель");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("СтрокаТаблицы");
		МассивОбластейМакета.Добавить("ПодвалТаблицы");
		МассивОбластейМакета.Добавить("ПодвалНДС");
		МассивОбластейМакета.Добавить("СуммаПрописью");
		МассивОбластейМакета.Добавить("Подписи");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "СтрокаТаблицы" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;

		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);

	КонецЦикла;

	Возврат ТабличныйДокумент;

КонецФункции

Функция СформироватьПечатнуюФормуРасходнаяНакладная(МассивОбъектов, ОбъектыПечати)

	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	_ДемоРеализацияТоваров.Ссылка КАК Ссылка,
	|	_ДемоРеализацияТоваров.Номер КАК Номер,
	|	_ДемоРеализацияТоваров.Дата КАК Дата,
	|	_ДемоРеализацияТоваров.ГоловнаяОрганизация КАК Организация,
	|	_ДемоРеализацияТоваров.Контрагент КАК Контрагент,
	|	_ДемоРеализацияТоваров.Товары.(
	|		Ссылка КАК Ссылка,
	|		НомерСтроки КАК НомерСтроки,
	|		Номенклатура КАК Товар,
	|		Количество КАК Количество,
	|		Цена КАК Цена,
	|		ВЫБОР
	|			КОГДА _ДемоРеализацияТоваров.Товары.Количество > 0
	|				ТОГДА ""шт""
	|		КОНЕЦ КАК ПредставлениеБазовойЕдиницыИзмерения
	|	) КАК Товары,
	|	_ДемоРеализацияТоваров.МестоХранения КАК МестоХранения
	|ИЗ
	|	РегистрСведений._ДемоРеестрДокументов КАК _ДемоРеестрДокументов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ._ДемоРеализацияТоваров КАК _ДемоРеализацияТоваров
	|		ПО _ДемоРеестрДокументов.Ссылка = _ДемоРеализацияТоваров.Ссылка
	|ГДЕ
	|	_ДемоРеализацияТоваров.Ссылка В(&СписокДокументов)";

	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("СписокДокументов", МассивОбъектов);

	Шапка = Запрос.Выполнить().Выбрать();

	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "РасходнаяНакладная";

	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ._ДемоРеализацияТоваров.ПФ_MXL_РасходнаяНакладная");

	СчетСтрок = 1;

	Пока Шапка.Следующий() Цикл
		Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;

		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;

		ДанныеПечати = Новый Структура;
		
		ТекстЗаголовка = НСтр("ru = 'Демо: Расходная накладная'");
		ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
		
		Значения = Новый Структура("Номер, Дата",ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(Шапка.Номер, Истина, Истина),Формат(Шапка.Дата,"ДЛФ=DD"));
		Текст = НСтр("ru = 'Демо: Расходная накладная № [Номер] от [Дата]'");

		ДанныеПечати.Вставить("ПредставлениеРаспоряжения", СтроковыеФункцииКлиентСервер.ВставитьПараметрыВСтроку(Текст,Значения));
		ДанныеПечати.Вставить("ПредставлениеСклада", Шапка.МестоХранения);
		ДанныеПечати.Вставить("ПредставлениеОрганизации", Шапка.Организация);
		ДанныеПечати.Вставить("ПредставлениеПартнера", Шапка.Контрагент);

		ТаблицаТовары = Шапка.Товары.Выгрузить();

		МассивОбластейМакета = Новый Массив;
		МассивОбластейМакета.Добавить("Заголовок");
		МассивОбластейМакета.Добавить("Шапка");
		МассивОбластейМакета.Добавить("Поставщик");
		МассивОбластейМакета.Добавить("Покупатель");
		МассивОбластейМакета.Добавить("ШапкаТаблицы");
		МассивОбластейМакета.Добавить("СтрокаТаблицы");
		МассивОбластейМакета.Добавить("ПодвалТаблицы");

		Для Каждого ИмяОбласти Из МассивОбластейМакета Цикл
			ОбластьМакета = Макет.ПолучитьОбласть(ИмяОбласти);
			Если ИмяОбласти <> "СтрокаТаблицы" Тогда
				ЗаполнитьЗначенияСвойств(ОбластьМакета.Параметры, ДанныеПечати);
				ТабличныйДокумент.Вывести(ОбластьМакета);
			Иначе
				Для Каждого СтрокаТаблицы Из ТаблицаТовары Цикл
					ОбластьМакета.Параметры.Заполнить(СтрокаТаблицы);
					ТабличныйДокумент.Вывести(ОбластьМакета);
					СчетСтрок = СчетСтрок+1;
				КонецЦикла;
			КонецЕсли;

		КонецЦикла;
		
	Область = Макет.ПолучитьОбласть("Подписи");
	ТекстИтоговойСтроки = НСтр("ru = 'Всего наименований %ВсегоНаименований%'");
	ТекстИтоговойСтроки = СтрЗаменить(ТекстИтоговойСтроки,"%ВсегоНаименований%", СчетСтрок-1);
	СтруктураДанныхИтоговаяСтрока = Новый Структура;
	СтруктураДанныхИтоговаяСтрока.Вставить("ИтоговаяСтрока", ТекстИтоговойСтроки);
	Область.Параметры.Заполнить(СтруктураДанныхИтоговаяСтрока);
	ТабличныйДокумент.Вывести(Область);
	
	УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, Шапка.Ссылка);
	
	КонецЦикла;
	
	Возврат ТабличныйДокумент;

КонецФункции

Процедура ЗаполнитьКлючиАналитики(Документ)
	
	НачатьТранзакцию();
	Попытка
		
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Документ._ДемоРеализацияТоваров");
		ЭлементБлокировки.УстановитьЗначение("Ссылка", Документ.Ссылка);
		Блокировка.Заблокировать();
		
		ДокументОбъект = Документ.Ссылка.ПолучитьОбъект();
		
		// Если объект ранее был удален или обработан другими сеансами, пропускаем его.
		Если ДокументОбъект = Неопределено Тогда
			ОбновлениеИнформационнойБазы.ОтметитьВыполнениеОбработки(Документ.Ссылка);
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		Для каждого СтрокаТовары Из ДокументОбъект.Товары Цикл
		
			Если Не ЗначениеЗаполнено(СтрокаТовары.КлючАналитики) Тогда
				
				ПараметрыКлюча = Новый Структура();
				ПараметрыКлюча.Вставить("Номенклатура", СтрокаТовары.Номенклатура);
				ПараметрыКлюча.Вставить("МестоХранения", ДокументОбъект.МестоХранения);
				СтрокаТовары.КлючАналитики = Справочники._ДемоКлючиАналитикиНоменклатуры.СоздатьКлюч(ПараметрыКлюча);	
			
			КонецЕсли;
		
		КонецЦикла;
		// Запись обработанного объекта.
		ОбновлениеИнформационнойБазы.ЗаписатьДанные(ДокументОбъект);
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

#КонецОбласти

#КонецЕсли