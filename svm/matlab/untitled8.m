% figure(100);
% hold on;
% for i = 1:size(svm_model.sv_indices,1)
%     i;
%     plot(train_set(svm_model.sv_indices(i),2:end))
% end


% i = 10;
% train_labels(train_range(i)).*all_maxes + all_means(i)
% 

% train_set(i,:).*all_maxes + all_means(train_range(i))



% % offset_pred_label(i)
% prices(1:10)
% train_set(1:5,:) .* all_maxes + all_means(1:5,ones(1,size(train_set,2)))
% train_labels(1:5).* all_maxes + all_means(1:5)

    fig_count = fig_count +1;   figure(fig_count);    clf;
%     subplot(2,1,1);
%     hold on;
%     plot(test_range, test_labels);
%     plot(test_range-1+d, test_pred_labels);
%     plot(train_range, train_labels);
%     plot(train_range-1+d, train_pred_labels);
%     plot(all_set(:,end));
%     legend('actual test', 'prediction test', 'actual train', 'prediction train', 'offset');
%     title(sprintf('normalized, %s, n=%d',s,n));

%     subplot(2,1,2); 
    hold on;
    plot(test_range, usd_test_labels);
    plot(test_range-1+d, usd_test_pred_labels);
    plot(train_range, usd_train_labels);
    plot(train_range-1+d, usd_train_pred_labels);
    plot(all_means);
   %plot(offset_pred_label);
    legend('test data', 'predicted test data', 'training data', 'predicted training data', 'means');
%     title(sprintf('usd, %s, n=%d',s,n));
    title(sprintf('Acutal and Predicted Data, n=%d', n));
    xlabel('time (hours)');
    ylabel('change (USD)');
    
    
figure();
hist(svm_model.sv_indices);
title('Support Vector Distribution');
ylabel('number of SVs');
xlabel('hours');

figure();
plot(svm_model.SVs(1,:))