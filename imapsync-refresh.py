import requests
import json
import schedule
import time

auth = ("574c8af6-4607-4dc9-a7d0-c69c1068e0f4", "nFV8Q~z~UY~6t4gPnXqWGJTcUdh4QuPCdyjwGb6a")
url = "https://login.microsoftonline.com/common/oauth2/v2.0/token"

params = {
  "grant_type":"refresh_token",
  "scope":"https://outlook.office365.com/.default",
  "refresh_token":"0.AXEAO-O4fmpHzESTGXgv9wu69eGW4tJ82pREulRVmtOIcw-HAAI.AgABAAEAAAD--DLA3VO7QrddgJg7WevrAgDs_wUA9P-W_XNG1yIvUj0xke9uQIH-T5eeJGYsWjeQvyRvNsej16IyQ9ziQ6aOKJ4vH0JNMP2E3tIXYhLnkuwau-nYdnr1TTJmHjajmiwSX18QFUX2Tff2zJR33JCtzWdR7dDWB1viy2bDbyOGIu37u6nCIZTCm2KYCFbvyrmyFlPrYPYvvN4OMdZg1Ykj_hoDBaRZdlU-7Nou2woBag26wyh64qtURbrAuwF3cw92XydRJD4HPdddwPBd_fIXmhB93emI3Qr9ZoGQ6SJxwmtbfLtmSHClWHzT_RQ_ZXUnZt09sl43jXk5dyCkHZ0JuaMFu3FXujg70p7UsIeCCCp7cqbQWrDiiA-3sOVu6qjHZ8C0ujeRj50UaLQtaioiovrU4ByUo8FeJs7sPSIkWd1z5rRtuNyjpS644fbzcVP17tlIo0clT7XokyxVn6TaacBeErGSfGup6mrdKBdA-QEEDbcGOpe2ESPeeWtXW_vehwmAfT2bPM3wEVVEW_6T3_r3QfI1Ii4DwLQTLKMyTw7EZ4Heq0n_aCmASkiTojFd4PqEL4zCeWSNsh6rBROUoXEHYjKHzC1GlVCsRtv5K1qC7g2wOCOyv1rUoPESgCv8lsKtQB2EKWqSrZ91zB-jlYdbQ8DL4uyEYEabsQBs-iKJsF46l3L82EM2V4yhLhjl8IQVxN5M3hJ2MLUgoM0cQLhVGjirygQa7jS8Wt3o_CkuWE0TEy3C6EQyDPPoi9K6v87voq3G"
}

def job():
    ret = requests.post(url, auth=auth, data=params)
    print(ret.text.encode('utf8'))
    access_key = ret.json()
    
    with  open("TOKEN.txt", "w") as f:
        f.write(str(access_key['access_token']))

schedule.every(50).minutes.do(job)
schedule.every().hour.do(job)
schedule.every().day.at("10:30").do(job)

while 1:
    schedule.run_pending()
    time.sleep(1)
