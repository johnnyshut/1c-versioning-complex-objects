@chcp 65001

@rem TODO перенести код в tools\windows
call opm install fs
call opm install vanessa-runner
call opm install v8runner
call opm install verbal-expressions
call opm install add
call opm install oscript-config

@rem Отключение режима защиты в 1С
call oscript .\tools\windows\disable-unsafe-action-protection.os
