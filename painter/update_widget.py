from PyQt6.QtWidgets import (
    QWidget,
    QVBoxLayout,
    QPushButton,
    QProgressBar,
    QLabel,
    QHBoxLayout,
    QGraphicsDropShadowEffect,
)
from PyQt6.QtCore import Qt, QPropertyAnimation, QTimer, QPoint, QObject, QThread
from PyQt6.QtGui import QColor, QMouseEvent
from enum import Enum
from painter.update_request import RequestUpdatesWorker

from painter.runner.download import Downloader


class Downloader(QObject):
    from PyQt6.QtCore import pyqtSignal

    progress = pyqtSignal(int)
    finished = pyqtSignal()

    def __init__(self, url, output):
        super().__init__()
        self._progress = 0
        self._timer = QTimer(self)
        self._timer.timeout.connect(self._update)

    def start(self):
        self._progress = 0
        self._timer.start(50)

    def _update(self):
        if self._progress < 100:
            self._progress += 1
            self.progress.emit(self._progress)
        else:
            self._timer.stop()
            self.finished.emit()


class UpdateState(Enum):
    """Mendefinisikan status-status yang mungkin terjadi pada widget."""

    CHECKING = 1
    UPDATE_AVAILABLE = 2
    NO_UPDATE = 3
    DOWNLOADING = 4
    COMPLETED = 5
    INSTALLING = 6
    ALL_DONE = 7
    ERROR = 8


