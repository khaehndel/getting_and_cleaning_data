setwd("C:/Users/kh/Desktop/Coursera/")

    train = read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
    train[,562] = read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
    train[,563] = read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
    
    test = read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
    test[,562] = read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
    test[,563] = read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
    
    Labels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
    
    #Improve feature names for end user readibility
    features = read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)
    features[,2] = gsub('-mean', 'Mean', features[,2])
    features[,2] = gsub('-std', 'Standard_Deviation', features[,2])
    features[,2] = gsub('[-()]', '', features[,2])
    
    #Merge data together 
    New_Data = rbind(train, test)
    
    #Data extraction of Mean and Standard Deviation
    Col <- grep(".*Mean.*|.*Standard_Deviation.*", features[,2])
    
    #Condensing Features
    features <- features[Col,]
    
    #Addition of the subject and activitiy column
    Col_Total <- c(Col, 562, 563)
    
    #Condense New_Data to only data of interest
    Processing_Data <- New_Data[,Col_Total]
    
    #Name new columns 
    colnames(Processing_Data) <- c(features$V2, "Activity", "Subject")
    colnames(Processing_Data) <- tolower(colnames(Processing_Data))
    
    
    currentActivity = 1 
       for (currentActivityLabel in activityLabels$V2) { 
        
          Processing_Data$activity <- gsub(currentActivity, currentActivityLabel, Processing_Data$activity) 
          currentActivity <- currentActivity + 1 
     } 
    
    
    Processing_Data$activity <- as.factor(Processing_Data$activity)
    Processing_Data$subject <- as.factor(Processing_Data$subject)
    
    
    #Tidy Data 
    Tidy_Data = aggregate(Processing_Data, by=list(activity = Processing_Data$activity, subject=Processing_Data$subject), mean)

    #Remove Irrelevant Columns 
    Tidy_Data[,90] = NULL  
    Tidy_Data[,89] = NULL
    
    #Write out new data set
    
    write.table(Tidy_Data, "tidy.txt", sep="\t")
    
    
