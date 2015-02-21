run_analysis <- function(){
        library(dplyr)
        tidy_table <- function(subject_filename,activity_filename,main_filename){
        
        #read in subject data, assiging col name "Subject"
        subject_test=read.table(subject_filename,
                col.names="Subject",header=FALSE)
        
        #read in test labels
        y_test=read.table(activity_filename,
                col.names="ActivityNo",header=FALSE)
                
        #read in feature names
        feature_names=read.table("UCI HAR Dataset/features.txt",header=FALSE,
                stringsAsFactors=FALSE)
        
        #logical vector where feature name contains mean
        mean_features<-grep('mean',feature_names[,2])
        
        #logical vector where feature name contains std
        std_features<-grep('std',feature_names[,2])
        
        #combine two vectors and sort by index
        mean_std_features<-sort(c(mean_features,std_features),decreasing=FALSE)
        
        #subset feature names based using mean-std vector
        feature_names_subset<-feature_names[mean_std_features,]
        
        #numerical vector for the mean-std columns
        feature_cols<-feature_names_subset[,1]
        
        #read in X_test with feature_cols as the column names
        X_test=read.table(main_filename,header=FALSE,
                col.names=feature_names[,2])
        
        #subset using numeric feature cols vector
        X_test_subset <- X_test[,feature_cols]
        
        tidy_data_table<-cbind(subject_test,y_test,X_test_subset)
        
        tidy_data_table
        }
        
        t_table1<-tidy_table("UCI HAR Dataset/test/subject_test.txt",
                             "UCI HAR Dataset/test/y_test.txt",
                             "UCI HAR Dataset/test/X_test.txt")
        t_table2<-tidy_table("UCI HAR Dataset/train/subject_train.txt",
                             "UCI HAR Dataset/train/y_train.txt",
                             "UCI HAR Dataset/train/X_train.txt")
        all_tidy_table<-rbind(t_table1,t_table2)
        
        #read in activity labels
        activity_names=read.table("UCI HAR Dataset/activity_labels.txt",
                                  col.names=c("ActivityNo","ActivityName"),
                                  header=FALSE,stringsAsFactors=FALSE)
        #add activity labels to data
        final_table<- merge(activity_names,all_tidy_table)
        
        #filtered<-filter(final_table, Subject==1)
        
        summary_tidy_table<-final_table %>% group_by(Subject,ActivityName) %>% summarise_each(funs(mean))
        final_summary<-summary_tidy_table[with(summary_tidy_table,order(
                       summary_tidy_table$Subject,summary_tidy_table$ActivityNo)),]
        
        #write table, dropping ActivityNo as no longer required
        write.table(final_summary[,c(1:2,4:82)],file="tidydata.txt",row.names=FALSE)
        
}