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
	
	УстановитьУсловноеОформление();
	
	Если Параметры.ТолькоПростыеРоли Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокРоли, "ИспользуетсяБезОбъектовАдресации", Истина,,Истина);
	КонецЕсли;	
	Если Параметры.БезВнешнихРолей = Истина Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			СписокРоли, "ВнешняяРоль", Ложь);
	КонецЕсли;	
	
	Если ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.Пользователи") Тогда
		
		ТекущийЭлемент = Элементы.СписокПользователи;
		Элементы.СписокПользователи.ТекущаяСтрока = Параметры.Исполнитель;
		
	ИначеЕсли ТипЗнч(Параметры.Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
		
		Элементы.Страницы.ТекущаяСтраница = Элементы.Роли;
		ТекущийЭлемент = Элементы.СписокРоли;
		Элементы.СписокРоли.ТекущаяСтрока = Параметры.Исполнитель;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("ОбщаяФорма.ВыборРолиИсполнителя") Тогда
		Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
			ОповеститьОВыборе(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокРоли

&НаКлиенте
Процедура СписокПользователиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОповеститьОВыборе(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокРолиВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборРоли(Элемент.ТекущиеДанные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Пользователи Тогда 
		ОповеститьОВыборе(Элементы.СписокПользователи.ТекущаяСтрока);
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Роли Тогда 
		ВыборРоли(Элементы.СписокРоли.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыборРоли(ТекущиеДанные)
	
	Если ТекущиеДанные.ИспользуетсяСОбъектамиАдресации Тогда 
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РольИсполнителя",               ТекущиеДанные.Ссылка);
		ПараметрыФормы.Вставить("ОсновнойОбъектАдресации",       Неопределено);
		ПараметрыФормы.Вставить("ДополнительныйОбъектАдресации", Неопределено);
		ПараметрыФормы.Вставить("ВыборОбъектаАдресации",         Истина);
		ОткрытьФорму("ОбщаяФорма.ВыборРолиИсполнителя", ПараметрыФормы, ЭтотОбъект);
	Иначе
		ВыбранноеЗначение = Новый Структура("РольИсполнителя, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации", ТекущиеДанные.Ссылка, Неопределено, Неопределено);
		ОповеститьОВыборе(ВыбранноеЗначение);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	СписокРоли.УсловноеОформление.Элементы.Очистить();
	Элемент = СписокРоли.УсловноеОформление.Элементы.Добавить();
	
	ГруппаЭлементовОтбора = Элемент.Отбор.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаЭлементовОтбора .ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ЕстьИсполнители");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	ОтборЭлемента = ГруппаЭлементовОтбора.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ВнешняяРоль");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Ложь;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.РольБезИсполнителей);
	
КонецПроцедуры


#КонецОбласти
