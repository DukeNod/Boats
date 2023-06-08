$(function () {
    //Элементы DOM
    const DOMElements = {
        reportSelect: document.getElementById('reportSelect'),
        reportFormat: document.getElementById('reportFormat'),
        dateStart: document.getElementById('dateStart'),
        datepickerStart: document.getElementById('datepicker-from'),
        dateEnd: document.getElementById('dateEnd'),
        platforms: document.getElementById('platforms'),
        kind: document.getElementById('kind'),

        metroSelect: document.getElementById('metroSelect'),
        kindSelect: document.getElementById('kindSelect'),

        downloadLink: document.getElementById('downloadLink')
    };

    // Общая для всех отчетов часть URL
    const commonUrl = PUB_SITE + 'api/platformcapacity/report';

    let currUrl = '';
    let currReport = 'row';

    // Настройки отчётов
    const reportsSettings = {
        row:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'PlatformCode',
                path: ''
            } ,
        cache:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'PlatformCode',
                path: '/cache'
            },
        avg:
            {
                filterState: {dateStart: 0, dateEnd: 0, platforms: 1, kind: 0},
                platformIdentifier: 'ID',
                path: '/avg'
            },
        cacheminmax:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'ID',
                path: '/cacheminmax'
            },
        cachestat:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'ID',
                path: '/cachestat'
            },
        cachemaxpivot:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'ID',
                path: '/cachemaxpivot'
            },
        airtime:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 1},
                platformIdentifier: 'ID',
                path: '/airtime'
            },
        planfact:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'PlatformCode',
                path: '/planfact'
            },
        inventory_cache:
            {
                filterState: {dateStart: 1, dateEnd: 1, platforms: 1, kind: 0},
                platformIdentifier: 'ID',
                path: '/inventory_cache'
            }
    };

    // Порядок = порядку подключения
    const filterValues = {
        platforms: null,
        dateStart: null,
        dateEnd: null,
        kind: null
    };
    let selectedType = null;

    // При попытке "сформировать" ссылку
    const formingUrl = function () {
        currUrl = `${commonUrl}${reportsSettings[currReport].path}`;

        let isValid = true;
        for (let filter in filterValues) {
            // Если это св-во нужно для отчёта
            if (reportsSettings[currReport].filterState[filter]) {
                // Если нужного значения нет
                if (!filterValues[filter]) {
                    isValid = false;
                    break;
                }

                // Для платформ смотрим, что используем: ID или PlatformCode
                if (filter === 'platforms') {
                    const platformArr = filterValues[filter].split(':');
                    if (reportsSettings[currReport].platformIdentifier === 'ID') {
                        currUrl += `/${platformArr[0]}`;
                    } else
                    if (reportsSettings[currReport].platformIdentifier === 'PlatformCode') {
                        currUrl += `/${platformArr[1]}`;
                    }
                } else {
                    currUrl += `/${filterValues[filter]}`
                }
            }
        }
        currUrl+=`/${selectedType}`;

        if (isValid) {
            DOMElements.downloadLink.href = currUrl;
            DOMElements.downloadLink.classList.remove('btn-danger');
            DOMElements.downloadLink.classList.remove('isDisabled');
            DOMElements.downloadLink.classList.add('btn-primary');
        } else {
            DOMElements.downloadLink.href = "javascript: void(0)";
            DOMElements.downloadLink.classList.remove('btn-primary');
            DOMElements.downloadLink.classList.add('btn-danger');
            DOMElements.downloadLink.classList.add('isDisabled');
        }
    };

    // При смене выбора отчёта
    const onReportChange = function (reportType) {
        DOMElements.downloadLink.setAttribute('download', DOMElements.reportSelect.options[DOMElements.reportSelect.selectedIndex].text+'.'+selectedType);

        currReport = reportType;
        for (let filterId in reportsSettings[reportType].filterState) {
            // Смена отображения фильтров
            DOMElements[filterId].style.display =
                (reportsSettings[reportType].filterState[filterId]) ?
                    'block' : 'none';
        }

        // Пытаемся сформировать url
        formingUrl();
    };

    /**
     * Обработчики событий
     */
    // Выбор отчёта
    DOMElements.reportSelect.addEventListener('change', function () {
        onReportChange(DOMElements.reportSelect.options[DOMElements.reportSelect.selectedIndex].value);
    });
    // Выбор типа отчёта (json||csv)
    DOMElements.reportFormat.addEventListener('change', function () {
        selectedType = DOMElements.reportFormat.options[DOMElements.reportFormat.selectedIndex].value;
        DOMElements.downloadLink.setAttribute('download', DOMElements.reportSelect.options[DOMElements.reportSelect.selectedIndex].text+'.'+selectedType);
        formingUrl();
    });
    // Смена платформы
    DOMElements.metroSelect.addEventListener('change', function () {
        filterValues.platforms = DOMElements.metroSelect.options[DOMElements.metroSelect.selectedIndex].value;
        formingUrl();
    });
    // Смена типа
    DOMElements.kindSelect.addEventListener('change', function () {
        filterValues.kind = DOMElements.kindSelect.options[DOMElements.kindSelect.selectedIndex].value;
        formingUrl();
    });

    // При инициализации
    const init = () => {
        selectedType = DOMElements.reportFormat.options[DOMElements.reportFormat.selectedIndex].value;
        onReportChange(DOMElements.reportSelect.options[DOMElements.reportSelect.selectedIndex].value);
        // Инициализация datepicker-ов
        let datepickerSettings = {
            locale: 'ru',
            format: 'YYYY-MM-DD'
        };
        $('#datepicker-from').datetimepicker(datepickerSettings).on('dp.change', function(e) {
            filterValues.dateStart = (e.date) ? e.date.format('YYYY-MM-DD') : null;
            formingUrl();
        });
        $('#datepicker-to').datetimepicker(datepickerSettings).on('dp.change', function (e) {
            filterValues.dateEnd = (e.date) ? e.date.format('YYYY-MM-DD') : null;
            formingUrl();
        });

        filterValues.kind = DOMElements.kindSelect.options[DOMElements.kindSelect.selectedIndex].value;
        filterValues.platforms = DOMElements.metroSelect.options[DOMElements.metroSelect.selectedIndex].value;
        formingUrl();
    };

    init();
});

