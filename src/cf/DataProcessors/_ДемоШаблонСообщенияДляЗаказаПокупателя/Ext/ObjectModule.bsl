﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает сведения о внешней обработке.
Функция СведенияОВнешнейОбработке() Экспорт
	
	ПараметрыРегистрации = Новый Структура;
	
	ПараметрыРегистрации.Вставить("Вид", "ШаблонСообщения");
	ПараметрыРегистрации.Вставить("Версия", "2.3.3.50");
	ПараметрыРегистрации.Вставить("Назначение", Новый Массив);
	ПараметрыРегистрации.Вставить("Наименование", НСтр("ru = 'Демо: Шаблон сообщения по изменившемуся статусу документа ""Демо: Заказ покупателя""'"));
	ПараметрыРегистрации.Вставить("БезопасныйРежим", Истина);
	ПараметрыРегистрации.Вставить("Информация", НСтр("ru = 'Данная обработка загружает шаблон сообщения по изменившемуся статусу документа ""Демо: Заказ покупателя"". Для доступа к шаблонам сообщений откройте раздел ""Интегрируемые подсистемы (часть 2)"" и перейдите к списку ""Шаблоны сообщений"".'"));
	ПараметрыРегистрации.Вставить("ВерсияБСП", "2.1.2.1");
	
	ПараметрыРегистрации.Вставить("Команды", Новый ТаблицаЗначений);
	
	Возврат ПараметрыРегистрации;
	
КонецФункции

// Возвращает параметры шаблона
Функция ПараметрыШаблона() Экспорт
	
	ПараметрыШаблона = ШаблоныСообщений.ТаблицаПараметров();
	
	ШаблоныСообщенийКлиентСервер.ДобавитьПараметрШаблона(
	                        ПараметрыШаблона, 
	                        НСтр("ru = 'СтроковыйПараметр'"),
	                        Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(50, ДопустимаяДлина.Переменная)),
	                        Ложь,
	                        НСтр("ru='Дополнительная информация'"));
	
	ШаблоныСообщенийКлиентСервер.ДобавитьПараметрШаблона(
	                        ПараметрыШаблона, 
	                        НСтр("ru = 'Демо: Заказ покупателя'"),
	                        Новый ОписаниеТипов("ДокументСсылка._ДемоЗаказПокупателя"),
	                        Ложь,
	                        НСтр("ru='Укажите заказ клиента'"));
	
	Возврат ПараметрыШаблона;
	
КонецФункции

// Возвращает структуру данных для отображения в шаблоне сообщения
//
// Возвращаемое значение:
//  Структура:
//   * Наименование - Строка
//   * ПараметрыШаблона - см. ПараметрыШаблона
//   * ПолноеИмяТипаПараметраВводаНаОсновании - Строка
//   * ПредназначенДляВводаНаОсновании - Булево
//   * ТипТекстаПисьма - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем
//   * ТекстШаблонаПисьмаHTML - Строка
//   * ТемаПисьма - Строка
//   * ОбщийШаблон - Булево
//   * ПредназначенДляSMS - Булево
//   * ТекстШаблонаSMS - Строка
//   * ПредназначенДляЭлектронныхПисем - Булево
//
Функция СтруктураДанныхДляОтображенияВШаблоне() Экспорт
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("Наименование", НСтр("ru = 'Оповещение при изменившемся статусе заказа'"));
	СтруктураДанных.Вставить("ПараметрыШаблона", ПараметрыШаблона());
	СтруктураДанных.Вставить("ПредназначенДляЭлектронныхПисем", Истина);
	СтруктураДанных.Вставить("ТекстШаблонаSMS", "");
	СтруктураДанных.Вставить("ПредназначенДляSMS", Ложь);
	СтруктураДанных.Вставить("ОбщийШаблон", Ложь);
	СтруктураДанных.Вставить("ТемаПисьма", ТемаПисьмаДляШаблона());
	СтруктураДанных.Вставить("ТекстШаблонаПисьмаHTML", ТекстПисьмаHTMLДляШаблона());
	СтруктураДанных.Вставить("ТипТекстаПисьма", Перечисления.СпособыРедактированияЭлектронныхПисем.HTML);
	СтруктураДанных.Вставить("ПредназначенДляВводаНаОсновании", Истина);
	СтруктураДанных.Вставить("ПолноеИмяТипаПараметраВводаНаОсновании","Документ._ДемоЗаказПокупателя");
	
	Возврат СтруктураДанных;
	
КонецФункции

