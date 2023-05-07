%% import the data from the curve (set of 5 experiments)
clear all;

h = findobj(gca,'Type','line');
x = h.XData;
y = h.YData;

%%
row = 1;
baseline = x(row,:)*0;

% %figure1 = figure;
% axes1 = axes('Parent',figure1);
% plot(x(row,:), baseline, 'k')
% hold on
% scatter(x(row,:),y(row,:))
% % hold on
% % scatter(retraction(row,:)*1000,force_a(row,:))
% xlabel('Distance [\mum]')
% ylabel('Force [N]')
% box(axes1,'on');
% set(axes1,'FontSize',15)
%%
row = 1;
thresh = -0.021;
baseline = x(row,:)*0;
thresh_line = baseline + thresh;

figure1 = figure;
axes1 = axes('Parent',figure1);

plot(x(row,:),y(row,:),'.k')
hold on
plot(x(row,:), baseline, 'k')
hold on
plot(x(row,:), thresh_line, 'r')

% hold on
% scatter(retraction(row,:)*1000,force_a(row,:))
xlabel('Distance [\mum]')
ylabel('Force [mN]')
box(axes1,'on');
set(axes1,'FontSize',15)
% xlim([-0.08 -0.05])
ylim([-0.5 0.5])
%%
m = 1;             %number of points before positive force
number_point = 500;
force_cal = y(row,:);
approach_cal = x(row,:);
force = force_cal(force_cal< thresh);
y = force - force(1);
depth = approach_cal(force_cal< thresh); % [mm]
x = depth - depth(1);

figure()
plot(x, y, '.r')
%%
[r,c]=size(y);
a = round(c/5);
x1 = x(1:a+2); 
x1=x1-x1(1);
y1 = y(1:a+2); 
y1=y1-y1(1); 
figure()
hold on
plot(x1,y1)

hold on
x2 = x(a+10:2*a-12);
x2=x2-x2(1); 
y2 = y(a+10:2*a-12); 
y2=y2-y2(1); 
plot(x2,y2)

x3 = x(2*a-4:3*a-12); 
x3=x3-x3(1); 
y3 = y(2*a-4:3*a-12); 
y3=y3-y3(1); 
plot(x3,y3)

x4 = x(3*a:4*a-15);
x4=x4-x4(1); 
y4 = y(3*a:4*a-15);
y4=y4-y4(1); 
plot(x4,y4)

x5 = x(4*a:5*a-2); 
x5=x5-x5(1); 
y5 = y(4*a:5*a-2); 
y5=y5-y5(1); 
plot(x5,y5)
%%

NUMBER= [230 221 251 253 256];
N_total= 441;
AF = NUMBER./N_total;  % put right number 
%AF = 0.6;          %It is area fraction    
AT = 0.025*0.025;  %It is the total section m2 
AREA_REAL = AT*AF; 
A1 = AREA_REAL(:,1);
A2 = AREA_REAL(:,2);
A3 = AREA_REAL(:,3);
A4 = AREA_REAL(:,4);
A5 = AREA_REAL(:,5);
%%
Lc = 11.5e-3; 
S1= -y1; %% force obtained from the experimental curve in N 
S2= -y2;
S3= -y3;
S4= -y4;
S5= -y5;

S11= S1(150:300)./A1;
S22= S2(150:300)./A2;
S33= S3(150:300)./A3;
S44= S4(150:300)./A4;
S55= S5(150:300)./A5;

D1=1/Lc*(x1)*1e-3; % Strain= Gap from the experimental curve(m)/ Lc(Characterstic) length????
D2=1/Lc*(x2)*1e-3;
D3=1/Lc*(x3)*1e-3;
D4=1/Lc*(x4)*1e-3;
D5=1/Lc*(x5)*1e-3;

D11=D1(150:300);
D22=D2(150:300);
D33=D3(150:300);
D44=D4(150:300);
D55=D5(150:300);
figure(7)
hold on
title('Force vs strain')
plot(D1,S1./A1)
plot(D2,S2./A2)
plot(D3,S3./A3)
plot(D4,S4./A4)
plot(D5,S5./A5)
% get the value of Eo from linear part and check feed it in the next
% section
Pn1 = polyfit(D11,S11,1);
Pn2 = polyfit(D22,S22,1);
Pn3 = polyfit(D33,S33,1);
Pn4 = polyfit(D44,S44,1);
Pn5 = polyfit(D55,S55,1);

Yfit1 = polyval(Pn1,D11);
Yfit2 = polyval(Pn2,D22);
Yfit3 = polyval(Pn3,D33);
Yfit4 = polyval(Pn4,D44);
Yfit5 = polyval(Pn5,D55);

plot(D11,Yfit1, D22, Yfit2, D33, Yfit3, D44, Yfit4, D55, Yfit5);  
Eo1 = Pn1(1); % this is obtained from initial slop of the curve but is dependent on Lc
Eo2 = Pn2(1); Eo3 = Pn3(1); Eo4 = Pn4(1); Eo5 = Pn5(1);
annotation(gcf,'textbox',[0.2 0.7 0.3 0.18],...
    'String',{['Eo1 = ',num2str(round(Eo1,3)),' Pa'], ['Eo2 = ',num2str(round(Eo2,3)),' Pa'], ['Eo3 = ',num2str(round(Eo3,3)),' Pa'],['Eo4 = ',num2str(round(Eo4,3)),' Pa'], ['Eo5 = ',num2str(round(Eo5,3)),' Pa']});




%%
E1 = (A1)*Eo1;   %% We are examining forces no stress
E2 = (A2)*Eo2;
E3 = (A3)*Eo3;
E4 = (A4)*Eo4;
E5 = (A5)*Eo5;
E = (E1+E2+E3+E4+E5)/5;
%I think, till here there are no fitting parameters, but we should reason those values
%you might change them.   

So = 1.1*E;
%So=0.5;
%So = 0.5e-3*E/Lc;  %It is a fitting parameter %%sigma Weibull
m = 5; %It is a fitting parameter but it is found autoconsistently 
Lm = 5e-3;   % the mushroom length
W = Lm/Lc;    %It is a fitting parameter BUT his vaule is related with the mushroom length   
%before 
%Y = E*D.*exp(-(E*D/So).^m)

Y = E*D1.*exp(-(E*D1/So).^m).*(1-exp(-D1/W));  
% This the new idea, inclusing (1-exp(-D/W)). It means the N mushrooms are reacting slowly. 
%  for D>>W  the system behaves like a simple FBM maybe 
%  W in meters should be in the order of magnitude of the mushroom length 

figure(8)
title('Force vs ExD');
ylabel({'Force/N'})
xlabel({'E \Delta/L_c'})
hold on
plot(E*D1,Y,'k'); 
hold on;
plot(E*D1,S1,E*D2,S2,E*D3,S3,E*D4,S4,E*D5,S5);
annotation(gcf,'textbox',[0.2 0.7 0.3 0.09],...
    'String',{['Lm = ',num2str(round(Lm,4))],['m = ',num2str(round(m,3))], ['\sigma = ',num2str(round(So,3))] });
hold off 


%%
figure(9)
hold on
S1_11 = S1./(E1*D1.*(1-exp(-D1/W)));
S2_22 = S2./(E2*D2.*(1-exp(-D2/W)));
S3_33 = S3./(E3*D3.*(1-exp(-D3/W)));
S4_44 = S4./(E4*D4.*(1-exp(-D4/W)));
S5_55 = S5./(E5*D5.*(1-exp(-D5/W)));
plot(D1,D1.*S1_11*E1,D2,D2.*S2_22*E2,D3, D3.*S3_33*E3, D4, D4.*S4_44*E4, D5, D5.*S5_55*E5)
title('CorrectedForce vs D');
ylabel({'Force/N'})
xlabel({'strain'})

v1 = 0.56;
val1  = find(D1 > v1);
S1_1 = S1_11(val1);
D11 = D1(val1);
val2  = find(D2 > v1);
S2_2 = S2_22(val2);
D22 = D2(val2);
val3  = find(D3 > v1);
S3_3 = S3_33(val3);
D33 = D3(val3);
val4  = find(D4 > v1);
S4_4 = S4_44(val4);
D44 = D4(val4);
val5  = find(D5 > v1);
D55 = D5(val5);
S5_5 = S5_55(val5);


