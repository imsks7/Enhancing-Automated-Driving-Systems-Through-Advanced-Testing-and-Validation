function X = TestMatrix(v_final,delta_v,Dec_leader,TimeGap,StandstillDistance)
    n = 10;
    v_final_local = linspace(v_final(1),v_final(2),n);
    delta_v_local = linspace(delta_v(1),delta_v(2),n);
    Dec_leader_local = linspace(Dec_leader(1),Dec_leader(2),n);
    TimeGap_local = linspace(TimeGap(1),TimeGap(2),n);
    StandstillDistance_local = linspace(StandstillDistance(1),StandstillDistance(2),n);
    X = combvec(v_final_local,delta_v_local,Dec_leader_local,TimeGap_local,StandstillDistance_local);
    X = X';
end

