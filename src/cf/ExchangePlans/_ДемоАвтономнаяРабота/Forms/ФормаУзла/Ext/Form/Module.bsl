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
	
	РежимСинхронизацииДанных =
		?(Объект.ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьВсеДанные");
	
	Организации.Загрузить(ВсеОрганизацииПриложения());
	
	Для Каждого СтрокаТаблицы Из Объект.Организации Цикл
		
		Организации.НайтиСтроки(Новый Структура("Организация", СтрокаТаблицы.Организация))[0].Использовать = Истина;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииДанныхПриИзмененииЗначения();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	ТекущийОбъект.ИспользоватьОтборПоОрганизациям =
		(РежимСинхронизацииДанных = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	Если ТекущийОбъект.ИспользоватьОтборПоОрганизациям Тогда
		
		ТекущийОбъект.Организации.Загрузить(Организации.Выгрузить(Новый Структура("Использовать", Истина), "Организация"));
		
	Иначе
		
		ТекущийОбъект.Организации.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("Запись_АвтономноеРабочееМесто");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД ФОРМЫ

&НаКлиенте
Процедура РежимСинхронизацииДанныхПриИзменении(Элемент)
	
	РежимСинхронизацииДанныхПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "Организации");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "Организации");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура РежимСинхронизацииДанныхПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииДанных = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВсеОрганизацииПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник._ДемоОрганизации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти
