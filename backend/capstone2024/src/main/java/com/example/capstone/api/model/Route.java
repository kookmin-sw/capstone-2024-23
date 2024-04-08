package com.example.capstone.api.model;

import com.example.capstone.member.model.Member;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@NoArgsConstructor
public class Route {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long nodeIndex;

    private String lat;

    private String lon;

    @ManyToOne
    @JoinColumn(name = "member_uuid")
    private Member member;

}
