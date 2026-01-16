package com.care.boot.service;

import com.care.boot.profile.UserDTO;
import com.care.boot.profile.TraitDTO;


public interface ProfileService {
    UserDTO getUserInfo();
    void updateUserInfo(UserDTO userDto);
    
    TraitDTO getTraits();
    void saveTraits(TraitDTO traitDto);
    
    void savePreferredTraits(TraitDTO dto);

}



