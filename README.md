# MATLAB Line 推播訊息 (Line Notification)
透過 IFTTT 與 LINE Notify API 建立從 MATLAB 推播的訊息

--- 
版本號 Version Dev.0 (測試版本 R2021b)
---

## 需求 (Requirements)
* IFTTT 帳號 ([申辦流程看這裡](#IFTTT))
* LINE 帳號
* MATLAB (R2016a~)
---

### <a name="IFTTT"></a> IFTTT帳號建立
![IFTTT](https://i.imgur.com/nIedXyU.png)

[官方網站](https://ifttt.com/home)

可以使用 Facebook、Google 或是自己建立免費帳號去使用

<img src="https://i.imgur.com/mlmeXgC.png" width=550 length=350>

---
### 建立 IFTTT Applets

1. 在上方列表中找到 Create 按鈕
<img src="https://i.imgur.com/Xpf8eZT.png" width=550 length=200>
<br>

2. 選擇"If This" Add 去選擇何項功能去接收你的觸發條件
<img src="https://i.imgur.com/3ey6JNf.jpg" width=550 length=350>
<br>

3. 我們將選擇使用 "Webhooks" 服務去接受觸發，後續可以透過RESTful API或是一般<br>
web request 去推送資料
<img src="https://i.imgur.com/x3zrTH2.jpg" width=550 length=350>
<br>

4. 這邊可以先使用簡單的 "Receive Web request"
<img src="https://i.imgur.com/rUX8GIr.jpg" width=550 length=350>
<br>

5. 接下來就可以選擇這個Event所想要取的名稱
<img src="https://i.imgur.com/nZ6vwNv.jpg" width=550 length=350>
<br>

6. 再來就可以來設定，Webhooks接收到request後所要觸發的服務 "Then That"
<img src="https://i.imgur.com/JdwBrqJ.jpg" width=550 length=350>
<br>

7. 接下來就是選擇去觸發 Line Notify API，這功能需要使用者登入Line去給予<br>
服務權限，才能夠使用API。
<img src="https://i.imgur.com/Wci0qTF.jpg" width=550 length=350>
<br>

8. 使用者可以自訂要將訊息推播至個人的群組中或是LINE Notify的聊天室中<br>
訊息的內容使用者可以自訂，其中的{{value1}}等即為後續JSON格式資料裡夾帶<br>
的變量資訊，設定完後就可以點選create action建立服務
  <img src="https://i.imgur.com/Xk0aK1w.jpg" width=550 length=350>
<br>

9. 完成後就可以看到整個邏輯<br>
  &emsp;"STEP 1: 當Webhooks接收到傳送的資料(If This)"<br>
  &emsp;"STEP 2: 就透過LINE Notify 推播你寫好的訊息並填入對應資訊(Then That)"<br>
  最後可以為這套流程取一個自己喜歡的名字
  <img src="https://i.imgur.com/aY4FhEs.jpg" width=550 length=350>
  <img src="https://i.imgur.com/kuOao7G.jpg" width=550 length=350>
  <br>
  
  ---
  ### 功能驗證(Webhooks + LINE Notify)
  
  接下來我們要驗證目前串起來運作正常，如果驗證完沒有問題就可以再到MATLAB去寫觸發的程式
  
  1. 到完成以後的畫面去點選Webhooks的Icon，或是之後可以再在 "My Applets" 中找到<br>
  之前建立的服務去進到Webhooks頁面，進到頁面後找到 "Documentation" 選項
  <img src="https://i.imgur.com/P1XSe9B.png" width=550 length=350>
  <img src="https://i.imgur.com/XQdYM5c.jpg" width=550 length=350>
  <br>
  
  2. 在第一個空位中填入前面幫Webhooks事件所取的名稱，第二行中填上想夾帶的資訊<br>
  如果成功的話應該會在LINE聊天室中看到自己設定的通知格式與對應地方所填入的資料
  <img src="https://i.imgur.com/XQz9GGW.jpg" width=500 length=300>
  <br>
  如果確認沒問題的話，代表這套流程沒問題，大功告成!
  
  ---
  ### 在MATLAB中觸發服務
  
  以下簡單示範，如果執行一個長時間的程式發生錯誤的時候，如何及時發送LINE通知告訴你
  (雖然你也無能為力)
  [Demo Code] <a src="">LineNotification.m</a>
  
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
      json = jsonencode(Error_Content);   % 將struct打包成JSON格式

      % 將錯誤訊息以JSON格式傳送到 IFTTT Webhooks trigger
      opt = weboptions('RequestMethod','post','HeaderFields',{'Content-Type' 'application/json'});
      webwrite(url,json,opt)
    end
    
---
### MATLAB工具箱需求 (MATLAB Toolbox Requirement)
* 無 (None)

## 其他 (Ref.)
LINE Notify API:<br>
https://notify-bot.line.me/doc/en/

MATLAB webwrite:<br>
https://www.mathworks.com/help/matlab/ref/webwrite.html
