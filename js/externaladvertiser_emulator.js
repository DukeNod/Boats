'use strict';

/**
 * Данный класс предназначен для имуляции запросов от
 * Внешнего Поставщика Рекламы (ВРК), например VDOOH, к API Планера.
 * Порядок работы:
 * 1) Обработка перечня медиафайлов (чей url передается извне), сохранение в Планнеровщик,
 * + создание сущностей в ЛКМ сразу с пометкой "промодерировано" и дублирование отметки в
 * Планнировщик - все посредством API-метода load.
 * 2) Каким-то образом промодерированные ролики из ЛК передавать в Эврику (думаю вначале
 * без создания компаний).
 * 3) Запрос у Эврики списка незагруженных мониторов, берется 40%, и по каждому из них идет
 * запрос к ВРК и получаются список роликов, которые надо отыграть на каждом мониторе.
 * 4) Запрос на получение статистик у Эврики - API-методы billing и billingDetails.
 */
class ExternalAdvertiserEmulator {
    constructor(options) {
        this.options = options; // Массив опций, переданный из .php

        this.main();
    }

    /**
     * Функция возвращает распарсенный JSON или в случае неудачи false
     * @param string
     * @returns object | false
     */
    getParsedJSON(string) {
        if (string) {
            try {
                return JSON.parse(string);
            } catch (e) {
                return false;
            }
        }
    }

    /**
     * Данная функция формирует массив идентификаторов успешно сохранившихся в Планнер медиа-файлов
     * @param data
     * @returns {Array}
     */
    getSuccessMediaIds(data) {
        let vm = this;
        let mediaFiles = data.mediaStatus;
        let result = [];
        mediaFiles.forEach((val, index, array) => {

            //if (val.success) //TODO: в бою раскоментить. Сейчас закоменчено, чтобы не плодить сущности
            result.push(val.mediaItemId);
        });
        return result;
    }

    /**
     * Вызывает API-метод load, который обрабатывает перечень медиафайлов, сохраняет в БД Планнера
     * и в ЛК с пометкой "промодерирован"
     * @returns {Promise}
     */
    load() {
        return new Promise((resolve, reject) => {
            let vm = this;
            $.ajax({
                url: "http://dev-mediaplan.nebo.digital/vgangnus/api/externaladvertiser/load"
                , headers: {
                    'x-auth-token': vm.options.common.xauthtoken
                }
                , type: 'POST'
                , responseType: 'JSON'
                , data: vm.options.methods.load.params
                , success: function (data) {
                    let parsedData = vm.getParsedJSON(data);
                    if (parsedData) // Проверка на валидный JSON-объект и его получение
                    {
                        // Если в ответе данные не верного формата - ошибка
                        if (parsedData.mediaStatus === undefined)
                            reject('The "load" error:\n' + data);
                        else
                            resolve(data);
                    } else
                        reject('Invalid JSON:\n' + data);
                }
                , error: function (request, status, error) {
                    reject(new Error(request.responseText));
                }
            });
        });
    }

    /**
     * Вызывает API-метод player, который возвращает 40% от списка "свободных" мониторов
     * @returns {Promise}
     */
    player()
    {
        return new Promise((resolve, reject) => {
            let vm = this;
            $.ajax({
                url: "http://dev-mediaplan.nebo.digital/vgangnus/api/externaladvertiser/player"
                , headers: {
                    'x-auth-token': vm.options.common.xauthtoken
                }
                , type: 'GET'
                , responseType: 'JSON'
                , data: vm.options.methods.player.params
                , success: function (data) {
                    resolve(data);

                    let parsedData = vm.getParsedJSON(data);
                    if (parsedData) // Проверка на валидный JSON-объект и его получение
                    {
                        if (parsedData.player === undefined) // Если в ответе данные не верного формата - ошибка
                            reject('The "player" error:\n' + data);
                        else
                            resolve(data);
                    } else
                        reject('Invalid JSON:\n' + data);
                }
                , error: function (request, status, error) {
                    reject(new Error(request.responseText));
                }
            });
        });
    }