// Возвращает структуру данных для инициализации обработки "Сообщение по шаблону"
//
// Параметры:
//  ДляПисьма - Булево - если Истина, то шаблон используется для создания электронного письма.
//
// Возвращаемое значение:
//  Структура:
//   * ПараметрыШаблона - см. ПараметрыШаблона
//   * ТипТекстаПисьма - ПеречислениеСсылка.СпособыРедактированияЭлектронныхПисем
//   * ПредназначенДляSMS - Булево
//   * ПредназначенДляЭлектронныхПисем - Булево
//
Функция СтруктураДанныхДляСообщенияПоШаблону(ДляПисьма) Экспорт
	
	СтруктураДанных = Новый Структура;
	
	СтруктураДанных.Вставить("ПараметрыШаблона",  ПараметрыШаблона());
	СтруктураДанных.Вставить("ТипТекстаПисьма",   Перечисления.СпособыРедактированияЭлектронныхПисем.HTML);
	СтруктураДанных.Вставить("ПредназначенДляЭлектронныхПисем", ДляПисьма);
	СтруктураДанных.Вставить("ПредназначенДляSMS", Не ДляПисьма);
	
	Возврат СтруктураДанных;
	
КонецФункции

// Формирует сообщение по шаблону
Функция СформироватьСообщениеПоШаблону(СтруктураПараметровШаблона) Экспорт
	
	СтруктураСообщения = ШаблоныСообщенийКлиентСервер.ИнициализироватьСтруктуруСообщения();
	
	Сообщение = ТекстИТемаПисьмаHTMLДляОтправки(СтруктураПараметровШаблона);
	СтруктураСообщения.ТекстПисьмаHTML   = Сообщение.ТекстПисьмаНТМL;
	СтруктураСообщения.ТемаПисьма        = Сообщение.ТемаПисьма;
	СтруктураСообщения.СтруктураВложений = Сообщение.СтруктураВложений;
	
	Возврат СтруктураСообщения;
	
КонецФункции

// Формирует данные возможных получателей письма
Функция СтруктураДанныхПолучатели(СтруктураПараметровШаблона, СтандартнаяОбработка) Экспорт
	
	Результат = Новый Массив;
	СтандартнаяОбработка = Ложь;
	Если СтруктураПараметровШаблона.Свойство("_ДемоЗаказПокупателя") И НЕ СтруктураПараметровШаблона._ДемоЗаказПокупателя.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.КонтактноеЛицо
		|ИЗ
		|	Документ._ДемоЗаказПокупателя.ПартнерыИКонтактныеЛица КАК _ДемоЗаказПокупателяПартнерыИКонтактныеЛица
		|ГДЕ
		|	_ДемоЗаказПокупателяПартнерыИКонтактныеЛица.Ссылка = &ЗаказПокупателя";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", СтруктураПараметровШаблона._ДемоЗаказПокупателя);
		РезультатЗапроса = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("КонтактноеЛицо");
		
		Если РезультатЗапроса.Количество() > 0 Тогда
			Получатели = УправлениеКонтактнойИнформацией.КонтактнаяИнформацияОбъектов(РезультатЗапроса, Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты,, ТекущаяДатаСеанса());
			
			Для каждого Получатель Из Получатели Цикл
				НовыйПолучатель = СтруктураПолучатель();
				НовыйПолучатель.Адрес = Получатель.Представление;
				НовыйПолучатель.Представление = Строка(Получатель.Объект) + " <" + Получатель.Представление + ">";
				НовыйПолучатель.ИсточникКонтактнойИнформации = Получатель.Объект;
				Результат.Добавить(НовыйПолучатель);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ....
