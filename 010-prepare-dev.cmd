@chcp 65001

call vrunner compile --src src/cf --out ./build/1Cv8.cf
call vrunner init-dev --src src/cf %*
call vrunner run --command "ЗапуститьОбновлениеИнформационнойБазы;ЗавершитьРаботуСистемы;" --execute $runnerRoot\epf\ЗакрытьПредприятие.epf %*
