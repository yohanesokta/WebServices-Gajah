from PyQt6.QtCore import QThread, pyqtSignal
import urllib.request

class Downloader(QThread):
    progress = pyqtSignal(int)
    finished = pyqtSignal()

    def __init__(self, url, output):
        super().__init__()
        self.url = url
        self.output = output

    def run(self):
        def report(block_num, block_size, total_size):
            downloaded = block_num * block_size
            if total_size > 0:
                percent = int(downloaded * 100 / total_size)
                self.progress.emit(percent)

        urllib.request.urlretrieve(self.url, self.output, reporthook=report)
        self.finished.emit()