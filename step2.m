%% step2 读取xxx.out
%% Detailed explanation goes here
%   type:%观测报告类型，1-jopnes观测报告经step1.m导出的.out报告；2-编目网观测报告
%   STA:计算大于STA个台站的波速比
%   lev:作图时，vsp下限
%   Zhang ZS. 2020/05/01.JiNan
%   contact:858488045@qq.com
%%
clc;clear;close;fclose('all');
type = 2;  
STA = 3;   
lev = 1.69;
xlm = [119,126];ylm=[38,44];%坐标轴显示范围

switch type
    case 1
        [FileName,PathName, ~] = uigetfile('.\outdata\*.out','Select files');%弹出对话框
        if isequal(FileName,0)  
           disp('User selected Cancel')  
        else  
           EVENT = readc2([PathName,FileName]);event=EVENT;clear EVENT;
        end          
    case 2
        [FileName,PathName, ~] = uigetfile('.\*.txt','Select files');
        if isequal(FileName,0)  
           disp('User selected Cancel')  
        else  
           EVENT = readc1([PathName,FileName]);event=EVENT;clear EVENT;
        end               
end
try
if exist(['./outdata/',FileName,'.smr'],'file') delete(['./outdata/',FileName,'.smr']);end
fidintro = fopen(['./outdata/',FileName,'.smr'],'a+');
if exist('temp.dat','file') delete('temp.dat');end
file = textread('config.inp','%s', 'delimiter', '\n', 'whitespace', '', ...
									'commentstyle', 'matlab');
tol=0;%用于计算地震的个数
for i = 1:length(file) 
    if ~isempty(file(i)) 
        r1 = cell2mat(file(i));r2=str2num(r1);data(i,1:11)=r2; 
    end
end
[mm,nn] = size(data);
lon_rg = data(:,1:(nn-1)/2);lat_rg = data(:,(nn-1)/2+1:end-1);dis=data(:,end);
h1 = figure(1);for i = 1:mm plot(lon_rg(i,:),lat_rg(i,:),'r');hold on;end
xx=importdata('PvBdry_China.mat');
for k=1:length(xx) plot(xx{k}(:,1),xx{k}(:,2),'k');hold on;end
axis equal
xlim(xlm);ylim(ylm);set(gca,'XTick',[xlm(1):2:xlm(2)]);set(gca,'YTick',[ylm(1):2:ylm(2)]);
xlabel('Lontitude/°');ylabel('Latitude/°')
for i = 1:mm %分为mm个区域（多边形）
    uu = 1;pp = 1;
    for j = 1:length(event)
        lon = event(j).event.epicenter(2);lat = event(j).event.epicenter(1);
        in = inpolygon(lon,lat,lon_rg(i,:),lat_rg(i,:));
        if in==1
            eqi_lon(uu) = lon;eqi_lat(uu) = lat;
            id(i,uu) = j;
            uu = uu + 1;
        else
            eqi_lon_out(pp) = lon;eqi_lat_out(pp) = lat;
            pp = pp + 1;
        end
    end    
    colo = [rand,rand,rand];
    Col(i,1:3)=colo;
    plot(eqi_lon,eqi_lat,'.','color',colo,'MarkerSize',10);
    clear eqi_lon eqi_lat;
end
fid = fopen('temp.dat','a+');
for i = 1:mm
    index = find(id(i,:)~=0);temp = id(i,index);
    for j = 1:length(temp)
        fprintf(fid,'%d\t',temp(j));
    end
    fprintf(fid,'\n');
end
fclose(fid);
print(h1,'-dpng',['./figure/','fig1','.png'],'-r200');close(h1);
h2 = figure(2);
[mm,nn]=size(id);
for i = 1:mm % 区域
    tt = 1;
    for j = 1:nn % 区域内地震位置
        id_index = id(i,j);
        if id_index~=0
            if length(event(id_index).event.STA)>=STA
                kk = 1;
                for k = 1:length(event(id_index).event.STA) % 每个地震循环记录台站
                    if ~isempty(datenum(event(id_index).event.STA(k).Sg)) &&...
                            ~isempty(datenum(event(id_index).event.STA(k).Pg))
                        vps0(kk) = (datenum(event(id_index).event.STA(k).Sg) - ...
                            datenum(event(id_index).event.origintime))...
                            /(datenum(event(id_index).event.STA(k).Pg) - ...
                            datenum(event(id_index).event.origintime));
                        kk = kk + 1;
                    end
                end
            end
            vpvs(tt)=median(vps0);
            time(tt)=datenum(event(id_index).event.origintime);
            epi_lon(tt)= event(id_index).event.epicenter(2);
            epi_lat(tt)= event(id_index).event.epicenter(1);
            epi_dep(tt)= event(id_index).event.depth;
            epi_mag(tt)= event(id_index).event.mag;
            tt = tt + 1;
        end
    end
    vpvs = vpvs(vpvs>1.6);time = time(vpvs>1.6);epi_lon = epi_lon(vpvs>1.6);
    epi_lat = epi_lat(vpvs>1.6);epi_lon = epi_lon(vpvs>1.6);epi_dep = epi_dep(vpvs>1.6);
    epi_mag = epi_mag(vpvs>1.6);
    fidout = fopen(['./outdata/',FileName,'_区域',num2str(i),'.vsp'],'wt');
    for pp = 1:length(vpvs)  % 导出数据
        ymdhms = datestr(time(pp),30);
        fprintf(fidout,'%s %.3f %.3f%.1f %.1f  %d %.4f\n',...
            [ymdhms(1:8),ymdhms(10:end)],epi_lat(pp),epi_lon(pp),epi_mag(pp),...
            epi_dep(pp),0,vpvs(pp)); 
    end
    fclose(fidout);   
    % 简单统计
    tol = tol + length(vpvs);vsp_lev = vpvs(vpvs<lev); 
    fprintf(fidintro,'%d %d %.2f\n',length(vpvs),length(vsp_lev),length(vsp_lev)*100/length(vpvs));  
    subplot(mm,1,i)
    if i == mm
        plot(time,vpvs,'.','color',Col(i,:));hold on;plot(time,vpvs,'color',[0.7 0.7 0.7]);hold on
        hm = plot(xlim,[mean(vpvs),mean(vpvs)],'k--');hold on,mvpvs=num2str(mean(vpvs),'%.2f');
        %     legend(hm,mvpvs,'Location','southeastoutside')
        plot(xlim,[lev,lev],'r--'),hold on
        datetick('x','yyyy','keepticks');
        xlabel('year','FontSize',6)
    else
        plot(time,vpvs,'.','color',Col(i,:));hold on;plot(time,vpvs,'color',[0.7 0.7 0.7]);hold on
        hm = plot(xlim,[mean(vpvs),mean(vpvs)],'k--');hold on,mvpvs=num2str(mean(vpvs),'%.2f');
        %     legend(hm,mvpvs,'Location','southeastoutside')
        plot(xlim,[lev,lev],'r--');hold on
        datetick('x','yyyy','keepticks');
        %     set(gca,'xticklabel',[]);
    end
end
fprintf(fidintro,'%d',tol);
print(h2,'-dpng',['./figure/','fig2','.png'],'-r200');
close(h2);fclose(fidintro);
catch ErrorInfo 
    msgbox(ErrorInfo.message);    
end