# Hướng dẫn Triển khai Hạ tầng AWS với Terraform (Exercise 1)

Dự án này sử dụng Terraform để triển khai một hệ thống hạ tầng hoàn chỉnh trên AWS, bao gồm VPC, EKS Cluster, và các máy chủ EC2 (Bastion & App Server).

## 1. Chuẩn bị môi trường (Environment Setup)

Trước khi chạy mã nguồn, bạn cần cài đặt và cấu hình các công cụ sau:

### Công cụ cần thiết:
* **Terraform**: Phiên bản `>= 1.5.0`.
* **AWS CLI**: Đã được cài đặt và cấu hình với quyền Admin (Sử dụng `aws configure`).
* **kubectl**: Để tương tác với EKS Cluster sau khi triển khai.
* **SSH Key**: Tạo cặp khóa SSH để truy cập vào các máy chủ EC2.

### Cấu hình Terraform:
1. Truy cập vào thư mục `exercise_1/`.
2. Tạo file `terraform.tfvars` từ file ví dụ:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
3. Mở file `terraform.tfvars` và cập nhật các giá trị:
   * `region`: Region bạn muốn triển khai (mặc định `us-east-1`).
   * `ssh_public_key`: Nội dung public key của bạn (ví dụ: nội dung file `~/.ssh/id_rsa.pub`).
   * `allowed_ssh_cidr_blocks`: Danh sách IP được phép SSH (nên để IP cá nhân của bạn để bảo mật).

**Lưu ý về Backend**: Hiện tại cấu hình đang sử dụng S3 làm backend trong file `terraform.tf`. Hãy đảm bảo bucket `vprofileactions0811` đã tồn tại hoặc thay đổi tên bucket phù hợp với tài khoản của bạn. Nếu muốn chạy local hoàn toàn, bạn có thể tạm thời comment đoạn `backend "s3" {}` lại.

## 2. Cách chạy mã nguồn (Deployment)

Thực hiện các lệnh sau theo thứ tự:

### Bước 1: Khởi tạo Terraform
```bash
terraform init
```

### Bước 2: Kiểm tra kế hoạch triển khai
```bash
terraform plan
```

### Bước 3: Triển khai hạ tầng
```bash
terraform apply -auto-approve
```
*Lưu ý: Quá trình triển khai EKS Cluster có thể mất từ 15-20 phút.*

## 3. Kiểm tra kết quả triển khai (Verification)

Sau khi `terraform apply` hoàn tất thành công, bạn có thể kiểm tra kết quả theo các cách sau:

### Kiểm tra qua AWS Console:
* **VPC**: Kiểm tra VPC mới được tạo với các subnet Public và Private.
* **EC2**: Kiểm tra máy chủ Bastion (có IP Public) và App Server (chỉ có IP Private).
* **EKS**: Kiểm tra cluster `gitopsProject-eks` và các Node Group đi kèm.

### Kiểm tra kết nối EKS Cluster:
1. Cập nhật file kubeconfig để kết nối tới cluster:
   ```bash
   aws eks update-kubeconfig --region us-east-1 --name gitopsProject-eks
   ```
2. Kiểm tra danh sách các node:
   ```bash
   kubectl get nodes
   ```

### Kiểm tra kết nối EC2:
1. Lấy IP của Bastion host từ output:
   ```bash
   terraform output bastion_public_ip
   ```
2. Thử kết nối SSH:
   ```bash
   ssh -i /path/to/your/private_key ec2-user@<BASTION_PUBLIC_IP>
   ```

## 4. Dọn dẹp tài nguyên (Cleanup)

Để tránh phát sinh chi phí khi không sử dụng, hãy xóa toàn bộ tài nguyên:
```bash
terraform destroy -auto-approve
```
Hoặc sử dụng script hỗ trợ nếu có:
```bash
./destroy-all.sh
```

