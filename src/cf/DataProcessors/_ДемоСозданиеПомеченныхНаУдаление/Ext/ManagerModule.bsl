﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Выполняет сдвиг границы итогов.
Процедура УдалениеПомеченныхПоРасписанию(ПараметрыКоманды, АдресХранилища) Экспорт
	УдалениеПомеченныхОбъектовСлужебный.УдалениеПомеченныхПоРасписанию();
КонецПроцедуры

#КонецОбласти

#КонецЕсли
