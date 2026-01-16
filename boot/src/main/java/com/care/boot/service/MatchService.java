package com.care.boot.service;

import com.care.boot.match.MatchDTO;
import java.util.List;

public interface MatchService {
    List<MatchDTO> getMatchHistory();
}