figure(10)
hold on
XN1 =  (E1*D11/So);
XN2 =  (E2*D22/So);
XN3 =  (E3*D33/So);
XN4 =  (E4*D44/So);
XN5 =  (E5*D55/So);

YN1 = -log(S1_1); 
YN2 = -log(S2_2); 
YN3 = -log(S3_3); 
YN4 = -log(S4_4); 
YN5 = -log(S5_5); 

 
%val1  = find(E1*D11/So > 0.49);% does not take into account the beginning 
% val2  = find(E2*D22/So > 0.49);
% val3  = find(E3*D33/So > 0.49);
% val4  = find(E4*D44/So > 0.49) ;
% val5  = find(E5*D55/So > 0.49);

% XN11 = XN1(val1); XN22 = XN2(val2); XN33 = XN3(val3); XN44 = XN4(val4); XN55 = XN5(val5);
% YN11 = YN1(val1); YN22 = YN2(val2); YN33 = YN3(val3); YN44 = YN4(val4); YN55 = YN5(val5);
plot(XN1,YN1, XN2,YN2, XN3,YN3,XN4,YN4, XN5,YN5)
title('first Log');
ylabel({'Log(Force)/N'})
xlabel({'ExD/\sigma'})
%val  = find(E*D>0.06);   % does not take into account the beginning 
figure(11)
plot(log(XN1),log(YN1),log(XN2),log(YN2),log(XN3),log(YN3),log(XN4),log(YN4), log(XN5),log(YN5)); 
hold on;
title('Second Log');
ylabel({'Log(Log(Force))/N'})
xlabel({'Log(ExD/\sigma)'})

[row1,col1] = size(XN1);
[row2,col2] = size(XN2);
[row3,col3] = size(XN3);
[row4,col4] = size(XN4);
[row5,col5] = size(XN5);
col = [col1 col2 col3 col4 col5];
g = min(col);

XN= [XN1(1:g)', XN2(1:g)', XN3(1:g)', XN4(1:g)',XN5(1:g)'];
%uniqueX= intersect(intersect(intersect(intersect((XN1(1:g)),(XN2(1:g))),(XN3(1:g))),XN4(1:g)),XN5(1:g))
uniqueX = unique(XN);

YN11 = interp1(XN1,YN1,uniqueX);
YN22 = interp1(XN2,YN2,uniqueX);
YN33 = interp1(XN3,YN3,uniqueX);
YN44 = interp1(XN4,YN4,uniqueX);
YN55 = interp1(XN5,YN5,uniqueX);
%figure()
%plot(log(uniqueX),log(YN11), log(uniqueX),log(YN22),log(uniqueX),log(YN33),log(uniqueX),log(YN44), log(uniqueX),log(YN55))

%meanY= mean(interpolatedY, 2);
meanY = (YN11+YN22+YN33+YN44+YN55)./5;
dataNoNans_Y = meanY(~isnan(meanY));
dataNoNans_X = uniqueX(~isnan(meanY));
       
Xn_l = log(dataNoNans_X);
Yn_l = log(dataNoNans_Y);
hold on
plot(Xn_l,Yn_l, 'k')
ylabel({'log(log(Force/(E \Delta N(\Delta)/L_c))'})
xlabel({'log(E \Delta/(\sigma_o L_c))'})

Pn = polyfit(Xn_l,Yn_l,1);
Yfit = polyval(Pn,Xn_l);
hold on
plot(Xn_l,Yfit,'k');  
slop = Pn(1);
intercept = Pn(2);
sigma0=exp(-intercept/slop);
annotation(gcf,'textbox',[0.2 0.7 0.3 0.08],...
    'String',{['m = ',num2str(round(slop,2))], ['\sigma_o = ',num2str(round(sigma0,2)), 'N']},...
    'FitBoxToText','off');

  figure(8)
  hold on
  ff= E*D1.*exp(-(E*D1/sigma0).^slop).*(1-exp(-D1/W));  
  plot(E*D1,ff)

% % saving the file 
% %csvwrite('file_name.txt',[Gap(:),F_disp(:),Step_size(:),Attached_pillars(:)], 'sheet1');
% filename_mat = sprintf('%s','WeibullSample361_7_5N_1');
% %filename_mat = sprintf('%s_%d','test',k)
% %filename_mat=['test','.mat']
% save(filename_mat) % save the data from matlab script 


