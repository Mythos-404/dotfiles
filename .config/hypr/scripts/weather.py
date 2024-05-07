#!/usr/bin/env python3

import os
import sys
import time

import orjson as json

CITY = "Jinan"
PARAMS = {
    "timezone": "auto",
    "timeformat": "unixtime",
    "latitude": 36.591699,
    "longitude": 117.333495,
    "current": "temperature_2m,weather_code",
    "daily": "temperature_2m_max,temperature_2m_min,sunset,sunrise",
    "forecast_days": 1,
}

CACHE_DIR = f"{os.path.expanduser('~')}/.cache/rbn"
CACHE_FILE = f"{CACHE_DIR}/om_weather.json"
EXPIRATION_DATE = 60 * 30  # 30 分钟


def print_waybar_json(text: str | dict, alt: str = "", tooltip: str = "") -> None:
    if isinstance(text, dict):
        print(json.dumps(text).decode("utf-8"))
    else:
        print(json.dumps({"text": text, "alt": alt, "tooltip": tooltip}).decode("utf-8"))


def check_cache() -> None:
    if not os.path.isdir(CACHE_DIR):
        os.mkdir(CACHE_DIR)

    if not os.path.isfile(CACHE_FILE):
        from pathlib import Path

        Path(CACHE_FILE).touch()


# 请求天气 API 并缓存结果
def get_whater_api() -> None:
    if ((time.time() - os.path.getctime(CACHE_FILE)) >= EXPIRATION_DATE) or (os.stat(CACHE_FILE).st_size == 0):
        import requests as req

        try:
            data = req.get("https://api.open-meteo.com/v1/forecast", params=PARAMS).json()
            weather = {
                "sunset": data["daily"]["sunset"][0],
                "sunrise": data["daily"]["sunrise"][0],
                "weather_code": data["current"]["weather_code"],
                "temp": data["current"]["temperature_2m"],
                "temp_max": data["daily"]["temperature_2m_max"][0],
                "temp_min": data["daily"]["temperature_2m_min"][0],
            }
            with open(CACHE_FILE, mode="w") as f:
                f.write(json.dumps(weather).decode("utf-8"))
        except req.exceptions.ConnectionError:
            print_waybar_json("NotNetwork 󰌙 ")
            sys.exit(0)
        except req.exceptions.Timeout:
            print_waybar_json("Timeout 󰌙 ")
            sys.exit(0)


def get_json() -> dict:
    def get_daytime_icon(day_icon: str, moon_icon: str) -> str:
        """判断是否日出返回正确的图标"""
        if (now := time.time()) > weather["sunrise"] and now < weather["sunset"]:
            return day_icon
        else:
            return moon_icon

    with open(CACHE_FILE) as f:
        weather = json.loads(f.read())

    # WMO 天气代码 url: https://www.nodc.noaa.gov/archive/arc0021/0002199/1.1/data/0-data/HTML/WMO-CODE/WMO4677.HTM
    match weather["weather_code"]:
        case 0 | 1:  # 晴天
            current_icon = get_daytime_icon("", "")
        case 2 | 3:  # 多云
            current_icon = get_daytime_icon("", "")
        case 60 | 61 | 80:  # 小雨
            current_icon = get_daytime_icon("", "")
        case x if 50 <= x <= 59:  # 毛毛雨
            current_icon = get_daytime_icon("", "")
        case 62 | 63 | 64 | 65:  # 中到大雨
            current_icon = get_daytime_icon("", "")
        case 70 | 71 | 85:  # 小雪
            current_icon = get_daytime_icon("", "")
        case 72 | 73 | 74 | 75:  # 大雪
            current_icon = get_daytime_icon("", "")
        case _:
            current_icon = ""

    return {
        "text": f"{weather['temp']}({weather['temp_max']})°C {current_icon}",
        "alt": f"{CITY}",
        "tooltip": f"{CITY}: ({weather['temp_min']}){weather['temp']}({weather['temp_max']})°C {current_icon}",  # noqa
    }


if __name__ == "__main__":
    check_cache()
    get_whater_api()
    print_waybar_json(get_json())
