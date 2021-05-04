﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет список текущих дел пользователя.
//
// Параметры:
//  Параметры       - Структура - пустая структура.
//  АдресРезультата - Строка    - адрес временного хранилища, куда будет помещен
//                                список текущих дел пользователя - ТаблицаЗначений:
//    * Идентификатор - Строка - внутренний идентификатор дела, используемый механизмом "Текущие дела".
//    * ЕстьДела      - Булево - если Истина, дело выводится в списке текущих дел пользователя.
//    * Важное        - Булево - если Истина, дело будет выделено красным цветом.
//    * Представление - Строка - представление дела, выводимое пользователю.
//    * Количество    - Число  - количественный показатель дела, выводится в строке заголовка дела.
//    * Форма         - Строка - полный путь к форме, которую необходимо открыть при нажатии на гиперссылку
//                               дела на панели "Текущие дела".
//    * ПараметрыФормы- Структура - параметры, с которыми нужно открывать форму показателя.
//    * Владелец      - Строка
//                    - ОбъектМетаданных - строковый идентификатор дела, которое будет владельцем для текущего
//                      или объект метаданных подсистема.
//    * Подсказка     - Строка - текст подсказки.
//
Процедура СформироватьСписокТекущихДелПользователя(Параметры, АдресРезультата) Экспорт
	
	ТекущиеДела = ТекущиеДелаСервер.ТекущиеДела();
	НастройкиОтображения = СохраненныеНастройкиОтображения();
	
	КоличествоДел = 0;
	ДобавитьДело(ТекущиеДела, ИнтеграцияПодсистемБСП, КоличествоДел);
	
	// Добавление дел от прикладных конфигураций.
	ОбработчикиЗаполненияДел = Новый Массив;
	ИнтеграцияПодсистемБСП.ПриОпределенииОбработчиковТекущихДел(ОбработчикиЗаполненияДел);
	ТекущиеДелаПереопределяемый.ПриОпределенииОбработчиковТекущихДел(ОбработчикиЗаполненияДел);
	
	Для Каждого Обработчик Из ОбработчикиЗаполненияДел Цикл
		Если ПолучатьДелаПоОбъекту(Обработчик, НастройкиОтображения) Тогда
			ДобавитьДело(ТекущиеДела, Обработчик, КоличествоДел);
		КонецЕсли;
	КонецЦикла;
	
	// Постобработка результата.
	ПреобразоватьТаблицуТекущихДел(ТекущиеДела, НастройкиОтображения);
	
	Если НастройкиОтображения <> Неопределено Тогда
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить("ТекущиеДела", "НастройкиОтображения", НастройкиОтображения);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ТекущиеДела, АдресРезультата);
	
КонецПроцедуры

// Возвращает структуру сохраненных настроек отображения дел
// для текущего пользователя.
// 
// Возвращаемое значение:
//  Структура:
//     * ВидимостьДел - Соответствие
//     * ВидимостьРазделов - Соответствие
//     * ДеревоДел - ДеревоЗначений:
//          ** Представление - Строка
//          ** ЭтоРаздел - Булево
//          ** Пометка - Булево
//          ** Идентификатор - Строка
//          ** Индекс - Число
//          ** РасшифровкаДела - Строка
//          ** Скрытое - Булево
//          ** ВыводитьВОповещениях -Булево
//
Функция СохраненныеНастройкиОтображения() Экспорт
	
	НастройкиОтображения = ХранилищеОбщихНастроек.Загрузить("ТекущиеДела", "НастройкиОтображения");
	Если НастройкиОтображения = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ТипЗнч(НастройкиОтображения) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если НастройкиОтображения.Свойство("ДеревоДел")
		И НастройкиОтображения.Свойство("ВидимостьРазделов")
		И НастройкиОтображения.Свойство("ВидимостьДел") Тогда
		Возврат НастройкиОтображения;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ПользователиПереопределяемый.ПриОпределенииНазначенияРолей
Процедура ПриОпределенииНазначенияРолей(НазначениеРолей) Экспорт
	
	// СовместноДляПользователейИВнешнихПользователей.
	НазначениеРолей.СовместноДляПользователейИВнешнихПользователей.Добавить(
		Метаданные.Роли.ИспользованиеОбработкиТекущиеДела.Имя);
	
КонецПроцедуры

