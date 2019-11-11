clc,clear;
file_list = {'bark','bikes','ceiling','day_night',...
    'graffiti','leuven','semper','trees','venice','wall'};
for i = 1:length(file_list)
    [I1,I2] = read_img(file_list{i});
    pos1 = HarrisDetector(I1);
    [pos2] = find_matches(I1,pos1,I2);
    %show_matches(I1,I2,pos1,pos2);
end