package com.care.boot.service;

import com.care.boot.profile.UserDTO;
import com.care.boot.profile.TraitDTO;

import org.springframework.stereotype.Service;

@Service
public class ProfileServiceImpl implements ProfileService {

    @Override
    public UserDTO getUserInfo() {
        // 예시로 더미 데이터 반환
        UserDTO user = new UserDTO();
        user.setName("홍길동");
        user.setAge(25);
        user.setGender("남성");
        return user;
    }

    @Override
    public void updateUserInfo(UserDTO userDto) {
        // DB 업데이트 로직 작성
        System.out.println("업데이트된 정보: " + userDto.getName() + ", " + userDto.getAge() + ", " + userDto.getGender());
    }
    
    @Override
    public TraitDTO getTraits() {
        TraitDTO dto = new TraitDTO();
        dto.setBodyType("보통");
        dto.setPersonality("조용");
        dto.setFashionStyle("캐주얼");
        return dto;
    }

    @Override
    public void saveTraits(TraitDTO dto) {
        System.out.println("특징 저장됨: " + dto.getBodyType() + ", " + dto.getPersonality() + ", " + dto.getFashionStyle());
    }
    
    @Override
    public void savePreferredTraits(TraitDTO dto) {
        System.out.println("선호 특징 저장됨: "
            + dto.getPreferredBodyType() + ", "
            + dto.getPreferredPersonality() + ", "
            + dto.getPreferredFashionStyle());
    }


}