// См. ОбщегоНазначенияПереопределяемый.ПриДобавленииПереименованийОбъектовМетаданных.
Процедура ПриДобавленииПереименованийОбъектовМетаданных(Итог) Экспорт
	
	Библиотека = "СтандартныеПодсистемы";
	
	СтароеИмя = "Роль.ИспользованиеТекущихДел";
	НовоеИмя  = "Роль.ИспользованиеОбработкиТекущиеДела";
	ОбщегоНазначения.ДобавитьПереименование(Итог, "2.3.3.25", СтароеИмя, НовоеИмя, Библиотека);
	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ЧисловыеПоказателиТекущихДел(Запрос, ОбщиеПараметрыЗапросов = Неопределено) Экспорт
	
	// Установим общие параметры для всех запросов.
	// Специфические параметры этого запроса, если таковые имеются, должны быть установлены ранее.
	Если Не ОбщиеПараметрыЗапросов = Неопределено Тогда
		УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	КонецЕсли;
	
	Результат = Запрос.ВыполнитьПакет(); // Массив из РезультатЗапроса 
	НомераЗапросовПакета = Новый Массив;
	НомераЗапросовПакета.Добавить(Результат.Количество() - 1);
	
	// Выберем все запросы с данными.
	РезультатЗапроса = Новый Структура;
	Для Каждого НомерЗапроса Из НомераЗапросовПакета Цикл
		
		ЗапросИзПакета = Результат.Получить(НомерЗапроса);
		Выборка = ЗапросИзПакета.Выбрать();
		
		Если Выборка.Следующий() Тогда
			
			Для Каждого Колонка Из ЗапросИзПакета.Колонки Цикл
				ЗначениеДела = ?(ТипЗнч(Выборка[Колонка.Имя]) = Тип("Null"), 0, Выборка[Колонка.Имя]);
				РезультатЗапроса.Вставить(Колонка.Имя, ЗначениеДела);
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Возвращает структуру общих значений, используемых для расчета текущих дел.
//
// Возвращаемое значение:
//  Структура - имя значение и само значение.
//
Функция ОбщиеПараметрыЗапросов() Экспорт
	
	ОбщиеПараметрыЗапросов = Новый Структура;
	ОбщиеПараметрыЗапросов.Вставить("Пользователь", Пользователи.ТекущийПользователь());
	ОбщиеПараметрыЗапросов.Вставить("ЭтоПолноправныйПользователь", Пользователи.ЭтоПолноправныйПользователь());
	ОбщиеПараметрыЗапросов.Вставить("ТекущаяДата", ТекущаяДатаСеанса());
	ОбщиеПараметрыЗапросов.Вставить("ПустаяДата", '00010101000000');
	
	Возврат ОбщиеПараметрыЗапросов;
	
КонецФункции

// Устанавливает общие параметры запросов для расчета текущих дел.
//
// Параметры:
//  Запрос - выполняемый запрос.
//  ОбщиеПараметрыЗапросов - Структура - общие значения для расчета показателей.
//
Процедура УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов) Экспорт
	
	Для Каждого КлючИЗначение Из ОбщиеПараметрыЗапросов Цикл
		Запрос.УстановитьПараметр(КлючИЗначение.Ключ, КлючИЗначение.Значение);
	КонецЦикла;
	
	ИнтеграцияПодсистемБСП.ПриУстановкеОбщихПараметровЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	ТекущиеДелаПереопределяемый.УстановитьОбщиеПараметрыЗапросов(Запрос, ОбщиеПараметрыЗапросов);
	
КонецПроцедуры