    /**
     * Вызывает API-метод mediaItem, который возвращает список промодерированных роликов
     * @returns {Promise}
     */
    mediaItem() {
        return new Promise((resolve, reject) => {
            let vm = this;
            $.ajax({
                url: "http://dev-mediaplan.nebo.digital/vgangnus/api/externaladvertiser/mediaitem"
                , headers: {
                    'x-auth-token': vm.options.common.xauthtoken
                }
                , type: 'GET'
                , responseType: 'JSON'
                , data: vm.options.methods.mediaitem.params
                , success: function (data) {
                    resolve(data);

                    let parsedData = vm.getParsedJSON(data);
                    if (parsedData) // Проверка на валидный JSON-объект и его получение
                    {
                        // Если в ответе данные не верного формата - ошибка
                        if (parsedData.approved === undefined || parsedData.rejected === undefined)
                            reject('The "mediaItem" error:\n' + data);
                        else
                            resolve(data);
                    } else
                        reject('Invalid JSON:\n' + data);
                }
                , error: function (request, status, error) {
                    reject(new Error(request.responseText));
                }
            });
        });
    }

    /**
     * Вызывает API-метод billing, который возвращает количественную статистику по показам медиафайлов
     * @returns {Promise}
     */
    billing() {
        return new Promise((resolve, reject) => {
            let vm = this;
            $.ajax({
                url: "http://dev-mediaplan.nebo.digital/vgangnus/api/externaladvertiser/billing"
                , headers: {
                    'x-auth-token': vm.options.common.xauthtoken
                }
                , type: 'GET'
                , responseType: 'JSON'
                , data: vm.options.methods.billing.params
                , success: function (data) {
                    resolve(data);

                    let parsedData = vm.getParsedJSON(data);
                    if (parsedData) // Проверка на валидный JSON-объект и его получение
                    {
                        if (parsedData.billing === undefined) // Если в ответе данные не верного формата - ошибка
                            reject('The "billing" error:\n' + data);
                        else
                            resolve(data);
                    } else
                        reject('Invalid JSON:\n' + data);
                }
                , error: function (request, status, error) {
                    reject(new Error(request.responseText));
                }
            });
        });
    }

    /**
     * Вызывает API-метод billingdetails, который возвращает статистику по фактам показа медиафайлов
     * @returns {Promise}
     */
    billingDetails() {
        return new Promise((resolve, reject) => {
            let vm = this;
            $.ajax({
                url: "http://dev-mediaplan.nebo.digital/vgangnus/api/externaladvertiser/billingdetails"
                , headers: {
                    'x-auth-token': vm.options.common.xauthtoken
                }
                , type: 'GET'
                , responseType: 'JSON'
                , data: vm.options.methods.billingdetails.params
                , success: function (data) {
                    resolve(data);

                    let parsedData = vm.getParsedJSON(data);
                    if (parsedData) // Проверка на валидный JSON-объект и его получение
                    {
                        if (parsedData.billingDetails === undefined) // Если в ответе данные не верного формата - ошибка
                            reject('The "billingDetails" error:\n' + data);
                        else
                            resolve(data);
                    } else
                        reject('Invalid JSON:\n' + data);
                }
                , error: function (request, status, error) {
                    reject(new Error(request.responseText));
                }
            });
        });
    }

    /**
     * Этот модуль "руководит" всем процессом эмулирования
     */
    main() {
        let vm = this;
        let el = document.getElementById('container'); // контейнер для результата ответа

        el.innerHTML += '\nEmulate start.\n"<b>Step-1</b>": Call the "load" API-method...\n';
        vm.load()
            // 1) Получаем результаты обработки перечня медиафайла
            .then(
                response =>
                {
                    let containerText = 'The response of "load": \n' + response +'\n';
                    el.innerHTML += containerText;
                    el.innerHTML += 'Attempt to form an array of successfully saved media-files...\n';
                    let successedMediaIds = vm.getSuccessMediaIds(vm.getParsedJSON(response));

                    if(!successedMediaIds.length) // Если нет успешно сохраненных файлов
                        return Promise.reject(new Error('No media-files has been successfully saved.'));

                    el.innerHTML += 'SuccesedMediaIds: [' + successedMediaIds+'];\n';
                    return vm.player();//successedMediaIds;
                }
            )
            // 2) Полученые ID считаем за "промодерированные". Вызов функции переноса в Эврику.
            .then(
                successedMediaIds =>
                {
                    vm.player();

                    console.log(successedMediaIds);
                    //return vm.load();
                }
            )
            .then(
                string =>
                {
                    //el.innerHTML += string;
                }
            )
            // Вывод ошибки
            .catch(error =>
            {
                el.innerHTML += '<b>Abort</b>.\nCatched: ' + error;
            });
    }
}