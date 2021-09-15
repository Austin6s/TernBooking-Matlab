addpath('C:\Users\austi\Documents\Other Projects\TernBooking Matlab')
matchPercent = .25;
commission = .2;
taxRate = 0.17; % San Fran @ 17%
feePercent = 0.15;
hotelPrice = 200;
lowestFactor = 1;

principle = (100:10000);
matchPoints = [200;500;1000;2000;5000;10000;20000;50000;100000];
matchCost = matchPercent*matchPoints;
total = matchPoints+matchCost;

longTotal = principle;

for i = 1:length(matchPoints)
    b = principle >= matchPoints(i);
    longTotal(b) = principle(b) + matchCost(i);

end
longMatch = longTotal - principle;
fee = longMatch.*feePercent;
nightsWithMatch = (longTotal - fee)/(hotelPrice*(1+taxRate));
netCommission = hotelPrice*nightsWithMatch*commission;
revenue = netCommission + fee;
profit = revenue - longMatch;

figure;
%
 hold on
 plot(principle, profit./principle);
 xlims = xlim(gca);
 ylims = ylim(gca);
 plot([xlims(1),xlims(end)],[0,0],'Color','k','LineWidth',1.5)
 plot([0,0],[ylims(1),ylims(end)],'Color','k','LineWidth',1.5)
 plot(principle, profit./principle); grid on
 title('Net Revenue/Profit')
 xlabel('Principle/Savings ($)')
 ylabel('Revenue/Profit Percentage (%)')
%% Sell Price Algorithm
numberNights = 4.9;
discountFactor = 1;
lowestFactor = .919978;
costOfStay = numberNights * hotelPrice;
% matchCost is [50,125,250...]
k80 = .8*matchPoints+[0;matchCost(1:end-1)];
vMatch = matchCost + matchPoints;

profitFunc100 = (hotelPrice*(1+commission-1))*((longTotal - feePercent*longMatch)/...
    (hotelPrice*(1+taxRate))) + feePercent*longMatch - longMatch;

profitFunc80 = (hotelPrice*(.919978+commission-1))*((longTotal - feePercent*longMatch)/...
    (0.919978*hotelPrice*(1+taxRate))) + feePercent*longMatch - longMatch;

conCost = numberNights*discountFactor*hotelPrice;

if conCost > .8*matchPoints(sum(conCost >= matchPoints))+matchCost(sum(conCost >= matchPoints) - 1)
    if (.8*matchPoints(sum(conCost >= matchPoints))+matchCost(sum(conCost >= matchPoints)-1))/(numberNights*hotelPrice) > lowestFactor
        discountFactor = (.8*matchPoints(sum(conCost >= matchPoints))+matchCost(sum(conCost >= matchPoints)-1))/(numberNights*hotelPrice);
    else
        discountFactor = 1;
    end
else
    discountFactor = 1;
end

%% Plot LSR for profit/principle
p = polyfit(principle,profit./principle,1);
plot([100;10000],polyval(p,[100;10000]))

%% Plot LSR for profit
figure;
plot(principle,profitFunc100);
grid on
hold on
p = polyfit(principle,profitFunc100,1);
plot([100;10000],polyval(p,[100;10000]))
