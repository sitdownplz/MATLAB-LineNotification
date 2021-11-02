try
    a = 0;
    x = a+b;    % 錯誤程式碼
catch Msg
    % 建立網址
    key = '你的Webhooks金鑰';    % IFTTT Webhooks使用者金鑰
    url = ['https://maker.ifttt.com/trigger/GetError/with/key/',...
        key'];    % IFTTT Webhooks trigger 網址

    % 錯誤訊息建構
    Error_Content.value1 = Msg.stack.name;
    Error_Content.value2 = Msg.stack.line;
    Error_Content.value3 = Msg.message;
    json = jsonencode(Error_Content);

    % 將錯誤訊息以JSON格式傳送到 IFTTT Webhooks trigger
    opt = weboptions('RequestMethod','post','HeaderFields',{'Content-Type' 'application/json'});
    webwrite(url,json,opt)
end