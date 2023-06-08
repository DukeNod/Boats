<?php
/**
 * Created by PhpStorm.
 * User: vadim
 * Date: 08.11.19
 * Time: 16:47
 */

class Dates {
    public function __construct()
    {
    }

    /**
     * Функция находит общее кол-во дней между двумя датами
     * (также может фильтровать по выходным и рабочим дням).
     * @param $errors
     * @param $from
     * @param $to
     * @param array $options - представляет собой массив weekDays из монго-коллекции monitorsStandaloneSchedule
     * @return int
     */
    public function common_days_for_period(&$errors, $from, $to, $options = ['holiday', 'workday'])
    {
        if (!$options) $options = ['holiday', 'workday']; // Если null или пустой массив

        $is_holiday = in_array('holiday', $options);
        $is_workday = in_array('workday', $options);

        // На случай, если $from и $to перепутаны
        $real_from = $from;
        $real_to = $to;
        if ($from > $to)
        {
            $real_from = $to;
            $real_to = $from;
        } 

        // Считаем общее количиство дней в диапазоне
        $common_days = ((int) date_diff($real_from, $real_to)->format('%a')) + 1;

        // В самом простейшем случае его и возвращаем
        if ($is_holiday && $is_workday) return $common_days;

        $numeric_week_days = [];
        if ($is_holiday) {
            $numeric_week_days = [0,6];
        }
        if ($is_workday) {
            $numeric_week_days = [1,2,3,4,5];
        }

        // 1. Вычислить кол-во нужных дней
        $result_days = 0;
        if ($common_days >= 7)
        {
            $real_from_week_n = $real_from->format('w');

            // Сдвигаем конец диапазона назад так, чтобы день недели
            // конца диапазона был перед днём недели начала
            while ($real_from_week_n != ($real_to->format('w') + 1) % 7)
            {
                if (in_array($real_to->format('w'), $numeric_week_days)) $result_days++;
                $common_days--;
                $real_to->modify('-1 days');
            }

            $result_days += $common_days / 7 * count($numeric_week_days);
        } else // Если дней мало - просто проверяем каждый
        {
            while ($real_from <= $real_to)
            {
                if (in_array($real_from->format('w'), $numeric_week_days)) $result_days++;
                $real_from->modify('+1 days');
            }
        }

        return $result_days;
    }

    /**
     * По массиву строк периодов вычислить, сколько периоды занимают от суток.
     * P.S: предполагается, что периоды не пересекаются.
     * @param $errors
     * @param $str_periods array строки вида "00:00-01:10" ( такие данные хранятся н-р в monitorsStandaloneSchedule.dayTime)
     * @return float
     */
    public function get_seconds_from_periods (&$errors, $str_periods)
    {
        $day = (new DateTime())->format('Y-m-d');
        $seconds = 0;

        // Преобразование массива строк в массив периодов DateTime
        $periods = [];
        foreach ($str_periods as $str_period)
        {
            $arr_period = explode('-', $str_period);
            $from_arr = explode(':', $arr_period[0]);
            $from = (new DateTime($day))->setTime($from_arr[0], $from_arr[1], 0);
            $to_arr = explode(':', $arr_period[1]);
            $to = (new DateTime($day))->setTime($to_arr[0], $to_arr[1], 0);
            if ($to < $from) $to->modify("+1 days"); // Для периодов типа "19:40-01:00"
            array_push($periods, ['from' => $from, 'to' => $to]);
        }

        // Вычисляем для каждого периода количество секунд
        foreach ($periods as $period)
        {
            $seconds += $period['to']->getTimestamp() - $period['from']->getTimestamp() + 1;
        }

        // Возвращаем количество часов
        return $seconds;
    }

