## 简介
根据地震局jopens系统产生的地震观测报告，计算地震波速比。
- 分区域计算
- 产生计算结果的简单统计
- 图件（波速比时间变化、区域划分）
## 用法
- step1.m脚本转换梳理原始观测报告数据
- step2.m脚本计算过程
- rd_rpt_jopens.m读取原始观测报告,e.g jopens_report.txt
- readc2.m读取step1.m产生的数据，./xxxx.out
- readc1.m新版正式地震观测报告数据,e.g new_report.txt
- figure文件夹（误删），存储图件
- outdata文件夹(误删)，存储中间结果及最终结果，按config.inp配置的区域
## 示例

```python
```stemp2
%%--step1:转换格式，输出文件至outdata下，xxxx.out
%% Detailed explanation goes here
%   选择测震jopens下产生的观测报告，转换至近中国地震编目网观测报告
%   Zhang ZS. 2020/05/01.JiNan
%   contact:858488045@qq.com
clc;clear;
[FileName,PathName, ~] = uigetfile('*.txt','Select input files');%弹出对话框
rd_rpt_jopens(PathName,FileName);
```
```python
%% step2 读取xxx.out
%% Detailed explanation goes here
%   STA:计算大于STA个台站的波速比
%   lev:作图时，vsp下限
%   Zhang ZS. 2020/05/01.JiNan
%   contact:858488045@qq.com
%%
clc;clear;close;fclose('all');
STA = 6;   %平均波速比台站数
lev = 1.69;% 下限
xlm = [115,123];ylm=[33,41];%坐标轴显示范围
......
```

```python
%%%----------------分区 经度 纬度  震中距范围
%%%         2 —————————————— 
%%%          |              |
%%%          |              |
%%%          |              |
%%%          |              |
%%%         1|——————————————|
%%%           a            b
%%% a   b   b   a   a
%%% 1   1   2   2   1
115  117 117 115 115  35  35 38 38 35 300
117  119 119 117 117 35  35 38 38 35 300
119  122 122 119 119 36  36 38 38 36 300
119  122 122 119 119 35  35 36 36 35 200
```

## 结果
![分区图](https://img-blog.csdnimg.cn/20200501110538997.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)![波速比](https://img-blog.csdnimg.cn/20200501110605128.png?x-oss-process=image/watermark,type_ZmFuZ3poZW5naGVpdGk,shadow_10,text_aHR0cHM6Ly9ibG9nLmNzZG4ubmV0L3dlaXhpbl80Mzk0ODY0NA==,size_16,color_FFFFFF,t_70)
