# 📱 TH_Flutter

> **Sinh viên:** Nguyễn Quốc Tường
> **MSSV:** 2224802010908
> **Môn học:** Phát triển ứng dụng đa nền tảng
> **Trường:** Đại học Thủ Dầu Một
> **GitHub:** [QuocTuongM](https://github.com/QuocTuongM)

---

## 📂 Cấu trúc Repository

```
TH_Flutter/
├── lab_1/          # Lab 1 - Cài đặt môi trường & App đầu tiên
├── lab_2/          # Lab 2 - Ứng dụng máy tính đơn giản
└── README.md
```

---

## 🗂️ Danh sách bài thực hành

### [Lab 1 - Setting Up Environment & First Application](./lap_1)

Thiết lập môi trường Flutter và xây dựng màn hình profile cá nhân đầu tiên.

**Tính năng:**
- Avatar nổi với animation lên xuống
- Vòng gradient xoay màu quanh avatar
- Hiệu ứng fade-in khi mở app
- Card thông tin sinh viên (Tên, MSSV, Email, Trường)
- Nền tối với glow circles trang trí
<img width="587" height="981" alt="image" src="https://github.com/user-attachments/assets/6d7ff5ee-3fa0-4a90-9c05-64dbf5d68a21" />

---

### [Lab 2 - Simple Mobile Calculator](./lap_2)

Ứng dụng máy tính di động đầy đủ chức năng theo thiết kế Figma.

**Tính năng:**
- Các phép tính cơ bản: `+` `-` `×` `÷`
- Hỗ trợ số thập phân
- Đổi dấu `±` và tính phần trăm `%`
- Xoá từng ký tự `CE` và xoá toàn bộ `C`
- Xử lý lỗi chia cho 0
- Highlight phép toán đang chọn
- Hiển thị biểu thức đầy đủ phía trên
<img width="577" height="994" alt="image" src="https://github.com/user-attachments/assets/373cc2bc-32f8-4656-b9f5-8980076011fd" />

---

## 🛠️ Yêu cầu môi trường

| Công cụ | Phiên bản |
|---------|-----------|
| Flutter | 3.41.6 (Stable) |
| Dart | 3.x |
| Android Studio | Latest |
| Android SDK | 36.1.0 |

---

## 🚀 Cách chạy từng project

```bash
# Clone repo
git clone https://github.com/QuocTuongM/TH_Flutter.git

# Chạy Lab 1
cd TH_Flutter/lap_1
flutter pub get
flutter run

# Chạy Lab 2
cd TH_Flutter/lap_2
flutter pub get
flutter run
```

---

## ✅ Kết quả flutter doctor

```
[✓] Flutter (Channel stable, 3.41.6)
[✓] Windows Version (11 Pro 64-bit, 22H2)
[✓] Android toolchain (Android SDK 36.1.0)
[✓] Chrome
[✓] Connected device (3 available)
```
