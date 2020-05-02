%%--step1:转换格式，输出文件至outdata下，xxxx.out
%% Detailed explanation goes here
%   选择测震jopens下产生的观测报告，转换至近中国地震编目网观测报告
%   Zhang ZS. 2020/05/01.JiNan
%   contact:858488045@qq.com
clc;clear;
[FileName,PathName, ~] = uigetfile('*.txt','Select input files');%弹出对话框
rd_rpt_jopens(PathName,FileName);