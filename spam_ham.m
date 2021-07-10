%% assignment 3

clear;
clc;

% reading the database
T = readtable('E:\courses\CS5691\PRML_assignment3\Solutions_me16d206_cs20m025\spam collection.txt','TextType','string');

a='E:\courses\CS5691\PRML_assignment3\Solutions_me16d206_cs20m025\test\';
all_files=dir(a);
all_files=all_files(3:end);
num_dir = numel(all_files);

for i=1:1:num_dir
b=all_files(i).name;

test_char=strcat(a,b);
%Test = readtable('E:\courses\CS5691\PRML_assignment3\test\email1.txt','TextType','string','ReadVariableNames',false);
Test = readtable(test_char,'TextType','string','ReadVariableNames',false);

Test=Test(:,1);
Test1=table2cell(Test);
Test1=vertcat(Test1{:});
Test1=Test1';
Test1=strjoin(Test1,', ');
header={'mail'};
Test1=table(Test1,'VariableNames',header);

% reading the testing mesgs
% T_test=readtalbe('E:\courses\CS5691\smsspamcollection1\spam collection.txt','TextType','string');

T_labels=T(:,1);
T_mail=T(:,2);

length_training=max(size(T_mail));

%T_test=T(35,2);  % test message
T_test=Test1;

length_test=max(size(T_test));

%adding test mail at the end of T_mail
T_mail1=[T_mail; T_test];

%Tlower = lower(T);

T_array=table2array(T_mail1);

documents = tokenizedDocument(T_array);
T_labels_array=table2array(T_labels);

%ignore case
%part of speech details
% stem
% remove stop words
% remove numerical data

documents = addPartOfSpeechDetails(documents);
documents1=removeStopWords(documents);
documents2=replace(documents1,"/"," ");
documents3 = erasePunctuation(documents2);
newDocuments = normalizeWords(documents3,'Style','lemma');

% bag of words
bag1 = bagOfWords(newDocuments);

% removing the test mail from the bag

%tbl = topkwords(bag1,10);

% tfidf
A=tfidf(bag1);
A1=full(A);

% separate the training and test part

A1_training=A1(1:length_training,:);
A1_test=A1(length_training+1:end,:);

% csvm 
Md1=fitcsvm(A1_training,T_labels_array);

% cross validating model

%  cross_mdl=crossval(Md1);
%  modelLoss = kfoldLoss(cross_mdl);
% modelLoss_store(i)=modelLoss;

% predict
%for i=1:1:1
%i=1;
[test_label,score]=predict(Md1,A1_test(1,:));
%end
test_label_store(i)=test_label;
% output the ham or spam
end

celldisp(test_label_store);