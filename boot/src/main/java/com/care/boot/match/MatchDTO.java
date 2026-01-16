package com.care.boot.match;

public class MatchDTO {
    private Long id;
    private String name;
    private int age;

    public MatchDTO(Long id, String name, int age) {
        this.id = id;
        this.name = name;
        this.age = age;
    }

    // Getter
    public Long getId() { return id; }
    public String getName() { return name; }
    public int getAge() { return age; }
}
