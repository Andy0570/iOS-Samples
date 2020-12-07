const WebSocket = require('ws')
const WebSocketServer = WebSocket.Server;

// 创建 websocket 服务器 监听在 3000 端口
const wss = new WebSocketServer({port: 3000})

// 服务器被客户端连接
wss.on('connection', (ws) => {
  // 通过 ws 对象，就可以获取到客户端发送过来的信息和主动推送信息给客户端

  var i=0
    var int = setInterval(function f() {
    ws.send(i++) // 每隔 1 秒给连接方报一次数
  }, 1000)

    // 接收客户端信息并把信息返回发送
  ws.on('message', (message) => {
    ws.send(message, (err) => { // send 方法的第二个参数是一个错误回调函数
      if (err) {
        console.log(`[SERVER] error: ${err}`);
      }
    })
  })
})