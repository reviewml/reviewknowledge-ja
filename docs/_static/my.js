$(document).ready(function() {
$("div#e8f3c5740dfe774c11a2b84a5d3aa7cb > div > ul > li").prepend("<span class=\"toggle\">▼ </span> ");
  $(".toggle").click(function() {
    $(this).parent().children("ul").toggle();
    if ($(this).parent().children("ul").is(":visible")) {
      $(this).text("▼ ");
    } else {
      $(this).text("▶ ");
    }
  });
});
