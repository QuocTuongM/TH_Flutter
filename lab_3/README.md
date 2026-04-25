# 📱 Ứng dụng Máy Tính Khoa Học (Flutter)

## 📌 Mô tả dự án

Đây là ứng dụng máy tính nâng cao được xây dựng bằng Flutter, hỗ trợ các phép tính cơ bản và các chức năng khoa học tương tự các ứng dụng máy tính trên điện thoại.

---

## 🚀 Chức năng chính

### ✅ Chức năng cơ bản

* Cộng, trừ, nhân, chia (+, -, ×, ÷)
* Xử lý biểu thức có dấu ngoặc ()
* Tuân theo thứ tự ưu tiên phép toán (PEMDAS)
* Hiển thị biểu thức và kết quả

---

### 🔬 Chế độ khoa học

* Hàm lượng giác: sin, cos, tan
* Logarit: log, ln
* Căn bậc hai: √
* Lũy thừa: x², xʸ
* Hằng số: π, e
* Giai thừa: n!

---

### 🧠 Bộ nhớ

* M+: cộng vào bộ nhớ
* M-: trừ khỏi bộ nhớ
* MR: gọi lại giá trị
* MC: xóa bộ nhớ

---

### 📜 Lịch sử

* Lưu các phép tính gần nhất
* Sử dụng SharedPreferences để lưu trữ

---

### ⚙️ Cài đặt

* Điều chỉnh độ chính xác số thập phân
* Chuyển đổi DEG / RAD
* Giới hạn số lượng lịch sử

---

### 🎨 Giao diện

* Giao diện hiện đại, dễ sử dụng
* Hiệu ứng nhấn nút (animation)
* Responsive phù hợp nhiều màn hình

---

## 🏗️ Kiến trúc dự án

```id="struct1"
lib/
  models/
  providers/
  services/
  utils/
  widgets/
  screens/
```

* Sử dụng Provider để quản lý state
* Tách biệt UI và logic
* Tái sử dụng widget

---

## 🧪 Kiểm thử (Testing)

Ứng dụng đã được kiểm thử với các trường hợp:

* Phép toán cơ bản
* Biểu thức có ngoặc
* Hàm khoa học (sin, log, √)
* Xử lý lỗi

Chạy test bằng lệnh:

```bash id="cmd1"
flutter test
```

---

## 🛠️ Công nghệ sử dụng

* Flutter
* Provider (quản lý state)
* SharedPreferences (lưu dữ liệu)
* math_expressions (xử lý biểu thức)

---

## 📸 Hình ảnh minh họa

### 🔹 Giao diện chính

<img width="555" height="1010" alt="image" src="https://github.com/user-attachments/assets/9e949728-807d-49aa-9dd3-027bfca1d154" />

<img width="552" height="1010" alt="image" src="https://github.com/user-attachments/assets/cb4972ad-3157-4568-9c41-b0ecd8eb13a6" />


<img width="548" height="979" alt="image" src="https://github.com/user-attachments/assets/d3fd3132-51ea-41af-b851-01eb016a3f2d" />



### 🔹 Lịch sử tính toán

<img width="528" height="966" alt="image" src="https://github.com/user-attachments/assets/da5307d3-ed63-4007-8c02-fb28d4b519d6" />


---

## ⚠️ Hạn chế

* Chế độ lập trình (programmer mode) chưa hoàn thiện
* Chưa hỗ trợ vẽ đồ thị

---

## 🔮 Hướng phát triển

* Thêm chế độ lập trình (HEX, BIN)
* Vẽ đồ thị hàm số
* Hỗ trợ nhập bằng giọng nói
* Tùy chỉnh giao diện (dark mode)

---

## 👨‍💻 Thông tin sinh viên

* Họ tên: Nguyễn Quốc Tường
* MSSV: 2224802010908
* Môn học: Phát triển ứng dụng di động đa nền tảng

---

## 📅 Ghi chú

* Ứng dụng đã hoàn thành đầy đủ yêu cầu bài thực hành
* Có bổ sung kiểm thử và cải thiện giao diện
