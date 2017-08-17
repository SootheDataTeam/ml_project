

import pandas as pd
import numpy as np
import datetime as dt

data=pd.read_csv("client book interval.csv")

data.dtypes
data.columns[1]
data.session_date

data.session_date= pd.to_datetime(data.session_date)

#(np.array(data.Date[2:4])-np.array(data.Date[3:5]))/(1000000000*60*24*60)

unique_user_id=sorted(list(set(data.user_id)))

L=len(unique_user_id)
#sorted(x,reverse=True)
#data[data.user_id==109].index
data[data.user_id==i].session_date
book_user_id=[]
book_session_dates=[]

for i in range(L):
    book_user_id.append(unique_user_id[i])
book_user_id=np.array(book_user_id)
for i in range(L):
    book_session_dates.append(list(data[data.user_id==unique_user_id[i]].session_date))

    
len(book_session_dates[0])
unique_user_id[2]
book_session_dates[2]

K=10
outcome=[-1000 for i in range(L)]
i=2


for i in range(L):
    num_book=len(book_session_dates[i])
    if num_book==2:
        outcome[i]=(book_session_dates[i][1]-book_session_dates[i][0]).days
    
    client_session_dates=book_session_dates[i]
    if num_book>=K:
        client_session_dates=book_session_dates[i][(num_book-K):num_book]
        num_book=K
        
    if num_book>2:
       
       client_book_intervals=[]
       temp=np.array(client_session_dates[1:(num_book)])-np.array(client_session_dates[0:(num_book-1)])
       for j in range(num_book-1):
           client_book_intervals.append(temp[j].days)
       client_book_intervals=np.array(client_book_intervals)
       interval_weights=[1 for j in range(num_book-3)]
       interval_weights.extend([2,2])
       #len(interval.weights)
       interval_weights=np.array(interval_weights)/sum(interval_weights)
       outcome[i]=sum(interval_weights*client_book_intervals)

outcome=np.array(outcome)
outcome[0]
outcome=(outcome<=28)*outcome+(outcome>28)*28


book_user_id=book_user_id[outcome>=0]
outcome=outcome[outcome>=0]
len(book_user_id)
len(outcome)

output=pd.DataFrame({"user_id":book_user_id,"outcome":outcome})
output.to_csv("output.csv",index=False)

