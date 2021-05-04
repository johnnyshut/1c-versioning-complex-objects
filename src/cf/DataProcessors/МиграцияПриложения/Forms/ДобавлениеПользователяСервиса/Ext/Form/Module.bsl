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
	
	ПараметрыДоступа = Параметры.ПараметрыДоступа;
	
	Роль = МиграцияПриложенийКлиентСервер.РольПользователь();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЭлектроннаяПочтаПриИзменении(Элемент)
	
	Если Не ЛогинРедактировался Тогда
		Логин = ЭлектроннаяПочта;
	КонецЕсли;
		
	Если Не НаименованиеРедактировалось Тогда
		Наименование = ЭлектроннаяПочта;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЭлектроннаяПочтаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЛогинРедактировался Тогда
		Логин = Текст;
	КонецЕсли;
		
	Если Не НаименованиеРедактировалось Тогда
		Наименование = Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогинПриИзменении(Элемент)
	
	ЛогинРедактировался = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	НаименованиеРедактировалось = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	Если СоздатьНаСервере() Тогда
		
		Результат = Новый Структура();
		Результат.Вставить("Логин", Логин);
		Результат.Вставить("Наименование", Наименование);
		Результат.Вставить("ЭлектроннаяПочта", ЭлектроннаяПочта);
		Результат.Вставить("Роль", Роль);
		ОповеститьОЗаписиНового(Результат);
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ЗначениеЗаполнено(ЭлектроннаяПочта) Тогда
		Попытка
			Результат = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ЭлектроннаяПочта);
		Исключение
			ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ЭлектроннаяПочта", , Отказ);
			Возврат;
		КонецПопытки;
		Если Результат.Количество() > 1 Тогда
			ТекстОшибки = НСтр("ru = 'Можно ввести только один e-mail.'");
			ОбщегоНазначения.СообщитьПользователю(ТекстОшибки, , "ЭлектроннаяПочта", , Отказ);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ПараметрыМетода = Новый Структура;
	
	ПараметрыМетода.Вставить("auth", Новый Структура);
	ПараметрыМетода.auth.Вставить("account", ПараметрыДоступа.КодАбонента);
	
	ПараметрыМетода.Вставить("general", Новый Структура);
	ПараметрыМетода.general.Вставить("type", "ext");
	ПараметрыМетода.general.Вставить("method", "account/users/create");
	ПараметрыМетода.general.Вставить("version", 3);

	ПараметрыМетода.Вставить("id", ПараметрыДоступа.КодАбонента);
	ПараметрыМетода.Вставить("login", Логин);
	ПараметрыМетода.Вставить("name", Наименование);
	ПараметрыМетода.Вставить("email", ЭлектроннаяПочта);
	ПараметрыМетода.Вставить("role", МиграцияПриложенийКлиентСервер.ИдентификаторAPIРоли(Роль));
	
	Результат = МиграцияПриложений.ВызватьМетодПрограммногоИнтерфейса(ПараметрыДоступа, ПараметрыМетода);
	
	Если Результат.general.error Тогда
		ВызватьИсключение Результат.general.message;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

#КонецОбласти
