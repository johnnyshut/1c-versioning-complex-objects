﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьЗначениеНастройки(ИмяЭлемента, ЗначениеЭлемента);
	
КонецПроцедуры

Функция ДатаСледующегоАвтоматическогоКопирования(ОтложитьРезервноеКопирование = Ложь) Экспорт
	
	Настройки = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	ТекущаяДата = ТекущаяДатаСеанса();
	
	РасписаниеКопирования = Настройки.РасписаниеКопирования;
	ПериодПовтораВТечениеДня = РасписаниеКопирования.ПериодПовтораВТечениеДня;
	ПериодПовтораДней = РасписаниеКопирования.ПериодПовтораДней;
	
	Если ОтложитьРезервноеКопирование Тогда
		Значение = ТекущаяДата + 60 * 15;
	ИначеЕсли ПериодПовтораВТечениеДня <> 0 Тогда
		Значение = ТекущаяДата + ПериодПовтораВТечениеДня;
	ИначеЕсли ПериодПовтораДней <> 0 Тогда
		Значение = ТекущаяДата + ПериодПовтораДней * 3600 * 24;
	Иначе
		Значение = НачалоДня(КонецДня(ТекущаяДата) + 1);
	КонецЕсли;
	Настройки.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = Значение;
	РезервноеКопированиеИБСервер.УстановитьНастройкиРезервногоКопирования(Настройки);
	
	Возврат Значение;
	
КонецФункции

Процедура УстановитьДатуПоследнегоНапоминания(ДатаНапоминания) Экспорт
	
	РезервноеКопированиеИБСервер.УстановитьДатуПоследнегоНапоминания(ДатаНапоминания);
	
КонецПроцедуры

#КонецОбласти
