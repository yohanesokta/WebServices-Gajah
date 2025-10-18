import sys
from PyQt6.QtWidgets import QApplication
from painter.update_widget import UpdateWidget

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = UpdateWidget()
    sys.exit(app.exec())