Функция ТекстИТемаПисьмаHTMLДляОтправки(СтруктураПараметровШаблона)
	
	ТекстПисьмаНТМL = ПолучитьМакет("МакетПисьмоHTML").ПолучитьТекст();
	ТемаПисьма      = "";

	Если СтруктураПараметровШаблона.Свойство("_ДемоЗаказПокупателя") И НЕ СтруктураПараметровШаблона._ДемоЗаказПокупателя.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДемоЗаказПокупателя.Номер,
		|	ДемоЗаказПокупателя.Дата,
		|	ДемоЗаказПокупателя.СтатусЗаказа,
		|	ДемоЗаказПокупателя.Контрагент КАК ПредставлениеПартнера
		|ИЗ
		|	Документ._ДемоЗаказПокупателя КАК ДемоЗаказПокупателя
		|ГДЕ
		|	ДемоЗаказПокупателя.Ссылка = &ЗаказПокупателя
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	_ДемоСчетНаОплатуПокупателюТовары.Номенклатура КАК Номенклатура,
		|	_ДемоСчетНаОплатуПокупателюТовары.Характеристика КАК Характеристика,
		|	_ДемоСчетНаОплатуПокупателюТовары.Количество КАК Количество,
		|	_ДемоСчетНаОплатуПокупателюТовары.Цена КАК Цена,
		|	_ДемоСчетНаОплатуПокупателюТовары.Сумма КАК Сумма,
		|	_ДемоСчетНаОплатуПокупателюТовары.Всего КАК Всего,
		|	_ДемоСчетНаОплатуПокупателюТовары.СуммаНДС КАК СуммаНДС
		|ИЗ
		|	Документ._ДемоЗаказПокупателя.СчетаНаОплату КАК _ДемоЗаказПокупателяСчетаНаОплату
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ._ДемоСчетНаОплатуПокупателю.Товары КАК _ДемоСчетНаОплатуПокупателюТовары
		|		ПО (_ДемоЗаказПокупателяСчетаНаОплату.Счет = _ДемоСчетНаОплатуПокупателюТовары.Ссылка)
		|ГДЕ
		|	_ДемоЗаказПокупателяСчетаНаОплату.Ссылка = &ЗаказПокупателя";
		
		Запрос.УстановитьПараметр("ЗаказПокупателя", СтруктураПараметровШаблона._ДемоЗаказПокупателя);
		
		РезультатЗапроса = Запрос.ВыполнитьПакет();
		
		Если Не РезультатЗапроса[0].Пустой() Тогда 
			
			Выборка = РезультатЗапроса[0].Выбрать();
			Выборка.Следующий();
			
			ТекстПисьмаНТМL = СтрЗаменить(ТекстПисьмаНТМL, "[ПредставлениеПартнера]", Выборка.ПредставлениеПартнера);
			
			ПредставлениеЗаказа =  СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='№ %1 от %2'"), Выборка.Номер, Формат(Выборка.Номер , "ДЛФ=DD"));
			ТекстПисьмаНТМL     = СтрЗаменить(ТекстПисьмаНТМL, "[ПредставлениеЗаказа]", ПредставлениеЗаказа);
			ТемаПисьма          = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Изменение статуса по заказу %1'"), ПредставлениеЗаказа);
			
			ТекстПисьмаНТМL = СтрЗаменить(ТекстПисьмаНТМL, "[СтатусЗаказа]", Выборка.СтатусЗаказа);
			ТекстПисьмаНТМL = СтрЗаменить(ТекстПисьмаНТМL, "[ТаблицаНоменклатуры]", СформироватьТаблицуТоваровЗаказа(РезультатЗапроса[1]));
			
			СтруктураВложений = Новый Структура;
			СтруктураВложений.Вставить("Логотип", Новый Картинка(ПолучитьМакет("Логотип")));
			ТекстПисьмаНТМL = СтрЗаменить(ТекстПисьмаНТМL, "[Логотип]", "<img src=""Логотип""></img>");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если СтруктураПараметровШаблона.Свойство("СтроковыйПараметр") И НЕ ПустаяСтрока(СтруктураПараметровШаблона.СтроковыйПараметр) Тогда
		ТекстПисьмаНТМL = СтрЗаменить(ТекстПисьмаНТМL, "[ДополнительнаяИнформация]", СтруктураПараметровШаблона.СтроковыйПараметр);
	КонецЕсли;
	
	Возврат Новый Структура("ТемаПисьма, ТекстПисьмаНТМL, СтруктураВложений", ТемаПисьма, ТекстПисьмаНТМL, СтруктураВложений);
	
КонецФункции



Функция СформироватьТаблицуТоваровЗаказа(РезультатЗапроса)

	ТекстТаблицы = "";
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		ТекстТаблицы =  ТекстТаблицы + "<FONT face=Terminal>|"
		                + СтрЗаменить(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Выборка.Номенклатура, 46, " ", "Справа")," ","&nbsp;") + "|"
		                + СтрЗаменить(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Выборка.Количество, 12, " ", "Слева")," ","&nbsp;") + "|"
		                + СтрЗаменить(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Выборка.Цена, 9, " ", "Слева")," ","&nbsp;") + "|"
		                + СтрЗаменить(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(Выборка.СуммаНДС, 13, " ", "Слева")," ","&nbsp;") + "|"
		                "</FONT><BR>"
		
	КонецЦикла;
	
	Возврат ТекстТаблицы;

КонецФункции

Функция ТемаПисьмаДляШаблона()
	
	Возврат НСтр("ru = 'Изменение статуса по заказу [ПредставлениеЗаказа]'");
	
КонецФункции

Функция ТекстПисьмаHTMLДляШаблона()

	ТекстПисьмаНТМL = ПолучитьМакет("МакетПисьмоHTML").ПолучитьТекст();
	ТекстТаблицы    = "<FONT face=Terminal>" + СтрЗаменить(СтроковыеФункцииКлиентСервер.ДополнитьСтроку(НСтр("ru = '&ТаблицаНоменклатуры'"), 50, " ", "Слева")," ","&nbsp;") + "</FONT><BR>";
	
	Возврат СтрЗаменить(ТекстПисьмаНТМL, "&ТаблицаНоменклатуры", ТекстТаблицы);

КонецФункции

Функция СтруктураПолучатель()
		
	СтруктураПолучатель = Новый Структура;
	СтруктураПолучатель.Вставить("Адрес", "");
	СтруктураПолучатель.Вставить("Представление", "");
	СтруктураПолучатель.Вставить("ИсточникКонтактнойИнформации", "");
	СтруктураПолучатель.Вставить("ВидПочтовогоАдреса", "");
	СтруктураПолучатель.Вставить("Пояснение", "");
	СтруктураПолучатель.Вставить("ОбъектИсточник", "");
	Возврат СтруктураПолучатель;
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли