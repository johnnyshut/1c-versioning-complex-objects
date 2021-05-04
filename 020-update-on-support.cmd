@chcp 65001

@rem обновление конфигурации на поддержки
call vrunner compile --src src/cf --out build/1cv8.cf %*
call vrunner load --src build/1cv8.cf %*
call vrunner updatedb %*

@rem обновление в режиме Предприятие
call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*
