#!/usr/bin/env bash

CITY=Jinan
LATITUDE=36.591699
LONGITUDE=117.333495

CACHE_DIR=~/.cache/rbn
CACHE_FILE=${0##*/}-$1
EXPIRATION_DATE=$((60 * 45))

if [ ! -d ${CACHE_DIR} ]; then
	mkdir -p ${CACHE_DIR}
fi

if [ ! -f "${CACHE_DIR}/${CACHE_FILE}" ]; then
	touch "${CACHE_DIR}/${CACHE_FILE}"
fi

# 请求天气 API 并缓存结果
cacheage=$(($(date +%s) - $(stat -c '%Y' "${CACHE_DIR}/${CACHE_FILE}")))
if [ $cacheage -gt ${EXPIRATION_DATE} ] || [ ! -s "${CACHE_DIR}/${CACHE_FILE}" ]; then
	data=$(xh GET \
		https://api.open-meteo.com/v1/forecast \
		latitude==${LATITUDE} \
		longitude==${LONGITUDE} \
		current==temperature_2m,weather_code \
		daily==temperature_2m_max,temperature_2m_min,sunset,sunrise \
		timezone==auto \
		forecast_days==1)
	echo "${data}" | jq \
		'{
            sunset: .daily.sunset[0],
            sunrise: .daily.sunrise[0],
            weather_code: .current.weather_code,
            temperature: .current.temperature_2m,
            temperature_max: .daily.temperature_2m_max[0],
            temperature_min: .daily.temperature_2m_min[0]
        }' >"${CACHE_DIR}/${CACHE_FILE}"
fi

is_day=false
weather_code=$(jq '.weather_code' "${CACHE_DIR}/${CACHE_FILE}")
temperature=$(jq '.temperature' "${CACHE_DIR}/${CACHE_FILE}")
temperature_max=$(jq '.temperature_max' "${CACHE_DIR}/${CACHE_FILE}")
temperature_min=$(jq '.temperature_min' "${CACHE_DIR}/${CACHE_FILE}")

# 判断是否日出
sunrise=$(date -d "$(jq -r '.sunrise' "${CACHE_DIR}/${CACHE_FILE}")" +%s)
sunset=$(date -d "$(jq -r '.sunset' "${CACHE_DIR}/${CACHE_FILE}")" +%s)
now=$(date +%s)
if [[ ${now} > ${sunrise} && ${now} < ${sunset} ]]; then
	is_day=true
fi

rt_is_day() {
	[[ $is_day == true ]] && echo "${1}" || echo "${2}"
}

# WMO 天气代码 url: https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
case ${weather_code} in
0) # 晴天
	condition=$(rt_is_day "" "")
	;;
1 | 2 | 3) # 多云
	condition=$(rt_is_day "" "")
	;;
5[0-9] | 60 | 61) # 小雨和毛毛雨
	condition=$(rt_is_day "" "")
	;;
62 | 63 | 64 | 65) # 中到大雨
	condition=$(rt_is_day "" "")
	;;
85 | 70 | 71) # 小雪
	condition=$(rt_is_day "" "")
	;;
72 | 73 | 74 | 75) # 大雪
	condition=$(rt_is_day "" "")
	;;
*)
	condition=""
	echo -e "{\"text\":\""ErrorWeatherCode ${condition}"\", \"alt\":\""ErrorWeatherCode ${condition}"\", \"tooltip\":\""ErrorWeatherCode ${condition}"\"}" && exit 0
	;;
esac

printf '{"text": "%s(%s)°C %s", "alt": "%s", "tooltip": "%s: (%s)%s(%s)°C %s"}\n' "${temperature}" "${temperature_max}" "${condition}" "${CITY}" "${CITY}" "${temperature_min}" "${temperature}" "${temperature_max}" "${condition}"
