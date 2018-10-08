function destMask = resizeMaskToDest(srcMask, rDest, cDest, offset)

[row, col] = find(srcMask);

%calculate the bounding box of mask
bbMinPt = [min(col), min(row)];
bbMaxPt   = [max(col), max(row)];
bbDim  = bbMaxPt - bbMinPt;
bbLen= bbDim(2);
bbHt= bbDim(1);

if (bbHt + offset(1) > cDest)
    offset(1) = cDest - bbHt;
end

if (bbLen + offset(2) > rDest)
    offset(2) = rDest - bbLen;
end

destMask = zeros(rDest, cDest);
destMask(sub2ind([rDest, cDest], row - bbMinPt(2) + offset(2), col - bbMinPt(1) + offset(1))) = 1;