    /**
     * Функция сравнивает две диапазона, и возвращает общее количество в секундах
     * @param $errors
     * @param $p1 array ассоциотивный массив вида ['from' => DateTime Object, 'to' => DateTime Object]
     * @param $p2 array ассоциотивный массив вида ['from' => DateTime Object, 'to' => DateTime Object]
     * @return int
     */
    public function common_seconds_for_two_periods(&$errors, $p1, $p2)
    {
        $common_seconds = 0;

        if ( // Если хоть одна из дат не указана, или не является экземпляром DateTime - возвращаем 0
            !   (isset($p1['from']) && $p1['from'] instanceof DateTime)
            || !(isset($p1['to']) && $p1['to'] instanceof DateTime)
            || !(isset($p2['from']) && $p2['from'] instanceof DateTime)
            || !(isset($p2['to']) && $p2['to'] instanceof DateTime)
        )
        {
            validate_add_error($errors, 'Dates', 'common_seconds_for_two_periods', 'wrong_periods');
            return $common_seconds;
        }

        // Округление дат DateTime'ов до дня
        $p1['from']->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p1['to']->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p2['from']->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p2['to']->setTimezone(new DateTimeZone('Europe/Moscow'));

        if (   $p1['from'] > $p2['to'] || $p1['to'] < $p2['from'] // Если периоды не пересекаются,
            || $p1['from'] > $p1['to'] || $p2['from'] > $p2['to'] // или у одного из периода начала больше конца
        ) return $common_seconds;                                    // - возвращаем ноль.

        // Условие для всех возможных пересечений:

        // 1. Сдвиг влево
        if ($p1['from'] > $p2['from'] && $p1['to'] > $p2['to'])
        {
            $common_seconds = abs($p1['from']->getTimestamp() - $p2['to']->getTimestamp());

            // 2. Сдвиг вправо
        } else if ($p1['from'] < $p2['from'] && $p2['to'] > $p1['to'])
        {
            $common_seconds = abs($p1['to']->getTimestamp() - $p2['from']->getTimestamp());

            // 3. внутри и совпадающие
        } else if ($p1['from'] >= $p2['from'] && $p1['to'] <= $p2['to']) {
            $common_seconds = abs($p1['from']->getTimestamp() - $p1['to']->getTimestamp());

            // 4. снаружи
        } else if ($p1['from'] <= $p2['from'] && $p1['to'] >= $p2['to']) {
            $common_seconds = abs($p2['from']->getTimestamp() - $p2['to']->getTimestamp());
        }

        return $common_seconds;
    }

    /**
     * Функция сравнивает две диапазона, и возвращает количество общих дней.
     * @param $errors
     * @param $p1 array ассоциотивный массив вида ['from' => DateTime Object, 'to' => DateTime Object]
     * @param $p2 array ассоциотивный массив вида ['from' => DateTime Object, 'to' => DateTime Object]
     * @param $options array
     * @return int
     */
    public function common_days_for_two_periods(&$errors, $p1, $p2, $options = ['holiday', 'workday'])
    {
        $common_days = 0;

        if ( // Если хоть одна из дат не указана, или не является экземпляром DateTime - возвращаем 0
            !   (isset($p1['from']) && $p1['from'] instanceof DateTime)
            || !(isset($p1['to']) && $p1['to'] instanceof DateTime)
            || !(isset($p2['from']) && $p2['from'] instanceof DateTime)
            || !(isset($p2['to']) && $p2['to'] instanceof DateTime)
        )
        {
            validate_add_error($errors, 'Dates', 'common_days_for_two_periods', 'wrong_periods');
            return $common_days;
        }

        // Округление дат DateTime'ов до дня
        $p1['from']->setTime(0, 0, 0)->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p1['to']->setTime(0, 0, 0)->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p2['from']->setTime(0, 0, 0)->setTimezone(new DateTimeZone('Europe/Moscow'));
        $p2['to']->setTime(0, 0, 0)->setTimezone(new DateTimeZone('Europe/Moscow'));

        if (   $p1['from'] > $p2['to'] || $p1['to'] < $p2['from'] // Если периоды не пересекаются,
            || $p1['from'] > $p1['to'] || $p2['from'] > $p2['to'] // или у одного из периода начала больше конца
        ) return $common_days;                                    // - возвращаем ноль.

        // Условие для всех возможных пересечений:

        // 1. Сдвиг влево
        if ($p1['from'] > $p2['from'] && $p1['to'] > $p2['to'])
        {
            //$common_days = ((int) date_diff($p1['from'], $p2['to'])->format('%a')) + 1;
            $common_days = $this->common_days_for_period($errors, $p1['from'], $p2['to'], $options);

        // 2. Сдвиг вправо
        } else if ($p1['from'] < $p2['from'] && $p2['to'] > $p1['to'])
        {
            //$common_days = ((int) date_diff($p1['to'], $p2['from'])->format('%a')) + 1;
            $common_days = $this->common_days_for_period($errors, $p1['to'], $p2['from'], $options);

        // 3. внутри и совпадающие
        } else if ($p1['from'] >= $p2['from'] && $p1['to'] <= $p2['to']) {
            //$common_days = ((int) date_diff($p1['from'], $p1['to'])->format('%a')) + 1;
            $common_days = $this->common_days_for_period($errors, $p1['from'], $p1['to'], $options);

        // 4. снаружи
        } else if ($p1['from'] <= $p2['from'] && $p1['to'] >= $p2['to']) {
            //$common_days = ((int) date_diff($p2['from'], $p2['to'])->format('%a')) + 1;
            $common_days = $this->common_days_for_period($errors, $p2['from'], $p2['to'], $options);
        }

        return $common_days;
    }
}