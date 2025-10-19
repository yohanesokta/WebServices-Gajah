from sys import version
from PyQt6.QtCore import QObject, QThread, pyqtSignal
import urllib.request, json, time


class RequestUpdatesWorker(QObject):
    finished = pyqtSignal(bool)

    def run(self):
        try:
            url = "https://yohanesokta.github.io/WebServices-Gajah/api/version.json"
            with urllib.request.urlopen(url, timeout=5) as response:
                data = json.loads(response.read().decode())
            for d in data:
                print(d["version"], type(d["version"]))
            self.finished.emit(False)
        except Exception as e:
            self.finished.emit(False)
