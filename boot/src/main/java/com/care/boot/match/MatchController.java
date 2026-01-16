package com.care.boot.match;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.ArrayList;
import java.util.List;

@Controller
public class MatchController {

    @GetMapping("/home")
    public String showMainPage(Model model) {
        List<MatchDTO> matches = new ArrayList<>();
        matches.add(new MatchDTO(1L, "홍길동", 32));
        matches.add(new MatchDTO(2L, "김영희", 30));
        matches.add(new MatchDTO(3L, "박민수", 27));
        matches.add(new MatchDTO(4L, "이지은", 26));

        model.addAttribute("matches", matches);  // main.jsp에서 ${matches}로 접근

        return "/match/loginmain"; // /WEB-INF/views/main.jsp
    }
}
