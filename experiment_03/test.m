clc; clear; close all;
format compact;

s= tf('s');

open_sys = 9/(s^2+9*s+9);
pole(open_sys)