package com.care.boot.member;
import java.util.Map;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class MemberController {
    @Autowired
    private MemberService service;

    @Autowired
    private HttpSession session;

    @Autowired
    private KakaoService kakaoService;

    // 회원가입 폼
    @RequestMapping("regist")
    public String regist() {
        return "member/regist";
    }

    // 회원가입 처리
    @PostMapping("registProc")
    public String registProc(MemberDTO member, Model model, RedirectAttributes ra) {
        String msg = service.registProc(member);

        if (msg.equals("회원 등록 완료")) {
            session.setAttribute("member", member); // 프로필 단계로 정보 넘기기 위해 세션에 저장
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/regist";
    }

    // 나의 프로필 페이지
    @RequestMapping("profile")
    public String profile() {
        return "member/profile";
    }

    // 이상형 프로필 페이지
    @RequestMapping("ideal")
    public String ideal() {
        return "member/ideal";
    }

    // 이상형 저장 처리 (최종 회원 정보 저장 위치)
    @PostMapping("saveIdealProfile")
    public String saveIdealProfile(@RequestParam Map<String, String> params, RedirectAttributes ra) {
        MemberDTO member = (MemberDTO) session.getAttribute("member");
        if (member == null) {
            ra.addFlashAttribute("msg", "세션이 만료되었습니다. 다시 시도해주세요.");
            return "redirect:regist";
        }

        // 예시: 이상형 프로필을 member에 설정하고 저장 처리
        // member.setIdealMbti(params.get("idealOption0"));
        // member.setIdealSmoke(params.get("idealOption1"));
        // ... 실제 DTO와 DB 컬럼에 맞게 추가 필요

        String msg = service.saveFinalMemberInfo(member, params);

        session.removeAttribute("member");
        ra.addFlashAttribute("msg", msg);
        return "redirect:index";
    }

    // 로그인 폼
    @RequestMapping("login")
    public String login() {
        return "member/login";
    }

    // 로그인 처리
    @PostMapping("loginProc")
    public String loginProc(String id, String pw, Model model, RedirectAttributes ra) {
        String msg = service.loginProc(id, pw);

        if (msg.equals("로그인 성공")) {
            ra.addFlashAttribute("msg", msg);
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/login";
    }

    // 로그아웃
    @RequestMapping("logout")
    public String logout(RedirectAttributes ra) {
        session.invalidate();
        ra.addFlashAttribute("msg", "로그 아웃");
        kakaoService.unlink(); // 카카오 연동 해제
        return "redirect:index";
    }

    // 회원 리스트 조회
    @RequestMapping("memberInfo")
    public String memberInfo(String select, String search,
                             @RequestParam(value = "currentPage", required = false) String cp,
                             Model model) {
        service.memberInfo(select, search, cp, model);
        return "member/memberInfo";
    }

    // 회원 상세 조회
    @RequestMapping("userInfo")
    public String userInfo(String id, Model model, RedirectAttributes ra) {
        String msg = service.userInfo(id, model);
        if (msg.equals("회원 검색 완료"))
            return "member/userInfo";

        ra.addFlashAttribute("msg", msg);
        return "redirect:memberInfo";
    }

    // 회원정보 수정 폼
    @RequestMapping("update")
    public String update() {
        String sessionId = (String) session.getAttribute("id");
        if (sessionId == null)
            return "redirect:login";

        return "member/update";
    }

    // 회원정보 수정 처리
    @PostMapping("updateProc")
    public String updateProc(MemberDTO member, Model model) {
        String sessionId = (String) session.getAttribute("id");
        if (sessionId == null)
            return "redirect:login";

        member.setId(sessionId);
        String msg = service.updateProc(member);

        if (msg.equals("회원 수정 완료")) {
            session.invalidate();
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/update";
    }

    // 회원 삭제 폼
    @RequestMapping("delete")
    public String delete() {
        String sessionId = (String) session.getAttribute("id");
        if (sessionId == null)
            return "redirect:login";

        return "member/delete";
    }

    // 회원 삭제 처리
    @PostMapping("deleteProc")
    public String deleteProc(MemberDTO member, Model model) {
        String sessionId = (String) session.getAttribute("id");
        if (sessionId == null)
            return "redirect:login";

        member.setId(sessionId);
        String msg = service.deleteProc(member);

        if (msg.equals("회원 삭제 완료")) {
            session.invalidate();
            return "redirect:index";
        }

        model.addAttribute("msg", msg);
        return "member/delete";
    }

    // 카카오 로그인 콜백 처리
    @RequestMapping("kakaoLogin")
    public String kakaoLogin(String code) {
        System.out.println("code : " + code);
        kakaoService.getAccessToken(code);
        kakaoService.getUserInfo();
        return "redirect:index";
    }
}
