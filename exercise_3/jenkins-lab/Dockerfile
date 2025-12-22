# 1. Bắt đầu từ bản Jenkins chính gốc
FROM jenkins/jenkins:lts

# 2. Chuyển sang quyền Root để cài đặt phần mềm
USER root

# 3. Cài đặt Docker CLI
RUN apt-get update && \
    apt-get install -y docker.io && \
    rm -rf /var/lib/apt/lists/*

# 4. (Tùy chọn) Cài thêm Sonar Scanner tự động luôn nếu muốn "xịn" hơn
# Nhưng để đơn giản thì dừng ở bước 3 là đủ sửa lỗi rồi.