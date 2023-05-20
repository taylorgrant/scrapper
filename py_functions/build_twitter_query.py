def build_twitter_query(text,username,since,until,retweet,replies):
    import datetime
    q = text
    if username!='':
        q += f" from:{username}"    
    if until=='':
        until = datetime.datetime.strftime(datetime.date.today(), '%Y-%m-%d')
    q += f" lang:en until:{until}"
    if since=='':
        since = datetime.datetime.strftime(datetime.datetime.strptime(until, '%Y-%m-%d') - 
                                           datetime.timedelta(days=7), '%Y-%m-%d')
    q += f" since:{since}"
    if retweet == 'y':
        q += f" exclude:retweets"
    if replies == 'y':
        q += f" exclude:replies"
    if username!='' and text!='':
        filename = f"{since}_{until}_{username}_{text}.csv"
    elif username!="":
        filename = f"{since}_{until}_{username}.csv"
    else:
        filename = f"{since}_{until}_{text}.csv"
    return q
