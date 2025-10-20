from sys import version
from packaging import version
import configparser
from PyQt6.QtCore import QObject, QThread, pyqtSignal
import urllib.request, json, time


class RequestUpdatesWorker(QObject):
    config = configparser.ConfigParser()
    config.read("version.ini")
    finished = pyqtSignal(bool)
    localVersion = version.parse(config["VERSION"]["APP"])

    def run(self):
        try:
            url = "https://yohanesokta.github.io/WebServices-Gajah/api/version.json"
            with urllib.request.urlopen(url, timeout=5) as response:
                data = json.loads(response.read().decode())
            serverVersion = version.parse(str(data[0]["version"]))
            print(float(self.config["VERSION"]["APP"]), "<", float(data[0]["version"]))
            self.finished.emit(self.localVersion < serverVersion)
        except Exception as e:
            print(e)
            self.finished.emit(False)
