package com.care.boot.profile;

public class TraitDTO {
    private String bodyType;
    private String personality;
    private String fashionStyle;

    // Getter & Setter
    public String getBodyType() { return bodyType; }
    public void setBodyType(String bodyType) { this.bodyType = bodyType; }

    public String getPersonality() { return personality; }
    public void setPersonality(String personality) { this.personality = personality; }

    public String getFashionStyle() { return fashionStyle; }
    public void setFashionStyle(String fashionStyle) { this.fashionStyle = fashionStyle; }
    
    
    
    private String preferredBodyType;
    private String preferredPersonality;
    private String preferredFashionStyle;

    // Getter & Setter 도 함께 추가해야 함
    public String getPreferredBodyType() { return preferredBodyType; }
    public void setPreferredBodyType(String preferredBodyType) { this.preferredBodyType = preferredBodyType; }

    public String getPreferredPersonality() { return preferredPersonality; }
    public void setPreferredPersonality(String preferredPersonality) { this.preferredPersonality = preferredPersonality; }

    public String getPreferredFashionStyle() { return preferredFashionStyle; }
    public void setPreferredFashionStyle(String preferredFashionStyle) { this.preferredFashionStyle = preferredFashionStyle; }

}


