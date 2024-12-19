# Events
Events are a way for Lua to communicate\
with JavaScript by passing JSON data\
that WebUI-GMod helps to process into Lua table/JS objects.

## Theory
To Do

## Practice
### Lua
```lua
timer.Simple(0, function()
  local testUI = webui:create("test")
    --- emit is a method that sends events (messages) to JavaScript
    --- emit(eventData: table, eventType: string)
    :emit({
      color = "yellow",
      username = "smokingplaya"
    }, "user")

  hook.Add("OnPlayerChat", "webuiTest", function(player, message)
    if (!IsValid(testUI)) then
      return
    end

    testUI:emit({
      username = player:Nick(),
      message = message
    }, "chat")
  end)
end)
```
### React (TypeScript)
```tsx
import { useEffect, useState } from "react";

interface Message {
  username: string,
  message: string;
};


export default function App() {
  const [username, setUsername] = useState<string>("n/a");
  const [color, setColor] = useState<string>("black");
  const [chat, setChat] = useState<Message[]>([]);

  const pushMsgToChat = (message: Message) => {
    setChat((prev) => [...prev, message]);
  };

  useEffect(() => {
    //@ts-ignore
    window.addEventListener("message", ({detail}) => {
      console.log(detail);
      switch (detail.type) {
        case "chat":
          pushMsgToChat(detail.body);
          return;
        case "user":
          setUsername(detail.body.username);
          return setColor(detail.body.color);
        default:
          console.log("Unknown eventMessage type");
      }
    });
  }, []);

  return (
    <div style={{
      height: "100%",
      color: color,
      display: "flex",
      flexDirection: "column"
    }}>
      Player: {username}

      <div style={{
        display: "flex",
        flexDirection: "column"
      }}>
        {chat.map((msg, id) => {
          return <span key={id}>{msg.username}: {msg.message}</span>
        })}
      </div>
    </div>
  )
}
```