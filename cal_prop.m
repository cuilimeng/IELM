function [ bag_prop ] = cal_prop(label, bag_idx, bagnum)
bag_prop = zeros(bagnum, 1);
for i=1:bagnum,
    for j=1:size(label,1),
        if label(j)==1 && bag_idx(j)==i,
            bag_prop(i) = bag_prop(i) + 1;
        end
    end
    bag_prop(i) = bag_prop(i)/(length(find(bag_idx==i)));
end
end

