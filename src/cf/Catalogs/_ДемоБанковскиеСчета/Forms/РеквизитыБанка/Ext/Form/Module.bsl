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
	
	РучноеИзменение = Параметры.РучноеИзменение;
	РеквизитВладельца = Параметры.Реквизит;
	ДеятельностьПрекращена = Ложь;
	
	ЗначенияПолей = Новый Структура;
	Если РучноеИзменение Тогда
		ЗначенияПолей = Параметры.ЗначенияПолей;
	Иначе
		Банк = Параметры.Банк;
		Если ТипЗнч(Банк) = Тип("СправочникСсылка.КлассификаторБанков") И ЗначениеЗаполнено(Банк) Тогда
			ЗначенияПолей = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Банк, "Код,КоррСчет,Наименование,Город,Адрес,Телефоны,Родитель,ДеятельностьПрекращена");
			БИК = ЗначенияПолей.Код;
			Регион = ЗначенияПолей.Родитель;
			ВКлассификаторе = Истина;
			ДеятельностьПрекращена = ЗначенияПолей.ДеятельностьПрекращена;
		КонецЕсли;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ЗначенияПолей);
	
	Элементы.НадписьДеятельностьБанкаПрекращена.Видимость = ДеятельностьПрекращена;
	КлючСохраненияПоложенияОкна = "ДеятельностьБанкаПрекращена=" + Строка(ДеятельностьПрекращена);
	
	ТолькоПросмотр = Не РучноеИзменение И ВКлассификаторе;
	
	Если ОбщегоНазначения.ЭтоМобильныйКлиент() Тогда
		ВыравниваниеЭлементовИЗаголовков = ВариантВыравниванияЭлементовИЗаголовков.ЭлементыПравоЗаголовкиЛево;
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Верх;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, ЗавершениеРаботы);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	Модифицированность = Ложь;
	ОповеститьОВыборе(ПолучитьЗначенияПараметров());
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьЗначенияПараметров()
	
	Результат = Новый Структура;
	Результат.Вставить("Реквизит", РеквизитВладельца);
	
	Если РучноеИзменение Тогда
	    Результат.Вставить("РучноеИзменение", РучноеИзменение);
		ЗначенияПолей = Новый Структура;
		ЗначенияПолей.Вставить("БИК", БИК);
		ЗначенияПолей.Вставить("Наименование", Наименование);
		ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
		ЗначенияПолей.Вставить("Город", Город);
		ЗначенияПолей.Вставить("Адрес", Адрес);
		ЗначенияПолей.Вставить("Телефоны", Телефоны);
		ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
		
		Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
	Иначе
		Если ВКлассификаторе Тогда
			Результат.Вставить("РучноеИзменение", РучноеИзменение);
			Результат.Вставить("Банк", Банк);
		Иначе 
			Результат.Вставить("РучноеИзменение", Истина);
			ЗначенияПолей = Новый Структура;
			ЗначенияПолей.Вставить("БИК", БИК);
			ЗначенияПолей.Вставить("Наименование", Наименование);
			ЗначенияПолей.Вставить("КоррСчет", КоррСчет);
			ЗначенияПолей.Вставить("Город", Город);
			ЗначенияПолей.Вставить("Адрес", Адрес);
			ЗначенияПолей.Вставить("Телефоны", Телефоны);
			ЗначенияПолей.Вставить("РучноеИзменение", РучноеИзменение);
			
			Результат.Вставить("ЗначенияПолей", ЗначенияПолей);
		КонецЕсли;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции

#КонецОбласти
