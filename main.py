from PyQt6.QtWidgets import QApplication, QWidget, QVBoxLayout, QPushButton, QProgressBar, QLabel
import sys
from runner.url_download import Downloader

class App(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Downloader")
        self.setGeometry(300, 300, 400, 150)

        self.layout = QVBoxLayout()
        self.label = QLabel("Klik untuk mulai download")
        self.progress = QProgressBar()
        self.button = QPushButton("Mulai Download")

        self.layout.addWidget(self.label)
        self.layout.addWidget(self.progress)
        self.layout.addWidget(self.button)
        self.setLayout(self.layout)

        self.button.clicked.connect(self.start_download)

    def start_download(self):
        url = "https://github.com/yohanesokta/WebServices-Gajah/releases/download/runtime/apache.zip"  # contoh file besar
        output = "apache.zip"

        self.downloader = Downloader(url, output)
        self.downloader.progress.connect(self.update_progress)
        self.downloader.finished.connect(self.download_done)
        self.downloader.start()

        self.button.setEnabled(False)
        self.label.setText("Sedang mendownload...")

    def update_progress(self, value):
        self.progress.setValue(value)

    def download_done(self):
        self.label.setText("Download selesai!")
        self.button.setEnabled(True)


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = App()
    window.show()
    sys.exit(app.exec())