#!/usr/bin/env wolframscript - pwfile /cm/shared/apps/MathLM/mathpass

ballx = Graphics3D[
    Ball[{538.0262548386116`, -229.0584908401729`, -0.9607347083513171`}, 10]
];
Export["testball.png", Show[{ballx}]];

Print["Hello world"]
