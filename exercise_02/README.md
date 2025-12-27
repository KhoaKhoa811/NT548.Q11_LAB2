# Bài Tập 02: Infrastructure as Code với AWS CloudFormation

Dự án này triển khai một hạ tầng AWS bảo mật bao gồm VPC, các subnet public và private, NAT Gateway, và các EC2 instance (Bastion Host và Private App Server) sử dụng AWS CloudFormation.

## 1. Cấu Trúc Thư Mục

```
exercise_02/
├── .gitignore
├── .taskcat.yml            # Cấu hình Taskcat để kiểm thử
├── buildspec.yml           # Đặc tả cho AWS CodeBuild
├── pipeline.yaml           # Định nghĩa CI/CD pipeline
├── README.md               # Tài liệu dự án
└── cloudformation/         # Mã nguồn và script CloudFormation
    ├── deploy.sh           # Script triển khai (deploy)
    ├── destroy.sh          # Script dọn dẹp (cleanup)
    ├── infrastructure.yaml # Template CloudFormation chính
    └── parameters.json     # Các tham số cho Stack
```

## 2. Cài Đặt Môi Trường

Trước khi chạy mã nguồn, hãy đảm bảo bạn đã cài đặt và cấu hình các công cụ sau:

### Yêu cầu tiên quyết

1.  **AWS CLI**: Cài đặt giao diện dòng lệnh AWS.
    - [Hướng dẫn cài đặt](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
    - Kiểm tra cài đặt: `aws --version`
2.  **AWS Credentials**: Cấu hình AWS CLI với thông tin xác thực của bạn.
    - Chạy lệnh: `aws configure`
    - Nhập Access Key ID, Secret Access Key, Region (mặc định: `us-east-1`), và định dạng Output (json).
3.  **EC2 Key Pair**: Bạn cần có một EC2 Key Pair (khóa) tồn tại trong region mục tiêu (`us-east-1` theo mặc định) để truy cập vào các instance.
    - Truy cập AWS Console -> EC2 -> Key Pairs -> Create key pair.
    - Đặt tên (ví dụ: `my-key-pair`) và tải xuống file `.pem`.

## 3. Cấu Hình

Trước khi triển khai, bạn cần kiểm tra và cập nhật file `cloudformation/parameters.json`:

1.  Mở file `cloudformation/parameters.json`.
2.  Cập nhật tham số **`MyPublicIP`** với địa chỉ Public IP hiện tại của bạn (định dạng CIDR, ví dụ: `123.45.67.89/32`). Việc này giới hạn quyền truy cập SSH vào Bastion Host chỉ từ vị trí của bạn.
    - Bạn có thể xem IP của mình tại [whatismyip.com](https://www.whatismyip.com/).
3.  Cập nhật tham số **`KeyPairName`** với tên của EC2 Key Pair bạn đã tạo (ví dụ: `my-key-pair`).

Ví dụ file `parameters.json`:

```json
{
    "Parameters": {
        "VpcCIDR": "10.0.0.0/16",
        "PublicSubnetCIDR": "10.0.1.0/24",
        "PrivateSubnetCIDR": "10.0.2.0/24",
        "AvailabilityZone": "us-east-1a",
        "MyPublicIP": "203.0.113.1/32",  <-- THAY ĐỔI DÒNG NÀY
        "KeyPairName": "my-key-pair",    <-- THAY ĐỔI DÒNG NÀY
        "InstanceType": "t3.micro"
    }
}
```

## 4. Cách Chạy Mã Nguồn

Để triển khai hạ tầng, hãy sử dụng shell script được cung cấp sẵn.

1.  Mở terminal (Bash hoặc Git Bash trên Windows).
2.  Di chuyển vào thư mục `cloudformation` hoặc chạy từ thư mục gốc:
    ```bash
    cd cloudformation
    ./deploy.sh
    ```
3.  Script sẽ thực hiện các bước sau:
    - Kiểm tra xem stack `aws-infra-cf-stack` đã tồn tại chưa.
    - Tạo stack mới hoặc cập nhật stack hiện tại.
    - Chờ quá trình hoàn tất.
    - Hiển thị các output của stack.

## 5. Cách Kiểm Tra Kết Quả Triển Khai

Sau khi triển khai thành công, script sẽ hiển thị một bảng các tài nguyên và lệnh kết nối.

### Kiểm tra CloudFormation Outputs

Bạn sẽ thấy các thông tin như:

- `PublicInstanceIP`: Public IP của Bastion Host.
- `PrivateInstanceIP`: Private IP của App Server.
- `ConnectCommand`: Lệnh SSH để kết nối vào Bastion Host.

### Kiểm Tra Kết Nối

1.  **SSH vào Bastion Host**:
    Chạy lệnh được cung cấp trong phần output (đảm bảo file key `.pem` của bạn đang ở thư mục hiện tại hoặc cung cấp đường dẫn chính xác):

    ```bash
    ssh -i /path/to/your-key-pair.pem ec2-user@<Public-Bastion-IP>
    ```

2.  **Kiểm tra truy cập vào Private Instance**:
    Từ Bastion Host, thử kết nối đến Private App Server bằng Private IP (tìm thấy trong phần outputs):
    ```bash
    ping <Private-App-Server-IP>
    ```
    _(Lưu ý: Bạn sẽ không thể SSH trực tiếp vào private instance trừ khi bạn copy key pair vào bastion host, điều này thường không được khuyến khích vì lý do bảo mật, nhưng lệnh ping sẽ xác nhận kết nối mạng)._

### Dọn Dẹp Resource

Để xóa tất cả các tài nguyên đã tạo và tránh phát sinh chi phí:

```bash
./destroy.sh
```
