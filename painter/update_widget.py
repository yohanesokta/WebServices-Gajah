from PyQt6.QtWidgets import (QWidget, QVBoxLayout, QPushButton, 
                             QProgressBar, QLabel, QHBoxLayout, 
                             QGraphicsDropShadowEffect)
from PyQt6.QtCore import Qt, QPropertyAnimation, QTimer
from PyQt6.QtGui import QColor , QMouseEvent
from enum import Enum
from painter.runner.download import Downloader

class UpdateState(Enum):
    """Mendefinisikan status-status yang mungkin terjadi pada widget."""
    CHECKING = 1
    UPDATE_AVAILABLE = 2
    NO_UPDATE = 3
    DOWNLOADING = 4
    COMPLETED = 5
    ERROR = 6

class UpdateWidget(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowFlags(Qt.WindowType.FramelessWindowHint)
        self.setAttribute(Qt.WidgetAttribute.WA_TranslucentBackground)
        
        self.setFixedSize(400, 160)
        self.current_state = None

        # --- UI Elements ---
        shadow_effect = QGraphicsDropShadowEffect(self)
        shadow_effect.setBlurRadius(30)
        shadow_effect.setOffset(0, 5)
        shadow_effect.setColor(QColor(0, 0, 0, 160))

        self.container = QWidget(self)
        self.container.setObjectName("container") # Beri nama objek untuk styling
        self.container.setFixedSize(self.size())
        self.container.setGraphicsEffect(shadow_effect)

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

        self.progress_bar = QProgressBar()
        self.progress_bar.setTextVisible(True)
        self.progress_bar.setFixedHeight(12)
        self.progress_bar.hide()

        self.action_button = QPushButton("Periksa")
        self.action_button.setCursor(Qt.CursorShape.PointingHandCursor)
        self.action_button.clicked.connect(self.handle_action_click)

        main_layout.addLayout(top_row_layout)
        main_layout.addStretch()
        main_layout.addWidget(self.progress_bar)
        main_layout.addWidget(self.action_button, alignment=Qt.AlignmentFlag.AlignRight)

        self.set_state(UpdateState.CHECKING)
        self.show_with_fade_in()

    def mousePressEvent(self, event: QMouseEvent):
        if event.button() == Qt.MouseButton.LeftButton:
            self.drag_pos = event.globalPosition().toPoint() - self.frameGeometry().topLeft()
            event.accept()

    def mouseMoveEvent(self, event: QMouseEvent):
        if event.buttons() == Qt.MouseButton.LeftButton:
            self.move(event.globalPosition().toPoint() - self.drag_pos)
            event.accept()

    def set_state(self, state: UpdateState):
        """Mengatur tampilan widget berdasarkan status yang diberikan."""
        self.current_state = state
        self.progress_bar.hide()
        self.action_button.setEnabled(True)

        if state == UpdateState.CHECKING:
            self.container.setStyleSheet(self._get_style("#1E1E1E", "#2D2D2D"))
            self.icon_label.setText("⏳")
            self.status_label.setText("Memeriksa pembaruan...")
            self.action_button.setText("Batal")
            QTimer.singleShot(2000, lambda: self.set_state(UpdateState.NO_UPDATE))

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
            self.container.setStyleSheet(self._get_style("#1E1E1E", "#2D2D2D"))
            self.icon_label.setText("💾")
            self.status_label.setText("Mengunduh pembaruan...")
            self.action_button.setEnabled(False)
            self.action_button.setText("Mengunduh...")
            self.progress_bar.setValue(0)
            self.progress_bar.show()

        elif state == UpdateState.COMPLETED:
            self.container.setStyleSheet(self._get_style("#00695C", "#00897B"))
            self.icon_label.setText("🎉")
            self.status_label.setText("Pembaruan berhasil diunduh!")
            self.action_button.setText("Selesai")
            self.progress_bar.setValue(100)
            self.progress_bar.show()

    def handle_action_click(self):
        """Menangani klik tombol berdasarkan status saat ini."""
        if self.current_state == UpdateState.UPDATE_AVAILABLE:
            self.start_download()
        elif self.current_state in [UpdateState.NO_UPDATE, UpdateState.COMPLETED, UpdateState.CHECKING]:
            self.close()

    def start_download(self):
        """Memulai proses download."""
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
    
    # === METODE YANG DIPERBAIKI ===
    def show_with_fade_in(self):
        """Menampilkan widget dengan animasi fade-in pada opasitas jendela."""
        # Animasikan windowOpacity secara langsung untuk menghindari konflik painter
        self.animation = QPropertyAnimation(self, b"windowOpacity")
        self.animation.setDuration(500)
        self.animation.setStartValue(0.0)
        self.animation.setEndValue(1.0)
        self.animation.start()
        
        self.show()

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
            QPushButton:hover {{ background-color: rgba(255, 255, 255, 0.2); }}
            QPushButton:disabled {{ background-color: rgba(255, 255, 255, 0.05); color: #AAAAAA; }}
            QProgressBar {{
                border: none; border-radius: 6px; background-color: rgba(0, 0, 0, 0.3);
                text-align: center; color: white;
            }}
            QProgressBar::chunk {{ background-color: #4CAF50; border-radius: 6px; }}
        """