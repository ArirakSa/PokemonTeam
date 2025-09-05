# Pokémon Team Builder

แอปพลิเคชัน Flutter สำหรับสร้างทีม Pokémon โดยมี Pokémon ให้เลือกทั้งหมด 27 ตัว ผู้ใช้สามารถเลือก Pokémon ได้สูงสุด 3 ตัว พร้อมฟีเจอร์ค้นหาตามชื่อ ตั้งชื่อทีม และบันทึกข้อมูลด้วย GetStorage

#### ฟีเจอร์ที่พัฒนาแล้ว (Enhancements Implemented)

* แสดงรูปภาพ Pokémon จาก PokeAPI ข้างชื่อ
* ผู้ใช้สามารถแก้ไขชื่อทีม และบันทึกชื่อด้วย GetStorage
* มีเอฟเฟกต์/แอนิเมชัน เมื่อเลือกหรือยกเลิกการเลือก Pokémon
* บันทึกข้อมูลทีม (ชื่อ + Pokémon ทั้งหมด) และโหลดกลับมาได้เมื่อเปิดแอปใหม่
* ปุ่ม Reset Team สำหรับรีเซ็ตทีมทั้งหมด
* เพิ่ม Search Bar เพื่อค้นหา Pokémon ตามชื่อ

#### วิธีการรัน

1. Clone โปรเจกต์

   ```bash
   git clone https://github.com/nantiwanM/PokemonTeam.git
   cd PokemonTeam
   ```

2. ติดตั้ง dependencies

   ```bash
   flutter pub get
   ```

3. รันแอปบน Chrome (Web) โดยกำหนด port

   ```bash
   flutter run -d chrome --web-port=5000
   ```

#### ตัวอย่างหน้าจอ

<p align="center">
  <img src="https://github.com/user-attachments/assets/94e47dd1-56f1-4082-af25-c2bad59f2823" width="250"/>
   &nbsp;&nbsp;&nbsp;&nbsp;
  <img src="https://github.com/user-attachments/assets/a125430e-f7f3-44ac-b656-111f233be10b" width="250"/>
</p>

#### เทคโนโลยีที่ใช้

* Flutter
* GetX (State Management + Navigation)
* GetStorage (Local Persistent Storage)
* PokeAPI (ข้อมูล Pokémon)
