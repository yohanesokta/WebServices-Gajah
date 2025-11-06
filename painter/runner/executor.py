import subprocess
import os
from PyQt6.QtCore import QObject, pyqtSignal, QThread


class _ExecWorker(QObject):
    finished = pyqtSignal()
    status = pyqtSignal(str)
    __url = ""

    def setBatPath(self,bat_path):
        self.__url = bat_path

    def run(self):
        try:
            bat_path = self.__url
            print("BATTT PATHHHHH",bat_path)
            if not os.path.exists(bat_path):
                self.status.emit(f"[ERROR] File tidak ditemukan: {bat_path}")
                self.finished.emit()
                return

            process = subprocess.Popen(
                ["cmd.exe", "/c", bat_path],
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                shell=True
            )

            for line in process.stdout:
                line = line.strip()
                self.status.emit(line)

            process.wait()
        except Exception as e:
            self.status.emit(f"[ERROR] {e}")
        finally:
            self.finished.emit()


class Exec(QObject):
    finished = pyqtSignal()
    status = pyqtSignal(str)

    def __init__(self,bat_path):
        super().__init__()
        self._thread = None
        self._worker = None
        self.path = bat_path

    def start(self):
        self._thread = QThread()
        self._worker = _ExecWorker()

        self._worker.status.connect(self.status)
        self._worker.finished.connect(self.finished)

        self._worker.finished.connect(self._thread.quit)
        self._thread.finished.connect(self._thread.deleteLater)
        self._worker.finished.connect(self._worker.deleteLater)

        self._worker.moveToThread(self._thread)
        self._thread.started.connect(self._worker.run)
        self._worker.setBatPath(self.path)
        self._thread.start()
