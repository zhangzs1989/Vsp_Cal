%%--step1:ת����ʽ������ļ���outdata�£�xxxx.out
%% Detailed explanation goes here
%   ѡ�����jopens�²����Ĺ۲ⱨ�棬ת�������й������Ŀ���۲ⱨ��
%   Zhang ZS. 2020/05/01.JiNan
%   contact:858488045@qq.com
clc;clear;
[FileName,PathName, ~] = uigetfile('*.txt','Select input files');%�����Ի���
rd_rpt_jopens(PathName,FileName);