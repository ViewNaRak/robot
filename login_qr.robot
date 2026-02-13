*** Settings ***
Library    SeleniumLibrary

*** Variables ***
# ใส่ URL เว็บไซต์ของคุณตรงนี้ (เช่น http://localhost:3000 หรือ IP Address)
${URL}                 http://your-website-url.com
${BROWSER}             chrome

# ตัวระบุตำแหน่ง (Locators) อ้างอิงจากรูปภาพหน้าเว็บที่คุณส่งมา
${BTN_QR_LOGIN}        xpath=//*[contains(text(), "เข้าสู่ระบบด้วยคิวอาร์โค้ด")]
${TEXT_AFTER_LOGIN}    ฐานข้อมูลสุขภาพ

*** Test Cases ***
TC01_Login_With_Line_QR_Success
    [Documentation]    ทดสอบการเข้าสู่ระบบด้วย LINE QR Code (User ต้องสแกนเอง)
    Open Browser To Login Page
    Click QR Code Login Button
    Wait For Manual Scan
    Verify Login Success
    [Teardown]    Close Browser

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    0.5s

Click QR Code Login Button
    # รอจนกว่าปุ่มจะปรากฏ แล้วกดคลิก
    Wait Until Element Is Visible    ${BTN_QR_LOGIN}    timeout=10s
    Click Element                    ${BTN_QR_LOGIN}
    Log To Console    \n--- คลิกปุ่ม QR Code แล้ว ---

Wait For Manual Scan
    # ขั้นตอนนี้สำคัญ: Robot จะรอ 45 วินาที ให้คุณหยิบมือถือมาสแกน
    Log To Console    \n!!! กรุณาหยิบมือถือมาสแกน QR Code ภายใน 45 วินาที !!!
    
    # Robot จะเฝ้าหน้าจอ รอจนกว่าจะเจอคำว่า "ฐานข้อมูลสุขภาพ"
    Wait Until Page Contains    ${TEXT_AFTER_LOGIN}    timeout=45s

Verify Login Success
    # ตรวจสอบว่ามีคำว่า "ฐานข้อมูลสุขภาพ" อยู่บนหน้าจอจริงไหม
    Page Should Contain    ${TEXT_AFTER_LOGIN}
    Log To Console    \n--- เข้าสู่ระบบสำเร็จ (Pass) ---