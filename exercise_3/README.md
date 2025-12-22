# CI/CD Pipeline cho Microservices với Jenkins & Docker

Bài tập thực hành xây dựng quy trình CI/CD tự động cho ứng dụng Microservices giả lập (User Service & Product Service) sử dụng Jenkins, SonarQube và Docker.

## Tổng quan
Dự án này thực hiện các công việc tự động sau:
1.  **Build:** Tự động đóng gói mã nguồn Python Flask thành Docker Image.
2.  **Test/Analyze:** Phân tích chất lượng mã nguồn bằng SonarQube.
3.  **Deploy:** Tự động triển khai container lên Docker (Localhost) với các port riêng biệt.

## Yêu cầu hệ thống
* **Docker Desktop** (hoặc Docker Engine + Docker Compose) đã được cài đặt.
* **Git** được cài đặt.

## Cấu trúc dự án
Đảm bảo cấu trúc thư mục của bạn giống như sau:

```text
.
├── jenkins-lab/                # Cấu hình Hạ tầng (Infrastructure)
│   ├── docker-compose.yml      # File chạy Jenkins & SonarQube
│   └── Dockerfile              # Custom Image cho Jenkins (đã cài Docker CLI)
│
├── my-microservice-project/    # Mã nguồn ứng dụng (Source Code)
│   ├── service-user/           # Code & Dockerfile của User Service
│   └── service-product/        # Code & Dockerfile của Product Service
│
├── Jenkinsfile                 # Kịch bản Pipeline CI/CD (Nằm ngoài cùng hoặc trong folder project)
└── README.md                   # Hướng dẫn sử dụng
```
## Hướng dẫn Cài đặt & Chạy

### Bước 1: Khởi động Hạ tầng (Jenkins + SonarQube)

1.  Mở terminal tại thư mục gốc của dự án.
2.  Di chuyển vào thư mục `jenkins-lab`:
    ```bash
    cd jenkins-lab
    ```
3.  Chạy lệnh sau để dựng server (Lưu ý: tham số `--build` để cài đặt Docker CLI cho Jenkins):
    ```bash
    docker-compose up -d --build
    ```
4.  Chờ khoảng **2-3 phút** để các dịch vụ khởi động hoàn toàn.

### Bước 2: Cấu hình Jenkins (Lần đầu tiên)

1.  **Lấy mật khẩu Admin:**
    Chạy lệnh sau để xem mật khẩu khởi tạo:
    ```bash
    docker exec -it jenkins-server cat /var/jenkins_home/secrets/initialAdminPassword
    ```
2.  **Đăng nhập:** Truy cập `http://localhost:8081`, nhập mật khẩu và chọn **"Install Suggested Plugins"**.
3.  **Tạo tài khoản Admin:** Điền thông tin user/pass theo ý bạn (Ví dụ: `admin`/`123456`).
4.  **Cài đặt thêm Plugins:**
    * Vào **Manage Jenkins** -> **Plugins** -> **Available plugins**.
    * Tìm và cài 2 plugin:
        * `Docker Pipeline`
        * `SonarQube Scanner`
    * Sau khi cài xong, tích chọn **"Restart Jenkins"** ở cuối trang.

### Bước 3: Cấu hình Kết nối SonarQube

1.  **Cấu hình Server:**
    * Vào **Manage Jenkins** -> **System**.
    * Tìm mục **SonarQube servers**.
    * Check vào ô **"Enable injection of SonarQube server configuration..."**.
    * **Name:** `MySonarServer` (Bắt buộc đúng tên này).
    * **Server URL:** `http://sonarqube:9001` (Lưu ý: cổng 9001).
    * Bấm **Save**.

2.  **Cấu hình Tool:**
    * Vào **Manage Jenkins** -> **Tools**.
    * Tìm mục **SonarQube Scanner installations**.
    * Bấm **Add SonarQube Scanner**.
    * **Name:** `SonarScanner` (Bắt buộc đúng tên này).
    * Check vào ô **"Install automatically"**.
    * Bấm **Save**.

---

## Chạy Pipeline

1.  Trên trang chủ Jenkins, chọn **New Item**.
2.  Đặt tên (VD: `Microservice-Demo`), chọn **Pipeline**, bấm **OK**.
3.  Trong phần cấu hình Pipeline:
    * **Definition:** Chọn `Pipeline script from SCM`.
    * **SCM:** Chọn `Git`.
    * **Repository URL:** Điền link GitHub chứa code của bạn.
    * **Branch Specifier:** `*/main`.
    * **Script Path:** `Jenkinsfile` (Hoặc đường dẫn tới file Jenkinsfile nếu bạn để trong thư mục con).
4.  Bấm **Save**.
5.  Bấm **Build Now** để chạy.

---

## Kết quả

Sau khi Pipeline chạy thành công (màu xanh lá), bạn có thể kiểm tra các dịch vụ tại:

| Dịch vụ | URL Local | Trạng thái mong đợi |
| :--- | :--- | :--- |
| **User Service** | [http://localhost:5001](http://localhost:5001) | Hiển thị: "Service USER..." |
| **Product Service** | [http://localhost:5002](http://localhost:5002) | Hiển thị: "Service PRODUCT..." |
| **SonarQube** | [http://localhost:9000](http://localhost:9001) | Dashboard báo cáo code "Passed" |
| **Jenkins** | [http://localhost:8080](http://localhost:8081) | Pipeline Success |
