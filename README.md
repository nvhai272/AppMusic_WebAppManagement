# AppMusic_WebAppManagement - Kiến trúc Client-Server
Backend (Java Spring Boot), Frontend: App Flutter and Web Angular
1. Java Spring Boot: Khởi tạo dự án bằng Spring Initializr là một công cụ web giúp bạn nhanh chóng tạo ra một dự án Spring Boot mới mà không cần phải cấu hình thủ công từ đầu. Bạn có thể chọn các thành phần như dependencies, phiên bản Spring Boot, Java version, và các cấu hình cơ bản khác khi tạo dự án. Nó giúp tiết kiệm thời gian và công sức trong việc thiết lập cấu trúc dự án.
- Lombok: Giúp giảm bớt code bằng cách tự động tạo các phương thức như getter, setter, toString, v.v.
- JWT: Sử dụng JWT để xử lý xác thực (JSON Web Tokens) trong dự án.
- Spring Boot Starters:
  spring-boot-starter-data-jpa: Để sử dụng JPA (Hibernate) cho ORM (Object-Relational Mapping).
  spring-boot-starter-validation: Để sử dụng tính năng kiểm tra dữ liệu.
  spring-boot-starter-web: Để phát triển các ứng dụng web với Spring Boot.
  spring-boot-starter-security: Để tích hợp bảo mật vào ứng dụng.
  spring-boot-starter-test: Để hỗ trợ kiểm thử (trong dự án chưa có kiểm thử)
  spring-boot-starter-data-redis: Để sử dụng Redis cho caching hoặc message broker.
  spring-boot-starter-cache: Để sử dụng các tính năng cache của Spring Boot.
- MySQL: Kết nối cơ sở dữ liệu MySQL.
- Maven Compiler Plugin: Để biên dịch mã nguồn Java với phiên bản Java được chỉ định (Java 17 trong trường hợp này).
- Spring Boot Maven Plugin: Để chạy và đóng gói ứng dụng Spring Boot dưới dạng JAR hoặc WAR.