class UpdateWidget(QWidget):
    def __init__(self):
        super().__init__()
        self.drag_pos = QPoint()
        self.setWindowFlags(
            Qt.WindowType.FramelessWindowHint | Qt.WindowType.WindowStaysOnTopHint
        )
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)

        self.setFixedSize(400, 180)
        self.current_state = None

        self.container = QWidget(self)
        self.container.setObjectName("container")
        self.container.setFixedSize(self.size())

        main_layout = QVBoxLayout(self.container)
        main_layout.setContentsMargins(20, 20, 20, 20)
        main_layout.setSpacing(10)

        top_row_layout = QHBoxLayout()
        self.icon_label = QLabel("⏳")
        self.icon_label.setStyleSheet("font-size: 28px;")
        self.status_label = QLabel("Memeriksa pembaruan...")

        top_row_layout.addWidget(self.icon_label, 0)
        top_row_layout.addSpacing(15)
        top_row_layout.addWidget(self.status_label, 1)

        self.log_label = QLabel("")
        self.log_label.setObjectName("logLabel")
        self.log_label.setAlignment(Qt.AlignmentFlag.AlignLeft)
        self.log_label.hide()

        self.progress_bar = QProgressBar()
        self.progress_bar.setTextVisible(True)
        self.progress_bar.setFixedHeight(12)
        self.progress_bar.hide()

        self.action_button = QPushButton("Periksa")
        self.action_button.setCursor(Qt.CursorShape.PointingHandCursor)
        self.action_button.clicked.connect(self.handle_action_click)

        self.close_button = QPushButton("Tutup")
        self.close_button.setCursor(Qt.CursorShape.PointingHandCursor)
        self.close_button.clicked.connect(self.close)

        main_layout.addLayout(top_row_layout)
        main_layout.addWidget(self.log_label)
        main_layout.addStretch()
        main_layout.addWidget(self.progress_bar)
        bottom_layout = QHBoxLayout()
        bottom_layout.addWidget(
            self.action_button, alignment=Qt.AlignmentFlag.AlignLeft
        )
        bottom_layout.addWidget(
            self.close_button, alignment=Qt.AlignmentFlag.AlignRight
        )

        main_layout.addLayout(bottom_layout)

        self.set_state(UpdateState.CHECKING)
        self.show_with_fade_in()

    def mousePressEvent(self, event: QMouseEvent):
        if event.button() == Qt.MouseButton.LeftButton:
            self.drag_pos = (
                event.globalPosition().toPoint() - self.frameGeometry().topLeft()
            )
            event.accept()

    def mouseMoveEvent(self, event: QMouseEvent):
        if event.buttons() == Qt.MouseButton.LeftButton:
            self.move(event.globalPosition().toPoint() - self.drag_pos)
            event.accept()

    def set_log_message(self, message: str):
        """Mengatur teks pada label log."""
        self.log_label.setText(message)
        self.log_label.show()

    def reset_ui_visibility(self):
        self.progress_bar.hide()
        self.log_label.hide()
        self.close_button.show()
        self.action_button.setEnabled(True)

    def set_state(self, state: UpdateState):
        """Mengatur tampilan widget berdasarkan status yang diberikan."""
        self.current_state = state
        self.progress_bar.hide()
        self.log_label.hide()
        self.action_button.setEnabled(True)
        self.reset_ui_visibility()

        if state == UpdateState.CHECKING:
            self.container.setStyleSheet(self._get_style("#1E1E1E", "#2D2D2D"))
            self.icon_label.setText("⏳")
            self.status_label.setText("Memeriksa pembaruan...")
            self.action_button.setText("Batal")
            self.worker_thread = QThread()
            self.worker = RequestUpdatesWorker()
            self.worker.moveToThread(self.worker_thread)
            self.worker_thread.started.connect(self.worker.run)
            self.worker.finished.connect(
                lambda x: self.set_state(
                    UpdateState.UPDATE_AVAILABLE if x else UpdateState.NO_UPDATE
                )
            )
            self.worker.finished.connect(self.worker_thread.quit)
            self.worker.finished.connect(self.worker.deleteLater)
            self.worker_thread.finished.connect(self.worker_thread.deleteLater)
            self.worker_thread.start()

        elif state == UpdateState.UPDATE_AVAILABLE:
            self.container.setStyleSheet(self._get_style("#283593", "#512DA8"))
            self.icon_label.setText("⬆️")
            self.status_label.setText("Pembaruan baru tersedia!")
            self.action_button.setText("Perbarui Sekarang")

        elif state == UpdateState.NO_UPDATE:
            self.container.setStyleSheet(self._get_style("#1B5E20", "#2E7D32"))
            self.icon_label.setText("✅")
            self.status_label.setText("Aplikasi sudah versi terbaru.")
            self.action_button.setText("Tutup")

        elif state == UpdateState.DOWNLOADING:
            self.container.setStyleSheet(self._get_style("#263238", "#455A64"))
            self.icon_label.setText("💾")
            self.status_label.setText("Mengunduh pembaruan...")
            self.set_log_message("Memulai koneksi...")
            self.action_button.setEnabled(False)
            self.action_button.setText("Mengunduh...")
            self.progress_bar.setValue(0)
            self.close_button.hide()
            self.progress_bar.show()

        elif state == UpdateState.COMPLETED:
            self.container.setStyleSheet(self._get_style("#00695C", "#00897B"))
            self.icon_label.setText("📦")
            self.status_label.setText("Unduhan selesai, siap diinstall.")
            self.action_button.setText("Install Sekarang")
            self.progress_bar.setValue(100)
            self.progress_bar.show()

        elif state == UpdateState.INSTALLING:  # <-- BARU
            self.container.setStyleSheet(self._get_style("#4527A0", "#5E35B1"))
            self.icon_label.setText("⚙️")
            self.status_label.setText("Menginstall pembaruan...")
            self.action_button.setEnabled(False)
            self.action_button.setText("Harap Tunggu...")
            self.progress_bar.hide()
            self.close_button.hide()
            self.run_install_simulation()  # Memulai simulasi instalasi

        elif state == UpdateState.ALL_DONE:  # <-- BARU
            self.container.setStyleSheet(self._get_style("#1B5E20", "#2E7D32"))
            self.icon_label.setText("🎉")
            self.status_label.setText("Aplikasi berhasil diperbarui!")
            self.action_button.hide()
            self.close_button.setText("Selesai")

    def run_install_simulation(self):  # <-- BARU: Simulasi instalasi
        """Simulasi proses instalasi dengan log real-time."""
        QTimer.singleShot(1000, lambda: self.set_log_message("Mengekstrak file..."))
        QTimer.singleShot(
            2500, lambda: self.set_log_message("Menyalin file baru ke direktori...")
        )
        QTimer.singleShot(
            4000, lambda: self.set_log_message("Membersihkan file sementara...")
        )
        QTimer.singleShot(5000, lambda: self.set_state(UpdateState.ALL_DONE))

    def handle_action_click(self):
        """Menangani klik tombol berdasarkan status saat ini."""
        if self.current_state == UpdateState.UPDATE_AVAILABLE:
            self.start_download()
        elif self.current_state == UpdateState.COMPLETED:  # <-- Diubah
            self.set_state(UpdateState.INSTALLING)
        elif self.current_state in [
            UpdateState.NO_UPDATE,
            UpdateState.ALL_DONE,
            UpdateState.CHECKING,
        ]:
            self.close()

    def start_download(self):
        self.set_state(UpdateState.DOWNLOADING)
        url = "https://example.com/file.zip"
        output = "./file.zip"
        self.downloader = Downloader(url, output)
        self.downloader.progress.connect(self.update_progress)
        self.downloader.finished.connect(self.download_finished)
        self.downloader.start()

    def update_progress(self, value):
        self.progress_bar.setValue(value)

    def download_finished(self):
        self.set_state(UpdateState.COMPLETED)

    def show_with_fade_in(self):
        self.animation = QPropertyAnimation(self, b"windowOpacity")
        self.animation.setDuration(100)
        self.animation.setStartValue(0.0)
        self.animation.setEndValue(1.0)
        self.animation.start()
        self.show()

    # Ganti metode _get_style di kelas UpdateWidget Anda dengan ini

    def _get_style(self, color1, color2):
        """Helper untuk menghasilkan stylesheet."""
        return f"""
            #container {{
                background-color: qlineargradient(
                    x1:0, y1:0, x2:1, y2:1, stop:0 {color1}, stop:1 {color2}
                );
                border-radius: 16px;
            }}
            QLabel {{
                color: #FFFFFF; font-size: 16px; font-weight: 500; background-color: transparent;
            }}
            QPushButton {{
                background-color: rgba(255, 255, 255, 0.1); color: #FFFFFF; font-size: 14px;
                font-weight: bold; border-radius: 10px; padding: 8px 16px;
                border: 1px solid rgba(255, 255, 255, 0.2);
            }}
            QPushButton:hover {{
                background-color: rgba(255, 255, 255, 0.2);
            }}
            QPushButton:disabled {{
                background-color: rgba(255, 255, 255, 0.05); color: #AAAAAA;
            }}
            QProgressBar {{
                border: none; border-radius: 6px; background-color: rgba(0, 0, 0, 0.3);
                text-align: center; color: white;
            }}
            QProgressBar::chunk {{
                background-color: #4CAF50; border-radius: 6px;
            }}
            #logLabel {{
                color: #CCCCCC;
                font-size: 12px;
                font-weight: normal;
                background-color: transparent;
            }}
        """
