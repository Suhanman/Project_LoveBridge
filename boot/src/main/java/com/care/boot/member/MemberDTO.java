package com.care.boot.member;

public class MemberDTO {
    private String id;           // 아이디
    private String pw;           // 비밀번호
    private String confirm;      // 비밀번호 확인 (DB 저장 X)
    private String userName;     // 이름
    private String mobile;       // 전화번호
    private String gender;       // 성별
    private String imageUrl;     // 이미지 경로

    // 나의 프로필
    private String my_mbti;
    private String my_smoke;
    private String my_body;
    private String my_style;

    // 이상형 프로필
    private String ideal_mbti;
    private String ideal_smoke;
    private String ideal_body;
    private String ideal_style;

    // Getter & Setter
    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getPw() {
        return pw;
    }
    public void setPw(String pw) {
        this.pw = pw;
    }

    public String getConfirm() {
        return confirm;
    }
    public void setConfirm(String confirm) {
        this.confirm = confirm;
    }

    public String getUserName() {
        return userName;
    }
    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getMobile() {
        return mobile;
    }
    public void setMobile(String mobile) {
        this.mobile = mobile;
    }

    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getImageUrl() {
        return imageUrl;
    }
    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getMy_mbti() {
        return my_mbti;
    }
    public void setMy_mbti(String my_mbti) {
        this.my_mbti = my_mbti;
    }

    public String getMy_smoke() {
        return my_smoke;
    }
    public void setMy_smoke(String my_smoke) {
        this.my_smoke = my_smoke;
    }

    public String getMy_body() {
        return my_body;
    }
    public void setMy_body(String my_body) {
        this.my_body = my_body;
    }

    public String getMy_style() {
        return my_style;
    }
    public void setMy_style(String my_style) {
        this.my_style = my_style;
    }

    public String getIdeal_mbti() {
        return ideal_mbti;
    }
    public void setIdeal_mbti(String ideal_mbti) {
        this.ideal_mbti = ideal_mbti;
    }

    public String getIdeal_smoke() {
        return ideal_smoke;
    }
    public void setIdeal_smoke(String ideal_smoke) {
        this.ideal_smoke = ideal_smoke;
    }

    public String getIdeal_body() {
        return ideal_body;
    }
    public void setIdeal_body(String ideal_body) {
        this.ideal_body = ideal_body;
    }

    public String getIdeal_style() {
        return ideal_style;
    }
    public void setIdeal_style(String ideal_style) {
        this.ideal_style = ideal_style;
    }
}
