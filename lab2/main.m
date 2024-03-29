clc,clear;
addpath(genpath('.'));
file_list = {'bark','bikes','ceiling','day_night',...
    'graffiti','leuven','semper','trees','venice','wall'};
Acc = [];
for i = 1:length(file_list)
    [I1,I2] = read_img(file_list{i});
    pos1 = HarrisDetector(I1);
    [pos2 acc] = find_matches(I1,pos1,I2);
    Acc = [Acc,acc];
end
avgacc = mean(Acc);
disp(['Mean Acc:' num2str(avgacc)]);