// Только для внутреннего использования.
//
// Параметры:
//   ТекущиеДела - ТаблицаЗначений
//
Процедура УстановитьНачальныйПорядокРазделов(ТекущиеДела) Экспорт
	
	ПорядокРазделовКомандногоИнтерфейса = Новый Массив;
	ИнтеграцияПодсистемБСП.ПриОпределенииПорядкаРазделовКомандногоИнтерфейса(ПорядокРазделовКомандногоИнтерфейса);
	ТекущиеДелаПереопределяемый.ПриОпределенииПорядкаРазделовКомандногоИнтерфейса(ПорядокРазделовКомандногоИнтерфейса);
	
	Индекс = 0;
	Для Каждого РазделКомандногоИнтерфейса Из ПорядокРазделовКомандногоИнтерфейса Цикл
		Если ТипЗнч(РазделКомандногоИнтерфейса) = Тип("Строка") Тогда
			РазделКомандногоИнтерфейса = СтрЗаменить(РазделКомандногоИнтерфейса, " ", "");
		Иначе
			РазделКомандногоИнтерфейса = СтрЗаменить(РазделКомандногоИнтерфейса.ПолноеИмя(), ".", "");
		КонецЕсли;
		ОтборСтрок = Новый Структура;
		ОтборСтрок.Вставить("ИдентификаторВладельца", РазделКомандногоИнтерфейса);
		
		НайденныеСтроки = ТекущиеДела.НайтиСтроки(ОтборСтрок);
		Для Каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			ИндексСтрокиВТаблице = ТекущиеДела.Индекс(НайденнаяСтрока);
			Если ИндексСтрокиВТаблице = Индекс Тогда
				Индекс = Индекс + 1;
				Продолжить;
			КонецЕсли;
			
			ТекущиеДела.Сдвинуть(ИндексСтрокиВТаблице, (Индекс - ИндексСтрокиВТаблице));
			Индекс = Индекс + 1;
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
//
Процедура ПреобразоватьТаблицуТекущихДел(ТекущиеДела, НастройкиОтображения)
	
	ТекущиеДела.Колонки.Добавить("ИдентификаторВладельца", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	ТекущиеДела.Колонки.Добавить("ЭтоРаздел", Новый ОписаниеТипов("Булево"));
	ТекущиеДела.Колонки.Добавить("ПредставлениеРаздела", Новый ОписаниеТипов("Строка", Новый КвалификаторыСтроки(250)));
	
	Если ТипЗнч(НастройкиОтображения) = Тип("Структура")
		И НастройкиОтображения.Свойство("ОтключенныеОбъекты")
		И ТипЗнч(НастройкиОтображения.ОтключенныеОбъекты) = Тип("Соответствие") Тогда
		ОтключенныеОбъекты = НастройкиОтображения.ОтключенныеОбъекты;
	Иначе
		ОтключенныеОбъекты = Новый Соответствие;
	КонецЕсли;
	
	НедопустимыеСимволы = """'`/\-[]{}:;|=?*<>,.()+#№@!%^&~";
	УдаляемыеДела = Новый Массив;
	Для Каждого Дело Из ТекущиеДела Цикл
		
		Если ТипЗнч(Дело.Владелец) = Тип("ОбъектМетаданных") Тогда
			РазделДоступен = ОбщегоНазначения.ОбъектМетаданныхДоступенПоФункциональнымОпциям(Дело.Владелец);
			Если Не РазделДоступен Тогда
				УдаляемыеДела.Добавить(Дело);
				Продолжить;
			КонецЕсли;
			
			Дело.ИдентификаторВладельца = СтрЗаменить(Дело.Владелец.ПолноеИмя(), ".", "");
			Дело.ЭтоРаздел              = Истина;
			Дело.ПредставлениеРаздела   = ?(ЗначениеЗаполнено(Дело.Владелец.Синоним), Дело.Владелец.Синоним, Дело.Владелец.Имя);
		Иначе
			Если ТипЗнч(Дело.Владелец) = Тип("ОбработкаМенеджер.ТекущиеДела") Тогда
				Дело.Владелец = Дело.Владелец.ПолноеИмя();
				Дело.Идентификатор = СтрЗаменить(Дело.Идентификатор, " ", "");
				Дело.Идентификатор = СтрСоединить(СтрРазделить(Дело.Идентификатор, НедопустимыеСимволы, Истина));
			КонецЕсли;
			
			ЭтоИдентификаторДела = (ТекущиеДела.Найти(Дело.Владелец, "Идентификатор") <> Неопределено);
			Если Не ЭтоИдентификаторДела Тогда
				ЭтоИдентификаторДела = (ТекущиеДела.Найти(СтрЗаменить(Дело.Владелец, " ", ""), "Идентификатор") <> Неопределено);
			КонецЕсли;
			
			Дело.ИдентификаторВладельца = СтрЗаменить(Дело.Владелец, " ", "");
			Дело.ИдентификаторВладельца = СтрСоединить(СтрРазделить(Дело.ИдентификаторВладельца, НедопустимыеСимволы, Истина));
			Если Не ЭтоИдентификаторДела Тогда
				Дело.ЭтоРаздел              = Истина;
				Дело.ПредставлениеРаздела   = Дело.Владелец;
			КонецЕсли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Дело.ОбъектВладелецДел)
			И Дело.ЭтоРаздел
			И ТипЗнч(НастройкиОтображения) = Тип("Структура")
			И НастройкиОтображения.Свойство("ВидимостьДел") Тогда
			Если ОтключенныеОбъекты[Дело.ОбъектВладелецДел] = Неопределено Тогда
				ОтключенныеОбъекты.Вставить(Дело.ОбъектВладелецДел, Новый Массив);
				ОтключенныеОбъекты[Дело.ОбъектВладелецДел].Добавить(Дело.Идентификатор);
			Иначе
				ОтключенныеОбъекты[Дело.ОбъектВладелецДел].Добавить(Дело.Идентификатор);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ОтключенныеОбъекты.Количество() > 0 Тогда
		НастройкиОтображения.Вставить("ОтключенныеОбъекты", ОтключенныеОбъекты);
	КонецЕсли;
	
	Для Каждого УдаляемоеДело Из УдаляемыеДела Цикл
		ТекущиеДела.Удалить(УдаляемоеДело);
	КонецЦикла;
	
	ТекущиеДела.Колонки.Удалить("Владелец");
	
КонецПроцедуры

Процедура ДобавитьДело(ТекущиеДела, Менеджер, КоличествоДел)
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности") Тогда
		МодульОценкаПроизводительности = ОбщегоНазначения.ОбщийМодуль("ОценкаПроизводительности");
		НачалоЗамера = МодульОценкаПроизводительности.НачатьЗамерВремени();
	КонецЕсли;
	
	КоличествоДел = ТекущиеДела.Количество();
	Менеджер.ПриЗаполненииСпискаТекущихДел(ТекущиеДела);
	НовоеКоличествоДел = ТекущиеДела.Количество();
	
	Если КоличествоДел <> НовоеКоличествоДел
		И ТипЗнч(Менеджер) <> Тип("ОбщийМодуль") Тогда
		ОбъектВладелецДел = Метаданные.НайтиПоТипу(ТипЗнч(Менеджер)).ПолноеИмя();
		Для Индекс = КоличествоДел По НовоеКоличествоДел - 1 Цикл
			Строка = ТекущиеДела.Получить(Индекс);
			Строка.ОбъектВладелецДел = ОбъектВладелецДел;
		КонецЦикла;
	КонецЕсли;
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ОценкаПроизводительности")
		И ТекущиеДела.Количество() <> КоличествоДел Тогда
		КоличествоДел = ТекущиеДела.Количество();
		ПоследнееДело = ТекущиеДела.Получить(КоличествоДел - 1);
		Владелец = ПоследнееДело.Владелец;
		Если ТипЗнч(Владелец) = Тип("ОбъектМетаданных") Тогда
			ПредставлениеДела = ПоследнееДело.Представление;
		Иначе
			ОписаниеВладельца = ТекущиеДела.Найти(ПоследнееДело.Владелец, "Идентификатор");
			Если ОписаниеВладельца = Неопределено Тогда
				ПредставлениеДела = ПоследнееДело.Представление;
			Иначе
				ПредставлениеДела = ОписаниеВладельца.Представление;
			КонецЕсли;
		КонецЕсли;
		
		КлючеваяОперация = "ОбновлениеТекущихДел." + ПредставлениеДела;
		МодульОценкаПроизводительности.ЗакончитьЗамерВремени(КлючеваяОперация, НачалоЗамера);
	КонецЕсли;
КонецПроцедуры

Функция ПолучатьДелаПоОбъекту(Обработчик, НастройкиОтображения)
	Если ТипЗнч(Обработчик) <> Тип("ОбщийМодуль")
		И НастройкиОтображения <> Неопределено
		И ТипЗнч(НастройкиОтображения) = Тип("Структура")
		И НастройкиОтображения.Свойство("ОтключенныеОбъекты")
		И ТипЗнч(НастройкиОтображения.ОтключенныеОбъекты) = Тип("Соответствие") Тогда
		ОбъектВладелецДел = Метаданные.НайтиПоТипу(ТипЗнч(Обработчик)).ПолноеИмя();
		ПроверяемыеДела = НастройкиОтображения.ОтключенныеОбъекты[ОбъектВладелецДел];
		Если ТипЗнч(ПроверяемыеДела) = Тип("Массив") Тогда
			ПолучатьДела    = Ложь;
			Для Каждого ПроверяемоеДело Из ПроверяемыеДела Цикл
				Значение = НастройкиОтображения.ВидимостьДел[ПроверяемоеДело];
				Если Значение <> Ложь Тогда
					ПолучатьДела = Истина;
				КонецЕсли;
			КонецЦикла;
			Если Не ПолучатьДела Тогда
				Возврат Ложь;
			Иначе
				НастройкиОтображения.ОтключенныеОбъекты.Удалить(ОбъектВладелецДел);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

#КонецОбласти
