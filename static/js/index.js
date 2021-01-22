$(document).ready(function() {
  var socket = io();
  socket.on(
      'connect', function() {
        setInterval(function(){socket.emit("heartbeat"), "i am comming!"},
                    10000);
      });
  socket.on("message", function(data){
                           // console.info(data);
                       });
  socket.on("heartbeat", function(data){
                             // console.info(data);
                         });

  $(".cmd_btn").click(function() {
    var type = $(this)[0].dataset.type;
    switch (type) {
    case "all":
      $.get(
          "clock/all", function(data, status) {
            console.info(data, status);
            $("#info").show();
            $("#history").hide();
            $("#pngs").hide();
            $("#info").empty(div);
          });
      break;
    case "li":
      break;
    case "wang":
      break;
    case "history":
      $.get(
          "list", function(data, status) {
            window._call_mac_data = data;
            var div = "";
            $("#info").hide();
            $("#history").show();
            $("#pngs").hide();
            $("#history").empty(div);
            for (var i = 0, len = data.data.length; i < len; i++) {
              div = "<div class='history_item'";
              div += "data-index='" + i + "'>";
              div += data.data[i].name;
              div += "</div>";
              $("#history").append(div);
            }
          });
      break;
    case "clean":
      break;
    }
  });

  $("#history")
      .on(
          "click", ".history_item", function() {
            $("#info").hide();
            $("#history").hide();
            $("#pngs").show();
            window.aaa = $(this);
            var index = $(this)[0].dataset.index;
            console.info(index);
            var item = window._call_mac_data.data[index];
            for (var i = 0, len = item.length; i < len; i++) {
              div = "<img src='static/logs/" + item.name + i + ".png' alt='" +
                    i + ".png'";
              $("#history").append(div);
            }
          });
});
