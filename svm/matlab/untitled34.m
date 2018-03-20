figure()
for i = 1:5
    subplot(5,1,i)
    hist(reshape(val_errors(:,:,:,i),1,[]))
    mean(reshape(val_errors(:,:,:,i),1,[]))
end