package com.care.boot.service;

import com.care.boot.match.MatchDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class MatchServiceImpl implements MatchService {
    @Override
    public List<MatchDTO> getMatchHistory() {
        List<MatchDTO> list = new ArrayList<>();
        list.add(new MatchDTO(1L, "김지원", 26));
        list.add(new MatchDTO(2L, "이수민", 28));
        list.add(new MatchDTO(3L, "박시현", 27));
        return list;
    }
}
