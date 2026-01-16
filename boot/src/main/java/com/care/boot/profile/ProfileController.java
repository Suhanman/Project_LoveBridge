package com.care.boot.profile;
import java.util.List;
import com.care.boot.profile.UserDTO;
import com.care.boot.match.MatchDTO;
import com.care.boot.service.MatchService;

import com.care.boot.service.ProfileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class ProfileController {

    @Autowired
    private ProfileService profileService;
    
    @Autowired
    private MatchService matchService;
    
    @GetMapping("/profile")
    public String profilePage() {
        return "/member/profile";  
    }

    @GetMapping("/info")
    public String showUserInfo(Model model) {
        UserDTO user = profileService.getUserInfo(); // 로그인된 사용자 기준
        model.addAttribute("user", user);
        return "/profile/info"; // info.jsp
    }

    @PostMapping("/update")
    public String updateUserInfo(@ModelAttribute UserDTO userDto) {
        profileService.updateUserInfo(userDto);
        return "redirect:/profile/info";
    }
    
    @GetMapping("/traits")
    public String showTraitsForm(Model model) {
        TraitDTO trait = profileService.getTraits(); // 기본 값 로딩
        model.addAttribute("trait", trait);
        return "profile/traits"; // /WEB-INF/views/profile/traits.jsp
    }

    @PostMapping("/traits")
    public String saveTraits(@ModelAttribute TraitDTO traitDto) {
        profileService.saveTraits(traitDto);
        return "redirect:/profile/traits";
    }
    
    @GetMapping("/preference")
    public String showPreferenceForm(Model model) {
        TraitDTO trait = profileService.getTraits(); // 기존 값 불러오기 (동일 DTO 사용)
        model.addAttribute("trait", trait);
        return "profile/preference"; // /WEB-INF/views/profile/preference.jsp
    }

    @PostMapping("/preference")
    public String savePreference(@ModelAttribute TraitDTO dto) {
        profileService.savePreferredTraits(dto);
        return "redirect:/profile/preference";
    }
    
    @GetMapping("/history")
    public String showMatchHistory(Model model) {
        List<MatchDTO> history = matchService.getMatchHistory(); // 더미 or DB 연동
        model.addAttribute("matchHistory", history);
        return "profile/history"; // /WEB-INF/views/profile/history.jsp
    }


    
    

}
