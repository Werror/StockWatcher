%%
% matlab test for stock algo
close all
clear all

stockSymble = 'aapl';
numMonth = 4;

[hist_date, hist_high, hist_low, hist_open, hist_close, hist_vol] ...
    = get_hist_stock_yahoo_data(stockSymble, numMonth);

hist_day_diff = hist_close - hist_open;
hist_day_range = hist_high - hist_low;
hist_day_TP = (hist_high + hist_low + hist_close)/3;
hist_day_MACD = ema(hist_day_TP, 12) - ema(hist_day_TP, 26);

% legendStr = {'open','close', 'high', 'low'};
% legendStr = {'price range', 'close > open' , 'open > close','EMA 14', 'EMA 52'};

dispInt = 5; % day interval
dataLen = length(hist_high);
xRange = 1:dataLen;

ema_ribon_width = 8;
hist_day_ema_ribon = zeros(dataLen, ema_ribon_width);
for i = 1:ema_ribon_width
    hist_day_ema_ribon(:,i) = ema(hist_day_TP, 10*i);
end

%%
hf = figure;

ax(1) = subplot(9,1,[1 3]);
% plotyy(xRange, hist_open, xRange, hist_vol);

title(upper(stockSymble));
hold on
candle(hist_high, hist_low, hist_close, hist_open, 'blue');
% plot(xRange, hist_open);
% plot(xRange, hist_close, 'b:')
% plot(xRange, hist_high, 'g')
% plot(xRange, hist_low, 'g:')
% [0.9412 0.4706 0]	Orange
% [0.251 0 0.502]	 Purple
% [0.502 0.251 0]	 Brown
% [0 0.251 0]	 Dark green
% [0.502 0.502 0.502]	Gray
% [0.502 0.502 1]	 Light purple
% [0 0.502 0.502]	 Turquoise
% [0.502 0 0]	 Burgundy 
% [1 0.502 0.502]	 Peach
% plot(xRange, ema(hist_day_TP, 10), 'color', [1 0.2 0]);
% plot(xRange, ema(hist_day_TP, 20), ':', 'color', [1 0.3 0]);
% plot(xRange, ema(hist_day_TP, 30), ':', 'color', [1 0.4 0]);
% plot(xRange, ema(hist_day_TP, 40), ':', 'color', [1 0.5 0]);
% plot(xRange, ema(hist_day_TP, 50), ':', 'color', [1 0.6 0]);
% plot(xRange, ema(hist_day_TP, 60), ':', 'color', [1 0.7 0]);
% plot(xRange, ema(hist_day_TP, 70), ':', 'color', [1 0.8 0]);
% plot(xRange, ema(hist_day_TP, 80), 'color', [1 0.9 0]);
for i = 1:ema_ribon_width
    if i == 1 || i == ema_ribon_width
        plot(xRange, hist_day_ema_ribon(:,i), 'color', [1 1/ema_ribon_width*i, 0]);
    else
        plot(xRange, hist_day_ema_ribon(:,i), ':', 'color', [1 1/ema_ribon_width*i, 0]);
    end
end

% legend(legendStr, 'location','Best')
plot(xRange, hist_day_TP, 'k:');
ylabel('Stock Price $');
hold off
set(gca,'XTick',[1:dispInt:dataLen],'XTickLabel',hist_date(1:dispInt:dataLen))
% xlhand = get(gca,'xlabel');
% set(xlhand,'fontsize',2)
rotateXLabels(gca, 90);
xlim([1 dataLen])


ax(2) = subplot(9,1,5);
ylabel('MACD');
bar(xRange, hist_day_MACD, 'k');
set(gca,'XTick',[1:dispInt:dataLen], 'XTickLabel', [])

ax(3) = subplot(9,1,[6 7]);
ylabel('RSI');
hold on
plot(xRange, rsi(hist_close, 15), 'r');
plot(xRange, 30*ones(1,dataLen), 'b');
plot(xRange, 70*ones(1,dataLen), 'b');
hold off
set(gca,'XTick',[1:dispInt:dataLen], 'XTickLabel', [])
xlim([1 dataLen])
ylim([0 100])


ax(4) = subplot(9,1,[8 9]);
ylabel('CCI');
hold on
plot(xRange, cci(hist_day_TP, 15), 'r');
plot(xRange, 100*ones(1,dataLen), 'b');
plot(xRange, -100*ones(1,dataLen), 'b');
hold off
set(gca,'XTick',[1:dispInt:dataLen], 'XTickLabel', [])
xlim([1 dataLen])

linkaxes(ax,'x');

% bar(xRange, hist_day_diff)
% set(gca,'XTick',[1:dispInt:dataLen], 'XTickLabel', [])
% xlim([1 dataLen])
% subplot(7,1,7)
% plot(xRange, hist_day_range)
% set(gca,'XTick',[1:dispInt:dataLen], 'XTickLabel', [])
% xlim([1 dataLen])



%% 
% subplot(212)
% bar(xRange, hist_vol);
% set(gca,'XTick',[1:dispInt:dataLen],'XTickLabel',hist_date(1:dispInt:dataLen))
% rotateXLabels(gca, 90);
% xlim([1 dataLen])