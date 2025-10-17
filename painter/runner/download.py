from PyQt6.QtCore import QThread, pyqtSignal, QObject, pyqtSignal, QTimer


import urllib.request

# class Downloader(QThread):
#     progress = pyqtSignal(int)
#     finished = pyqtSignal()

#     def __init__(self, url, output):
#         super().__init__()
#         self.url = url
#         self.output = output

#     def run(self):
#         def report(block_num, block_size, total_size):
#             downloaded = block_num * block_size
#             if total_size > 0:
#                 percent = int(downloaded * 100 / total_size)
#                 self.progress.emit(percent)

#         urllib.request.urlretrieve(self.url, self.output, reporthook=report)
#         self.finished.emit()

class Downloader(QObject):
    progress = pyqtSignal(int)
    finished = pyqtSignal()
    def __init__(self, url, output):
        super().__init__()
        self._progress = 0
        self._timer = QTimer(self)
        self._timer.timeout.connect(self._update_progress_mock)
    def start(self):
        self._progress = 0
        self._timer.start(100)
    def _update_progress_mock(self):
        if self._progress < 100:
            self._progress += 2
            self.progress.emit(self._progress)
        else:
            self._timer.stop()
            self.finished.emit()